#!/usr/bin/env ruby

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
          broadcast_line = $minecraft_stdout.readline
          $stdout.puts [:non_request, broadcast_line].inspect
          $clients.each_key { |a_io|
            begin
              wrote = a_io.write(broadcast_line) unless a_io == $stdin
            rescue Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
              $stdout.puts ["quit on epipe in broadcast", $clients[a_io], closed].inspect
              $clients.delete(a_io)
              a_io.close unless (a_io.closed? || a_io == $stdin)
            end
          }
        end
      when $server_io # client is connecting over unix socket
        accept_new_connection($server_io.accept_nonblock)
    else # client has request ready for reading

      would_block = false
      would_close = false
      command_line = nil
      command_line_framing_even = false
      begin
        command_lines = io.read_nonblock(4096 * 32) #io.gets
        if command_lines && command_lines.length > 0 && command_lines[command_lines.length - 1] == "\n"
          command_line_framing_even = true
        end
      rescue Errno::EAGAIN, Errno::EIO
        would_block = true
      rescue Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
        would_close = true
      end
      
      client = $clients[io]

      if command_lines
        all_lines = command_lines.split("\n")
        if client
          if client.left_over_command
            puts "got some left over " + client.left_over_command.length.to_s
            all_lines[0] = client.left_over_command + all_lines[0]
            client.left_over_command = nil
          end

          unless command_line_framing_even
            client.left_over_command = all_lines.pop
          end
        end
        all_lines.each { |command_line|
          if client
            if command_line.strip == "async"
              puts "got async!!!!"
              client.async = true
              next
            end
            if client.authentic
              command_output = nil
              out_io = (io == $stdin) ? $stdout : io

              begin
                $minecraft_stdin.puts(command_line.gsub(/[^a-zA-Z0-9\ _\-:\?\{\}\[\],\.\!\"\']/, ''))
                command_output = $minecraft_stdout.gets.strip
                command_output = nil if client.async
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
