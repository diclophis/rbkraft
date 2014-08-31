require 'open3'
require 'socket'

class Wrapper
  attr_accessor :running, :uid,
                :stdin, :stdout, :stderr,
                :server_io, :clients,
                :minecraft_stdin, :minecraft_stdout, :minecraft_stderr, :minecraft_thread

  def initialize
    self.running = true
    self.uid = 0
    self.install_trap
    self.clients = Hash.new
    self.stdin = $stdin
    self.stdout = $stdout
    self.stderr = $stderr
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
    self.server_io = TCPServer.new(ENV["MAVENCRAFT_WRAPPER_PORT"])
  end

  def create_minecraft_io
    command = ARGV[1]
    options = ARGV[2..-1]
    self.stdout.puts [:wrapping, command, options].inspect
    self.minecraft_stdin, self.minecraft_stdout, self.minecraft_stderr, self.minecraft_thread = Open3.popen3(command, *options)
  end

  def create_descriptors
    descriptors
  end

  def load_descriptors(descriptors)
  end

  def descriptors
    []
  end
end
