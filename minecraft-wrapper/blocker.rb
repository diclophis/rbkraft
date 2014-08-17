#!/usr/bin/env ruby

Signal.trap('HUP', 'IGNORE')
Signal.trap('INT', 'IGNORE')

#pid = fork do
#  Signal.trap('HUP', 'IGNORE')
#  Signal.trap('INT', 'IGNORE')
  system *ARGV
  #$minecraft_stdin, $minecraft_stdout, $minecraft_stderr, $minecraft_thread = Open3.popen3(ARGV[0], *ARGV[1..-1])
#end
#Process.wait
