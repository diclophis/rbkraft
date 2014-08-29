#!/usr/bin/env ruby

READ_CHUNKS=4096

require 'open3'
require 'socket'

$running = true
$uid = 0
$server_io = TCPServer.new(ENV["MAVENCRAFT_WRAPPER_PORT"])

Signal.trap("INT") do
  $stdout.puts("saving...")
  $minecraft_stdin.write("save-all\n")
  $minecraft_stdin.write("stop\n")
  $stdout.puts("exiting...")
end

$minecraft_stdin, $minecraft_stdout, $minecraft_stderr, $minecraft_thread = Open3.popen3(ARGV[0], *ARGV[1..-1])

$clients = Hash.new

class Client < Struct.new(:uid, :authentic, :async, :left_over_command)
end

def select_sockets_that_require_action
  select_timeout = 0.01
  selectable_sockets = [$stdin, $minecraft_stdout, $server_io] + $clients.keys
  IO.select(selectable_sockets, nil, selectable_sockets, select_timeout)
end

def accept_new_connection(client_io, authentic = nil)
  #client_io.autoclose = true
  $clients[client_io] = Client.new($uid, authentic)
  $uid += 1
  $stdout.puts(["accept", client_io, $clients[client_io]].inspect)
end

#TODO: don't listen on command socket until server is fully booted
$stdout.puts "started minecraft, server listening"

accept_new_connection($stdin, true)

while $running
  ready_for_reading, ready_for_writing, errored = select_sockets_that_require_action

  ready_for_reading && ready_for_reading.each do |io|
    case io
      when $minecraft_stdout # minecraft bootup output
        $running = !$minecraft_stdout.eof?
        if $running
          broadcast_lines = nil
          begin
            broadcast_lines = $minecraft_stdout.read_nonblock(READ_CHUNKS)
          rescue Errno::EAGAIN, Errno::EIO
            puts "ok"
          rescue Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
            puts "WTF!!!!"
          end
          if broadcast_lines
            broadcast_lines.gsub!("\b", "")
            broadcast_lines.gsub(" ", "")
            #$stdout.puts [:non_request, broadcast_lines.length < 256 ? broadcast_lines : broadcast_lines.length, :sent_to, $clients.keys.length].inspect
            $clients.each_key { |a_io|
              begin
                wrote = a_io.write(broadcast_lines) unless a_io == $stdin
              rescue Errno::ECONNRESET, Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
                $stdout.puts ["quit on epipe in broadcast", $clients[a_io], closed].inspect
                unless a_io == $stdin
                  $clients.delete(a_io)
                  a_io.close unless (a_io.closed?)
                end
                  #|| a_io == $stdin)
              end
            }
          end
        end
      when $server_io # client is connecting over unix socket
        accept_new_connection($server_io.accept_nonblock)
    else # client has request ready for reading

      would_block = false
      would_close = false
      command_line = nil
      command_line_framing_even = false
      begin
        command_lines = io.read_nonblock(READ_CHUNKS) #io.gets
        if command_lines && command_lines.length > 0 && command_lines[command_lines.length - 1] == "\n"
          command_line_framing_even = true
        end
      rescue Errno::EAGAIN, Errno::EIO
        would_block = true
      rescue IOError, Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
        would_close = true
      end
      
      client = $clients[io]

      if command_lines
      #double = false


        all_lines = command_lines.include?("\n") ? (command_lines.split("\n")) : []
        if client
          #puts [:line, command_lines, client.left_over_command].inspect
          if client.left_over_command #&& all_lines[0]
            #puts "got some left over %d %d" % [command_lines.length, client.left_over_command.length]
            if command_lines[0] == "\n"
              #puts "DOUBLE!"
              #double = true
              #all_lines[0] = client.left_over_command + "\n" + all_lines[0]
              all_lines.unshift(client.left_over_command)
              client.left_over_command = nil
            else
              if all_lines[0]
                all_lines[0] = client.left_over_command + all_lines[0]
                client.left_over_command = nil
              else
                #puts "how?"
              end
            end
          end

          unless command_line_framing_even
            if command_lines.include?("\n")
            #puts "pop stash", all_lines.length
                client.left_over_command ||= ""
                client.left_over_command += all_lines.pop
            else
              client.left_over_command ||= ""
              client.left_over_command += command_lines
            end
          end
        end
        #puts [:loop, all_lines.length].inspect
        all_lines.each { |command_line|
          if client
            if command_line.strip == "async"
              client.async = true
              next
            end
            if client.authentic
              command_output = nil
              out_io = (io == $stdin) ? $stdout : io

              begin
                actual_sent_line = command_line.gsub(/[^a-zA-Z0-9\ _\-:\?\{\}\[\],\.\!\"\']/, '')
                if (actual_sent_line && actual_sent_line.length > 0)
                  #puts [:exec, actual_sent_line].inspect
                  $minecraft_stdin.puts(actual_sent_line)
                  if client.async
                    $minecraft_stdout.gets
                  else
                    command_output = $minecraft_stdout.gets.strip
                  end
                end
              rescue Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
                $stdout.puts ["server quit on epipe", closed].inspect
                break
              end

              begin
                if command_output && command_output.length 
                  wrote = out_io.puts(command_output)
                end
              rescue Errno::ECONNRESET, IOError, Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
                $stdout.puts ["quit on epipe", io, $clients[io], closed].inspect
                unless io == $stdin
                  $clients.delete(io)
                  io.close unless io.closed?
                end
              end
            else
              client.authentic = command_line.strip == "authentic"
              unless client.authentic
                $stdout.puts ["quit on un-authentic...!", $clients[io], command_line].inspect
                unless io == $stdin
                  $clients.delete(io)
                  io.close unless io.closed?
                end
              end
            end
          else
            #["not found", {#<IO:<STDIN>>=>#<struct Client uid=0, authentic=true>}, #<TCPSocket:(closed)>]
            if io == $stdin
              $stdout.puts ["WTF", $clients].inspect
            else
              if io.closed?
                $clients.delete(io)
                $stdout.puts ["INTERUP CLOSED", $clients, io].inspect
              else
                $stdout.puts ["not found", $clients, io].inspect
              end
            end
          end
        }
      else
        unless would_block
          if would_close
            $stdout.puts ["quit on eof/econnreset...???", $clients[io]].inspect
            unless io == $stdin
              $clients.delete(io)
              io.close unless (io.closed?)
            end
          end
        end
      end
    end
  end

  #NOTE: this might not be needed?
  errored && errored.each do |io|
    $stdout.puts ["quit on errored", $clients[io]].inspect
    $clients.delete(io)
    io.close unless (io.closed? || io == $stdin)
  end if errored
end

$minecraft_thread.join

$stdout.puts "exited"
