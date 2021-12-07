require 'pp'

def readlines(fname)
  File.readlines(fname, chomp: true)
end

def ireadlines(fname)
  readlines(fname).map(&:to_i)
end

def readchars(fname)
  File.read(fname)
end

def ireadchars(fname)
  readchars(fname).map(&:to_i)
end

def readwords(fname)
  File.read(fname).split(/\s+/)
end

def ireadwords(fname)
  readwords(fname).map(&:to_i)
end

inp = 'input.txt'
