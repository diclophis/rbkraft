#!/usr/bin/env ruby

require 'open3'
require 'socket'

$stdout.puts ARGV.inspect

$running = true
$uid = 0
$socket = "/tmp/minecraft-wrapper.sock"
$server_io = UNIXServer.new($socket)
$minecraft_stdin, $minecraft_stdout, $minecraft_stderr, $minecraft_thread = Open3.popen3(ARGV[0], *ARGV[1..-1])
$clients = Hash.new

Signal.trap("INT") do
  $stdout.puts("exiting...")
  $running = false
end

def select_sockets_that_require_action
  select_timeout = 1.01
  selectable_sockets = [$stdin, $minecraft_stdout, $server_io] + $clients.keys
  IO.select(selectable_sockets, nil, selectable_sockets, select_timeout)
end

def accept_new_connection
  client_io = $server_io.accept_nonblock
  $uid += 1
  $clients[client_io] = $uid
  $stdout.puts(["accept", $uid].inspect)
end

$stdout.puts "started minecraft, server listening"

while $running
  ready_for_reading, ready_for_writing, errored = select_sockets_that_require_action

  ready_for_reading && ready_for_reading.each do |io|
    case io
      when $minecraft_stdout # minecraft bootup output
        $running = !$minecraft_stdout.eof?
        if $running
          $stdout.puts [:non_request, $minecraft_stdout.readline]
        end
      when $server_io # client is connecting over unix socket
        accept_new_connection
    else # client has request ready for reading
      begin
        if io.closed?
          $stdout.puts ["quit on closed", $clients[io]].inspect
          $clients.delete(io)
        else
          unless io.closed? || io.eof?
            command_line = io.readline
            $minecraft_stdin.puts(command_line)
            blank = 0
            begin
              while command_output = $minecraft_stdout.read_nonblock(1024)
                puts [:raw, command_output].inspect
                out_io = (io == $stdin) ? $stdout : io
                out_io.puts(command_output)
              end
            rescue IO::WaitReadable => wait
              puts "waiting for output"
              IO.select([$minecraft_stdout], nil, nil, 0.01)
              blank += 1
              retry unless blank > 10
            #rescue EOFError => eof
            #  puts "got eof"
            end
          end
        end
      rescue Errno::ECONNRESET => reset
        $stdout.puts ["quit on econnreset...???", $clients[io]].inspect
        $clients.delete(io)
        puts [:client_eof].inspect
      end
    end
  end

  errored && errored.each do |io|
    $stdout.puts ["quit on errored", $clients[io]].inspect
    $clients.delete(io)
  end if errored
end

unless $minecraft_stdout.eof?
  $minecraft_stdin.puts("/stop")
  $stdout.puts($minecraft_stdout.readlines)
end

$minecraft_thread.join
File.unlink($socket)

$stdout.puts "exited"
