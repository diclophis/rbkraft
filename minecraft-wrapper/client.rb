#!/usr/bin/env ruby

require 'open3'
require 'socket'

$select_timeout = 0.01
$max_response_count = 5

$server_io = UNIXSocket.new("/tmp/minecraft-wrapper.sock")

def execute_command(command_line)
  $server_io.puts(command_line)
  command_result = ""
  blank = 0
  begin
    while command_output = $server_io.read_nonblock(1024)
      command_result += command_output
    end
  rescue IO::WaitReadable => wait
    IO.select([$server_io], nil, nil, $select_timeout)
    blank += 1
    retry unless blank > $max_response_count
  end

  return command_result
end

if __FILE__ == $0
  begin
    while command_line = $stdin.readline
      puts [:command_result, execute_command(command_line)].inspect
    end
  rescue EOFError => closed
    puts [:exited, closed]
  end
end
