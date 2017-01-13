require 'open3'
require 'em-websocket'

class WebsocketConnection

  #
  # Initializers

  def initialize(std_in, std_out, std_err, thread, websocket)
    @minecraft_stdin = std_in
    @minecraft_stdout = std_out
    @minecraft_stderr = std_err
    @minecraft_thread = thread
    @websocket = websocket
  end


  #
  # Controls

  def publish_message(message)
    puts 'PUBLISHING TO SOME CLIENT:'
    puts message
    @websocket.send(message)
  end

  def get_std_out
    output = ''
    timed_out = false

    while not timed_out do
      begin
        Timeout::timeout(0.5) {
          output += @minecraft_stdout.gets
        }
      rescue Timeout::Error
        timed_out = true
      end
    end
    publish_message(output) unless output.empty?
  end


  #
  # Events

  # EM::WebSocket::Handshake handshake
  def on_open(handshake)
    get_std_out
  end

  def on_close
    publish_message('CLIENT OR SERVER DISCONNECTING')
  end

  def on_message(message)
    puts "RECEIVED: #{message}"
    @minecraft_stdin.puts(message)
    get_std_out
  end
end


#
# Main

$minecraft_stdin, $minecraft_stdout, $minecraft_stderr, $minecraft_thread = Open3.popen3(ARGV[0], *ARGV[1..-1])

EM.run do
  EM::WebSocket.run(:host => "127.0.0.1", :port => 8080) do |websocket|
    server = WebsocketConnection.new($minecraft_stdin, $minecraft_stdout, $minecraft_stderr, $minecraft_thread, websocket)
    websocket.onopen { |handshake| server.on_open(handshake) }
    websocket.onclose { server.on_close }
    websocket.onmessage { |msg| server.on_message(msg) }
  end
end
