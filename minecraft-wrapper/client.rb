#!/usr/bin/env ruby

require 'zlib'
require 'open3'
require 'socket'

class MinecraftClient
  attr_accessor :async
  attr_accessor :gzip_buffer_sink
  attr_accessor :gzip_buffer_pump
  attr_accessor :command_count

  READ_CHUNK = 8 * 8 * 1024

  def initialize(async = false)
    self.async = async
    self.command_count = 0

    #rp, wp = IO.pipe
    #self.gzip_buffer_pump, self.gzip_buffer_sink = rp, Zlib::GzipWriter.new(wp)
    connect
  end

  def connect
    last_error = nil

    5.times {
      begin
        @server_io = TCPSocket.new(ENV["MAVENCRAFT_SERVER"] || "127.0.0.1", ENV["MAVENCRAFT_PORT"] || 25566)
        break
      rescue SocketError => e
        last_error = e
        sleep 1
      end
    }

    raise "not connected #{last_error}" unless @server_io

    @server_io.sync = true
    if async
      @server_io.puts("authentic")
    else
      @server_io.puts("authentic\nasync")
    end
    @server_io.flush
  end

  def flush_async
    if async
      execute_command("async")

      @server_io.puts("exit")
      @server_io.flush

      disconnect

      connect
    end
  end

  def puts(line)
    if async
      @server_io.write(line)
    else
      @server_io.puts(line)
    end
  end

  def read_nonblock
    @server_io.read_nonblock(READ_CHUNK)
  rescue Errno::EAGAIN, Errno::EIO #, Errno::ECONNRESET
    ''
  end

  def execute_command(command_line, pattern = nil)
    start_time = Time.now

    begin
      self.command_count += 1
      @server_io.puts(command_line)
    rescue Errno::EPIPE => e
      exit 1
    end

    if async
      $stdout.flush
      #read_nonblock
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
