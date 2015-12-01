#!/usr/bin/env ruby

require 'zlib'
require 'open3'
require 'socket'

class MinecraftClient
  attr_accessor :async
  attr_accessor :gzip_buffer_sink
  attr_accessor :gzip_buffer_pump

  READ_CHUNK = 8 * 8 * 1024

  def initialize(async = false)
    self.async = async
    rp, wp = IO.pipe

    self.gzip_buffer_pump, self.gzip_buffer_sink = rp, Zlib::GzipWriter.new(wp)
    connect
  end

  def connect
    @server_io = TCPSocket.new(ENV["MAVENCRAFT_SERVER"] || "mavencraft.net", ENV["MAVENCRAFT_PORT"] || 25566)
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

=begin
      begin
        self.gzip_buffer_sink.close
      rescue Zlib::GzipFile::Error => e
        #$stderr.write(e.inspect)
      end

      while true
        begin
          gzd = self.gzip_buffer_pump.readpartial(READ_CHUNK)
          @server_io.write(gzd)
        rescue EOFError => e
          #$stderr.write(e.inspect)
          break
        end
      end
=end

      signal = Time.now.to_f.to_s
      while true
        @server_io.puts("say the signal is #{signal}")
        sleep 0.1
        begin
          stuff = read_nonblock
          #$stderr.write("stuff: " + stuff + "\n")
          break if stuff.include?(signal)
        rescue Errno::EAGAIN, Errno::EIO
          false
        end
      end

      @server_io.puts("exit")
      @server_io.flush
      disconnect

      connect
    end
  end

  def puts(line)
    if async
      self.gzip_buffer_sink.write(line)
      gzd = self.gzip_buffer_pump.readpartial(READ_CHUNK)
      @server_io.write(gzd)
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

    #$stdout.puts command_line

    sleep 0.0005

    begin
      @server_io.puts(command_line)
    rescue Errno::EPIPE => e
      #e.inspect, :oops
      exit 1
    end

    if async
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
