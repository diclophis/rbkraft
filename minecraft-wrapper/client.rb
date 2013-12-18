#!/usr/bin/env ruby

require 'open3'
require 'socket'

class MinecraftClient
  def initialize
    @select_timeout = 1.0 
    @max_response_count = 2
    connect
  end

  def connect
    @server_io = UNIXSocket.new("/tmp/minecraft-wrapper.sock")
  end

  def execute_command(command_line)
    #readable, writable, errored = IO.select(nil, [@server_io], nil, @select_timeout)
    #if writable && writable.include?(@server_io)
      @server_io.puts(command_line)
      @server_io.flush
      command_result = ""
      blank = 0
      begin
        while command_output = @server_io.read_nonblock(1)
          blank = 0
          command_result += command_output
          break if command_output == "\n"
        end
      rescue IO::WaitReadable => wait
        IO.select([@server_io], nil, nil, @select_timeout)
        blank += 1
        retry unless blank > @max_response_count
      end

      if command_line.include?("sand")
        sleep 0.6666
      end

      return command_result
    #else
    #  raise "doh"
    #end
  end

  def disconnect
    @server_io.close if @server_io && !@server_io.closed?
  end
end

if __FILE__ == $0
  begin
    client = MinecraftClient.new
    while command_line = $stdin.readline
      puts client.execute_command(command_line)
    end
  rescue EOFError => closed
    client.disconnect
  end
end
