class MappingSet
  def initialize(fname)
    contents = File.read(fname)

    seeds_str, *mappings_strs = contents.split(/\n\n/)

    seeds = seeds_str.scan(/\d+/).to_a.map(&:to_i)
    seed_ranges = seeds.each_cons(2).map{|start,length|(start..(start+length-1))}

    @mappings =
      mappings_strs.map do |mapping_str|
        title, *lines = mapping_str.split(/\n/)
        title.gsub!(/ map:/, '')

        mapping =
          lines.map do |line|
            dest_range_start, source_range_start, range_length = line.split(/ /).map(&:to_i)

            dest_range = dest_range_start...(dest_range_start + range_length)
            source_range = source_range_start...(source_range_start + range_length)
            offset = dest_range_start - source_range_start

            [source_range, offset]
          end

        [title, mapping]
      end.to_h
  end

  def apply_mapping(number, mapping)
    selected_range, selected_offset =
      mapping.select do |range, offset|
        range.include?(number)
      end.first

    if selected_range.nil?
      number
    else
      number + selected_offset
    end
  end

  def calculate(n)
    mapping_titles = %w[seed-to-soil soil-to-fertilizer fertilizer-to-water water-to-light light-to-temperature temperature-to-humidity humidity-to-location]
    mapping_titles.each do |mapping_title|
      n = apply_mapping(n, @mappings[mapping_title])
    end

    n
  end
end

def test
  fname = ARGV.shift || 'input.txt'

  contents = File.read(fname)

  seeds_str, *mappings_strs = contents.split(/\n\n/)

  seeds = seeds_str.scan(/\d+/).to_a.map(&:to_i)
  seed_ranges = seeds.each_cons(2).map{|start,length|(start..(start+length-1))}

  mapping_set = MappingSet.new(fname)

  min_loc =
    seeds.map do |seed|
      mapping_set.calculate(seed)
    end.min

  puts min_loc

  min_loc2 =
    seed_ranges.map do |seed_range|
      smallest = seed_range.begin
      largest = seed_range.end
      [smallest, largest]
    end.flatten.map do |seed|
      mapping_set.calculate(seed)
    end.min

  puts min_loc2
end

test
