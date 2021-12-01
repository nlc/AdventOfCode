def rl(fname)
  File.readlines(fname, chomp: true)
end

def rli(fname)
  rli(fname).map(&:to_i)
end

def rc(fname)
  File.read(fname)
end

def rci(fname)
  rc(fname).map(&:to_i)
end

def rw(fname)
  File.read(fname).split(/\s+/)
end

def rwi(fname)
  rw(fname).map(&:to_i)
end

inp = 'input.txt'
