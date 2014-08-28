#!/usr/bin/env ruby

require 'open3'
require 'socket'

class MinecraftClient
  attr_accessor :async

  def initialize(async = false)
    self.async = async
    connect
  end

  def connect
    @server_io = TCPSocket.new("mavencraft.net", 25566)
    @server_io.sync = true
    @server_io.puts("authentic")
    @server_io.flush
  end

  def execute_command(command_line, pattern = nil)
    start_time = Time.now

    @server_io.puts(command_line)

    if async
      begin
        @server_io.read_nonblock(1024)
      rescue Errno::EAGAIN, Errno::EIO
        false # would_block = true
      end
    else
      command_result = ""
      blank = 0

      if pattern
        while line = @server_io.gets
          command_result << line
          if line =~ pattern || Time.now > start_time + 5
            break
          end
        end
      else
        command_result = @server_io.gets
      end

      command_result

    end
  end

  def gets
    @server_io.gets
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
