#!/usr/bin/env ruby

require 'open3'
require 'socket'
require 'timeout'

class MinecraftClient
  def initialize
    connect
  end

  def connect
    @server_io = TCPSocket.new("mavencraft.net", 25566) #UNIXSocket.new("/tmp/minecraft-wrapper.sock")
    @server_io.sync = true
    @server_io.puts("authentic")
    @server_io.flush
    sleep 1
  end

  def execute_command(command_line)
    @server_io.puts(command_line)
    puts read || 'Timeout::Error Unable to read from socket.'
  end

  def gets
    @server_io.gets
  end

  def read
    output = ''
    timed_out = false

    while not timed_out do
      begin
        Timeout::timeout(0.5) {
          output += gets
        }
      rescue Timeout::Error
        timed_out = true
      end
    end

    output
  end

  def disconnect
    @server_io.close if @server_io && !@server_io.closed?
  end
end

if __FILE__ == $0
  begin
    client = MinecraftClient.new
    while command_line = $stdin.readline
      client.execute_command(command_line)
    end
  rescue EOFError => closed
    client.disconnect
  end
end
