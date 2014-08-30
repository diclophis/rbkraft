class Dynasty
  def self.socket_file
    "/tmp/minecraft.sock"
  end

  def self.server
    socket = nil
    ios = []

    if File.exists?(socket_file)
      puts :read
      socket = UNIXSocket.new(socket_file)
    else
      puts :write
      socket = UNIXServer.new(socket_file)
    end

    if socket.is_a?(UNIXServer)
      leader = accept_and_pass(socket, ios)
      return socket, ios
    else
      b = replace_and_read(socket, ios)
      socket.close
      return b, ios
    end
  end

  def self.replace_and_read(socket, ios)
    raise unless ios.empty?

    last = nil
    begin
      while io = socket.recv_io
        puts io.inspect
        last = io
        ios << io
      end
    rescue => e
      puts e.class.inspect
      puts e.inspect
    end

    ios.pop

    puts :grabbed, last, ios.length

    #a = UNIXServer.for_fd(last.fileno)
    #puts a.stat.inspect
    #a

=begin
    puts
    puts last.inspect
    last.reopen(socket)
    puts last.inspect
    last.reopen(socket_file)
    puts last.inspect
    puts
    last
=end

    UNIXServer.for_fd(last.fileno)
  end
  
  def self.rule(socket, ios)
    new_leader = accept_and_pass(socket, ios)

    return true unless new_leader
  end

  def self.accept_and_pass(socket, ios)
    puts :waiting

    replacement = nil

    begin
      replacement = socket.accept_nonblock
     rescue IO::WaitReadable, Errno::EINTR
      return nil
    end

    ios.each do |io|
      puts :sent, replacement.send_io(io)
    end

    replacement.send_io(socket)

    puts :passed, socket

    ios
  end
end
