gem 'pagehub-markdown'
require 'pagehub-markdown'

def strip(s)
  o = ""
  s.lines.each { |l| o << l.gsub(/^ +/, '') }
  o
end

def html_strip(s)
  o = ""
  tmp = strip(s)
  tmp.lines.each { |l| o << l unless l =~ /^\s+$/ }
  o
end