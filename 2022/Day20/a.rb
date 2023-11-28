fname = 'sample.txt'
list = File.readlines(fname).map(&:to_i)

def mix(list)
  (0...list.length).to_a.zip(list)
end
