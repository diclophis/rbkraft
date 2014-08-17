#!/usr/bin/env ruby

Signal.trap('HUP', 'IGNORE')
Signal.trap('INT', 'IGNORE')

pid = fork do
  Signal.trap('HUP', 'IGNORE')
  Signal.trap('INT', 'IGNORE')
  exec *ARGV
end

Process.wait
