# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/UNIXSocket.html
# http://swtch.com/plan9port/man/man3/sendfd.html
# http://code.swtch.com/plan9port/src/0e6ae8ed3276/src/lib9/sendfd.c
# http://stackoverflow.com/questions/4489433/sending-file-descriptor-over-unix-domain-socket-and-select
# http://ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/Socket.html#method-c-unix_server_socket
# http://ruby-doc.org/core-1.9.2/IO.html#method-i-autoclose-3D
# http://www.jstorimer.com/blogs/workingwithcode/7766087-passing-open-files-between-processes-with-unix-sockets
# http://ruby-doc.org/stdlib-2.0.0/libdoc/socket/rdoc/UNIXServer.html#method-i-accept
# http://apidock.com/ruby/v1_9_3_392/Socket/accept_loop/class
# http://clalance.blogspot.be/2011/01/writing-ruby-extensions-in-c-part-3.html
# http://media.pragprog.com/titles/ruby3/ext_ruby.pdf
# https://github.com/luislavena/rake-compiler
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/UNIXSocket.html#method-i-send_io
# https://blog.jcoglan.com/2012/07/29/your-first-ruby-native-extension-c/

class Dynasty
  def self.server(socket_file, force_start = false)
    socket = nil
    ios = []

    if File.exists?(socket_file)
      begin
        socket = UNIXSocket.new(socket_file)
      rescue Errno::ECONNREFUSED => e
      end
    end

    if socket == nil
      if File.exists?(socket_file)
        raise "server exists, DYNASTY_FORCE to continue" unless force_start
        File.unlink(socket_file)
      end

      socket = UNIXServer.new(socket_file)
    end

    if socket.is_a?(UNIXServer)
      leader = accept_and_pass(socket, ios)
      socket.autoclose = false
      return socket, ios
    else
      b = replace_and_read(socket, ios)
      b.autoclose = false
      socket.close
      return b, ios
    end
  end

  def self.replace_and_read(socket, ios)
    raise unless ios.empty?

    last = nil
    begin
      # NOTE: undocumented second option to recv_io !!!
      types = [IO, IO, IO, TCPServer, UNIXServer]
      while io = socket.recv_io(types[ios.length])
        ios << io
      end
    rescue SocketError => e
      #NOTE: this indicates the old server has stopped sending descriptors
    end

    last = ios.pop

    if last.respond_to?(:fileno)
      last
    else
      UNIXServer.for_fd(last)
    end
  end
  
  def self.rule(socket, ios)
    new_leader = accept_and_pass(socket, ios)

    return true unless new_leader
  end

  def self.accept_and_pass(socket, ios)
    replacement = nil

    begin
      replacement = socket.accept_nonblock
     rescue IO::WaitReadable, Errno::EINTR
      return nil
    end

    ios.each do |io|
      replacement.send_io(io) if io
    end

    replacement.send_io(socket)

    ios
  end
end
