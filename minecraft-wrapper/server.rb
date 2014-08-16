#!/usr/bin/env ruby

require 'open3'
require 'socket'

$stdout.puts ARGV.inspect

$running = true
$uid = 0
#$socket = "/tmp/minecraft-wrapper.sock"
#$server_io = UNIXServer.new($socket)
$server_io = TCPServer.new(ENV["MAVENCRAFT_WRAPPER_PORT"])
$minecraft_stdin, $minecraft_stdout, $minecraft_stderr, $minecraft_thread = Open3.popen3(ARGV[0], *ARGV[1..-1])
$clients = Hash.new

Signal.trap("INT") do
  $stdout.puts("exiting...")
  $running = false
end

class Client < Struct.new(:uid, :authentic) 
end

def select_sockets_that_require_action
  select_timeout = 10.0 #0.0001
  selectable_sockets = [$stdin, $minecraft_stdout, $server_io] + $clients.keys
  IO.select(selectable_sockets, nil, selectable_sockets, select_timeout)
end

def accept_new_connection(client_io)
  #client_io = $server_io.accept_nonblock
  #client_io.autoclose = true
  $uid += 1
  $clients[client_io] = Client.new($uid)
  $stdout.puts(["accept", client_io, $clients[client_io]].inspect)
end

#TODO: don't listen on command socket until server is fully booted
$stdout.puts "started minecraft, server listening"

accept_new_connection($stdin)

while $running
  ready_for_reading, ready_for_writing, errored = select_sockets_that_require_action

  ready_for_reading && ready_for_reading.each do |io|
    case io
      when $minecraft_stdout # minecraft bootup output
        $running = !$minecraft_stdout.eof?
        if $running
          $stdout.puts [:non_request, $minecraft_stdout.readline].inspect
        end
      when $server_io # client is connecting over unix socket
        accept_new_connection($server_io.accept_nonblock)
    else # client has request ready for reading
      command_line = io.gets
      if command_line
        client = $clients[io]
        if client
          if client.authentic
            $minecraft_stdin.write(command_line)
            command_output = $minecraft_stdout.gets
            out_io = (io == $stdin) ? $stdout : io
            begin
              wrote = out_io.write(command_output)
            rescue Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
              $stdout.puts ["quit on epipe", $clients[io], closed].inspect
              $clients.delete(io)
            end
          else
            client.authentic = command_line.strip == "/authentic"
            unless client.authentic
              $stdout.puts ["quit on un-authentic...!", $clients[io], command_line].inspect
              io.close
              $clients.delete(io)
            end
          end
        else
          puts ["not found", $clients, io].inspect
        end
      else
        $stdout.puts ["quit on eof/econnreset...???", $clients[io]].inspect
        $clients.delete(io)
      end
    end
  end

  #NOTE: this might not be needed?
  errored && errored.each do |io|
    $stdout.puts ["quit on errored", $clients[io]].inspect
    $clients.delete(io)
  end if errored
end

unless $minecraft_stdout.eof?
  #NOTE: this might be overkill given that INT signal is sent to child process
  $minecraft_stdin.puts("/stop")
  $stdout.puts($minecraft_stdout.readlines)
end

$minecraft_thread.join
#File.unlink($socket)

$stdout.puts "exited"
