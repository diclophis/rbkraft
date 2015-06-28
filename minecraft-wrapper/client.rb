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
    @server_io = TCPSocket.new(ENV["MAVENCRAFT_SERVER"] || "mavencraft.net", 25566)
    @server_io.sync = true
    if async
      @server_io.puts("authentic\nasync")
    else
      @server_io.puts("authentic")
    end
    @server_io.flush
  end

  def flush_async
    if async
      signal = Time.now.to_f.to_s
      @server_io.puts("say the signal is #{signal}")
      while true
        sleep 0.01
        begin
          break if read_nonblock.include?(signal)
        rescue Errno::EAGAIN, Errno::EIO
          false
        end
      end
    end
  end

  def puts(line)
    @server_io.puts(line)
  end

  def read_nonblock
    @server_io.read_nonblock(1024 * 64)
  rescue Errno::EAGAIN, Errno::EIO
    ''
  end

  def execute_command(command_line, pattern = nil)
    start_time = Time.now

    begin
      @server_io.puts(command_line)
    rescue Errno::EPIPE => e
      puts e.inspect, :oops
      exit 1
    end

    if async
      read_nonblock
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
