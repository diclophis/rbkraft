#!/usr/bin/env ruby

require 'open3'
require 'socket'

$select_timeout = 0.01
server_io = UNIXSocket.new("/tmp/minecraft-wrapper.sock")

#1.times {
  server_io.puts("/setblock 10000 80 0 0\n")
  command_result = ""
  blank = 0
  begin
    while command_output = server_io.read_nonblock(1024)
      command_result += command_output
    end
  rescue IO::WaitReadable => wait
    IO.select([server_io], nil, nil, $select_timeout)
    blank += 1
    retry unless blank > 10
  end

  puts [:command_result, command_result].inspect

#  sleep 1
#}

puts "done"

sleep 1

server_io.close

puts "exited"
