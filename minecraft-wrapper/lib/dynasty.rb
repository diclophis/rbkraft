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
      #while io = socket.recv_io
      3.times do
        io = socket.recv_io
        puts :gots, io.fileno
        #last = io
        ios << io
      end
    rescue => e
      puts e.class.inspect
      puts e.inspect
    end

    last = ios.pop

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

    #replacement.include(DynastyIO)

    ios.each do |io|
    puts :send, io.fileno
      puts :sent, DynastyIO.send_io2(replacement, io) #replacement.send_io2(io)
    end

    #replacement.send_io(socket)
    puts :send2, socket.fileno
    DynastyIO.send_io2(replacement, socket)

    puts :passed, socket

    ios
  end
end
