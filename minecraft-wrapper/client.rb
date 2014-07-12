#!/usr/bin/env ruby

require 'open3'
require 'socket'

class MinecraftClient
  def initialize
    connect
  end

  def connect
    @server_io = UNIXSocket.new("/tmp/minecraft-wrapper.sock")
    @server_io.sync = true
  end

  def execute_command(command_line)
    @server_io.puts(command_line)
    command_result = ""
    blank = 0

    command_result = @server_io.gets

    if command_line.include?("sand")
      sleep 0.6666
    end

    return command_result
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
