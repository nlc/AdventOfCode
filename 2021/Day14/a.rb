input = File.readlines('sample.txt', chomp: true)

template = input.first.chars
rules = input[2..].map { |line| line.split(' -> ') }.to_h

posschars = (template + rules.keys.map(&:chars).flatten + rules.values.flatten).uniq.sort
print "    "
posschars.each do |tx|
  print "#{tx} "
end
puts
puts "  +" + "-" * (posschars.length * 2)
posschars.each do |ty|
  print "#{ty} | "
  posschars.each do |tx|
    res = rules[ty + tx]
    if res.nil?
      print "  "
    else
      print "#{res} "
    end
  end
  puts
end


