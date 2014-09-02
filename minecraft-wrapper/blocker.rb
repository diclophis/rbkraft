#!/usr/bin/env ruby

Signal.trap('HUP', 'IGNORE')
Signal.trap('INT', 'IGNORE')

system *ARGV
