require 'open3'
require 'socket'

READ_CHUNKS = 4

class Wrapper
  class Client < Struct.new(:uid, :authentic, :async, :left_over_command)
  end

  attr_accessor :running, :uid,
                :stdin, :stdout, :stderr,
                :server_io, :clients,
                :minecraft_stdin, :minecraft_stdout, :minecraft_stderr, :minecraft_thread

  def initialize(descriptors)
    self.running = true
    self.uid = 0
    self.install_trap
    self.clients = Hash.new
    self.stdin = $stdin
    self.stdout = $stdout
    self.stderr = $stderr
    if descriptors.empty?
      create_descriptors
    else
      load_descriptors(descriptors)
    end
  end

  def install_trap
    Signal.trap("INT") do
      self.stdout.puts [:trap_int, self, self.uid].inspect
      self.stdout.puts("saving...")
      self.minecraft_stdin.puts("save-all")
      self.minecraft_stdin.puts("stop")
      self.stdout.puts("exiting...")
    end
  end

  def create_server_io
    self.server_io = TCPServer.new(ENV["MAVENCRAFT_WRAPPER_PORT"] || 12345)
  end

  def create_minecraft_io
    command = ARGV[1]
    options = ARGV[2..-1]
    self.stdout.puts [:wrapping, command, options].inspect
    self.minecraft_stdin, self.minecraft_stdout, self.minecraft_stderr, self.minecraft_thread = Open3.popen3(command, *options)
  end

  def create_descriptors
    create_server_io
  end

  def load_descriptors(descriptors)
    self.server_io = descriptors.shift
    raise :no_server_io unless self.server_io

    while client = descriptors.shift
      install_client(client, true)
    end
  end

  def descriptors
    [self.minecraft_stdin, self.minecraft_stdout, self.minecraft_stderr, self.server_io] + self.clients.keys
  end

  def selectable_descriptors
    [self.stdin] + (descriptors - [self.minecraft_stdin, self.minecraft_stderr])
  end

  def accept_server_io_connection
    install_client(self.server_io.accept_nonblock)
  end

  def install_client(client_io, authentic = nil)
    self.clients[client_io] = Client.new(self.uid, authentic)
    self.uid += 1
    self.stdout.puts ["accept", client_io, self.clients].inspect
  end

  def handle_minecraft_stdout
    self.running = !self.minecraft_stdout.eof?
    if self.running
      broadcast_lines = nil
      begin
        broadcast_lines = self.minecraft_stdout.read_nonblock(READ_CHUNKS)
      rescue Errno::EAGAIN, Errno::EIO
        self.stdout.puts [:read_minecraft_stdout_would_block].inspect
      rescue Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
        self.stdout.puts [:read_minecraft_stdout_would_close].inspect
      end
      if broadcast_lines
        broadcast_lines.gsub!("\b", "")
        broadcast_lines.gsub(" ", "")
        self.clients.each_key do |a_io|
          begin
            wrote = a_io.write(broadcast_lines) unless (a_io == self.stdin)
          rescue Errno::ECONNRESET, Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
            self.stdout.puts ["quit on epipe in broadcast write to client", self.clients[a_io], closed].inspect
            unless (a_io == self.stdin) # client_close?
              self.clients.delete(a_io)
              a_io.close unless (a_io.closed?)
            end
          end
        end
      end
    end
  end

  def handle_descriptors_requiring_reading(ready_for_read)
    ready_for_read.each do |readable_io|
    puts readable_io.inspect

      case readable_io
        when self.minecraft_stdout # minecraft has emitted output / command results
          handle_minecraft_stdout
        when self.server_io # client is connecting over unix socket
          accept_server_io_connection
      else # some input from the api server from a client script
          handle_api_client_script(readable_io)
      end
    end
  end

  def handle_api_client_script(readable_io)
    would_block = false
    would_close = false
    command_line = nil
    command_line_framing_even = false
    begin
      command_lines = readable_io.read_nonblock(READ_CHUNKS)
      if command_lines && command_lines.length > 0 && command_lines[command_lines.length - 1] == "\n"
        command_line_framing_even = true
      end
    rescue Errno::EAGAIN, Errno::EIO => e
      would_block = true
    rescue Errno::ENOTCONN, IOError, Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
      would_close = true
    end

    if command_lines
      handle_command_lines(readable_io, command_lines, command_line_framing_even)
    else
      handle_would_block_close(readable_io, would_block, would_close)
    end
  end

  def handle_would_block_close(io, would_block, would_close)
    unless would_block
      if would_close
        self.stdout.puts ["quit on eof/econnreset...???", io, self.clients].inspect
        unless (io == self.stdin) # close_client?
          self.clients.delete(io)
          io.close unless io.closed?
        end
      end
    end
  end

  def handle_command_lines(readable_io, command_lines, command_line_framing_even)
    client = self.clients[readable_io]

    all_lines = command_lines.include?("\n") ? (command_lines.split("\n")) : []

    if client
      if client.left_over_command
        if command_lines[0] == "\n"
          all_lines.unshift(client.left_over_command)
          client.left_over_command = nil
        else
          if all_lines[0]
            all_lines[0] = client.left_over_command + all_lines[0]
            client.left_over_command = nil
          else
            #puts "how?"
          end
        end
      end

      unless command_line_framing_even
        if command_lines.include?("\n")
          client.left_over_command ||= ""
          client.left_over_command += all_lines.pop
        else
          client.left_over_command ||= ""
          client.left_over_command += command_lines
        end
      end
    end

    all_lines.each do |command_line|
      if client
        next if command_async_toggle(command_line)

        if client.authentic
          unless handle_authentic_client(client, readable_io, command_line)
            break
          end
        else
          client.authentic = command_line.strip == "authentic"
          unless client.authentic
            self.stdout.puts ["quit on un-authentic...!", $clients[readable_io], command_line].inspect
            unless (readable_io == self.stdin) # close_client?
              self.clients.delete(readable_io)
              readable_io.close unless readable_io.closed?
            end
          end
        end
      else
        raise :client_not_found # close_client?
=begin
        #["not found", {#<IO:<STDIN>>=>#<struct Client uid=0, authentic=true>}, #<TCPSocket:(closed)>]
        if io == $stdin
          $stdout.puts ["WTF", $clients].inspect
        else
          if io.closed?
            $clients.delete(io)
            $stdout.puts ["INTERUP CLOSED", $clients, io].inspect
          else
            $stdout.puts ["not found", $clients, io].inspect
          end
        end
=end
      end
    end
  end

  def handle_authentic_client(client, io, command_line)
    command_output = nil
    out_io = (io == self.stdin) ? self.stdout : io

    begin
      actual_sent_line = command_line.gsub(/[^a-zA-Z0-9\ _\-:\?\{\}\[\],\.\!\"\']/, '')
      if (actual_sent_line && actual_sent_line.length > 0)
        puts [:exec, actual_sent_line].inspect

        #self.minecraft_stdin.puts(actual_sent_line)
        #if client.async
        #  self.minecraft_stdout.gets
        #else
        #  command_output = self.minecraft_stdout.gets.strip
        #end
      end
    rescue Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
      self.stdout.puts ["server quit on epipe", closed].inspect
      return false
    end

    begin
      if command_output && command_output.length 
        wrote = out_io.puts(command_output)
      end
    rescue Errno::ECONNRESET, IOError, Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
      self.stdout.puts ["quit on epipe", io, self.clients, closed].inspect
      unless (io == self.stdin) # close_client?
        self.clients.delete(io)
        io.close unless io.closed?
      end

      return false
    end

    return true
  end

  def command_async_toggle(command_line)
    if command_line.strip == "async"
      client.async = !client.async
      return true
    end
  end
end
