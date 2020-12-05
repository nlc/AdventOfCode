require 'pp'

# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.
def validate(key, value)
  case key
  when 'byr'
    return (1920..2002).include? value.to_i
  when 'iyr'
    return (2010..2020).include? value.to_i
  when 'eyr'
    return (2020..2030).include? value.to_i
  when 'hgt'
    len, unit = value.scan(/([0-9]*)(in|cm)/).first
    case unit
    when 'cm'
      return (150..193).include? unit.to_i
    when 'in'
      return (59..73).include? unit.to_i
    end
  when 'hcl'
    return value =~ /#[0-9a-f]{6}/
  when 'ecl'
    return value =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/
  when 'pid'
    return value =~ /^[0-9]{9}$/
  end
end

people = []
records = File.read('../input.txt').split(/\n\n+/)
records.each_with_index do |record, i|
  fields = record.split(/\s+/)
  person =
    fields.map do |field|
      field.split(/:/)
    end.to_h

  %w[byr iyr eyr hgt hcl ecl pid].all? do |key|
    validate(key, person[key])
  end
end
