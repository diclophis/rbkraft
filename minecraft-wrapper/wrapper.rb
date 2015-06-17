require 'open3'
require 'socket'
require 'fcntl'

READ_CHUNKS = 1024 * 64

class Wrapper
  class Client < Struct.new(:uid, :authentic, :async, :left_over_command)
  end

  attr_accessor :running, :uid,
                :stdin, :stdout, :stderr,
                :server_io, :clients,
                :minecraft_stdin, :minecraft_stdout, :minecraft_stderr, :minecraft_thread,
                :prefetched_broadcast,
                :command, :options

  def initialize(descriptors, argv)
    self.install_trap

    self.running = true
    self.uid = 0
    self.clients = Hash.new

    self.stdin = $stdin
    self.stdout = $stdout
    self.stderr = $stderr

    self.command = argv[0]
    self.options = argv[1..-1]

    if descriptors.empty?
      create_descriptors
    else
      load_descriptors(descriptors)
    end

    #self.minecraft_stdin.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
    #self.minecraft_stdout.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
    #self.minecraft_stderr.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)

    #self.clients.each_key do |a_io|
    #  a_io.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
    #end

    self.minecraft_stdin.autoclose = false
    self.minecraft_stdout.autoclose = false
    self.minecraft_stderr.autoclose = false
    self.prefetched_broadcast = ""

    puts self.inspect

    #install_client(self.stdin, true)
  end

  def install_trap
    Signal.trap("INT") do
      write_minecraft_command("save-all")
      write_minecraft_command("stop")
    end
  end

  def create_server_io
    self.server_io = TCPServer.new(ENV["MAVENCRAFT_WRAPPER_PORT"] || 25566)
  end

  def create_minecraft_io
    if self.command
      self.minecraft_stdin, self.minecraft_stdout, self.minecraft_stderr, self.minecraft_thread = Open3.popen3(self.command, *self.options)
    else
      raise "command required for wrapper, sleep works"
    end
  end

  def create_descriptors
    create_server_io
    create_minecraft_io
  end

  def load_descriptors(descriptors)
    self.minecraft_stdin = descriptors.shift
    raise unless self.minecraft_stdin
    self.minecraft_stdout = descriptors.shift
    raise unless self.minecraft_stdout
    self.minecraft_stderr = descriptors.shift
    raise unless self.minecraft_stderr

    self.server_io = descriptors.shift
    raise unless self.server_io

    while client = descriptors.shift
      install_client(client, true)
    end
  end

  def descriptors
    [self.minecraft_stdin, self.minecraft_stdout, self.minecraft_stderr, self.server_io] + (self.clients.keys - [self.stdin])
  end

  def selectable_descriptors
    [self.stdin] + (descriptors)
  end

  def accept_server_io_connection
    install_client(self.server_io.accept_nonblock)
  end

  def install_client(client_io, authentic = nil)
    self.clients[client_io] = Client.new(self.uid, authentic)
    #client_io.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
    self.uid += 1
  end

  def handle_minecraft_stdout
    self.running = (!self.minecraft_stdin.closed? && !self.minecraft_stdout.eof?)
    if self.running
      #while true
        broadcast_lines = nil
        begin
          broadcast_lines = self.minecraft_stdout.read_nonblock(READ_CHUNKS)
        rescue Errno::EAGAIN, Errno::EIO, IOError => e
          #$stderr.write("a #{e.inspect}")
          #break
          return
        rescue Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
          #$stderr.write("b")
          #break
          return
        end

        return if broadcast_lines && broadcast_lines.length == 0

        broadcast_lines = self.prefetched_broadcast + broadcast_lines
        self.prefetched_broadcast = ""

        if broadcast_lines
          if broadcast_lines.length > 0
            self.clients.each_key do |a_io|
              begin
                wrote = a_io.write(broadcast_lines) unless ((a_io == self.stdin) || self.clients[a_io].async)
              rescue Errno::ECONNRESET, Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
                close_client(a_io)
              end
            end
          end
        end
      #end
    end
  end

  def handle_descriptors_requiring_reading(ready_for_read)
    ready_for_read.each do |readable_io|
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
      #self.stdout.puts([command_lines.length, command_lines[0..64]].inspect)
      handle_command_lines(readable_io, command_lines, command_line_framing_even)
    else
      handle_would_block_close(readable_io, would_block, would_close)
    end
  end

  def handle_would_block_close(io, would_block, would_close)
    unless would_block
      if would_close
        close_client(io)
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
        next if command_async_toggle(client, command_line)
        next if command_foo(client, command_line)

        if client.authentic
          unless handle_authentic_client(client, readable_io, command_line)
            break
          end
        else
          client.authentic = command_line.strip == "authentic"
          unless client.authentic
            self.stdout.puts ["quit on un-authentic...!", readable_io, self.clients[readable_io], command_line].inspect
            close_client(readable_io)
          end
        end
      else
        close_client(readable_io)
      end
    end
  end

  def close_client(readable_io)
    unless (readable_io == self.stdin)
      self.clients.delete(readable_io)
      readable_io.close unless readable_io.closed?
    end
  end

  def write_minecraft_command(actual_sent_line)
    #NOTE: this needs to buffer
    retries = 0
    got_stdout = ""
    result = nil
    begin
      result = self.minecraft_stdin.write_nonblock(actual_sent_line + "\n")
    rescue IOError, IO::WaitWritable, Errno::EINTR
      retries += 1
      if retries < (32)
        IO.select(nil, [self.minecraft_stdin], nil, (1.0))
        #begin
        #  got_stdout << self.minecraft_stdout.read_nonblock(READ_CHUNKS)
        #  #if got_stdout && pre_fetched.length > 0
        #  #  self.prefetched_broadcast += pre_fetched
        #  #end
        #rescue Errno::EAGAIN, Errno::EIO
        #rescue Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
        #end
        retry
      else
        puts :failed
        exit 1
      end
    rescue Errno::EPIPE => e
      return "", ""
    end

    return result, got_stdout
  end

  def handle_authentic_client(client, io, command_line)
    #command_output = nil
    out_io = (io == self.stdin) ? self.stdout : io
    pre_fetched = ""
    begin
      actual_sent_line = command_line.gsub(/[^a-zA-Z0-9\ _\-:\?\{\}\[\],\.\!\"\']/, '')
      if (actual_sent_line && actual_sent_line.length > 0)
        _, pre_fetched = write_minecraft_command(actual_sent_line)
        #command_output = self.minecraft_stdout.gets.strip
        begin
          pre_fetched << self.minecraft_stdout.read_nonblock(READ_CHUNKS)
          if pre_fetched && pre_fetched.length > 0
            self.prefetched_broadcast += pre_fetched
          end
        rescue Errno::EAGAIN, Errno::EIO, IOError
        rescue Errno::ETIMEDOUT, Errno::ECONNRESET, EOFError => e
        end
      end
    rescue Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
      return false
    end

=begin
    begin
      if command_output && command_output.length && !client.async
        wrote = out_io.puts(command_output)
      end
    rescue Errno::ECONNRESET, IOError, Errno::EPIPE => closed # NOTE: seems to be a neccesary evil...
      close_client(io)
      return false
    end
=end

    return true
  end

  def command_foo(client, command_line)
    if command_line.strip == "foo"
      self.stdout.puts "did foo"
      return true
    end
  end

  def command_async_toggle(client, command_line)
    if command_line.strip == "async"
      client.async = !client.async
      return true
    end
  end
end
