require 'set'

class File
  attr_accessor :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end
end

class Dir
  attr_accessor :name, :files, :subdirs, :parent, :file_size_sum

  def initialize(name)
    @name = name
    @files = []
    @subdirs = []

    @file_size_sum = 0
  end

  def add_file_size_sum(filesize)
    @file_size_sum += filesize

    @parent.add_file_size_sum(filesize) unless @parent.nil?
  end

  def dynamically_sum_file_size
    @files.sum(&:size) + @subdirs.sum(&:dynamically_sum_file_size)
  end

  def pretty_print(indent = 0)
    my_padding = ' ' * indent
    sub_padding = ' ' * (indent + 2)

    puts my_padding + "- #{@name} (TOTAL: #{@file_size_sum})"

    @files.each do |file|
      puts sub_padding + "- #{file.name} (SIZE: #{file.size})"
    end

    @subdirs.each do |subdir|
      subdir.pretty_print(indent + 2)
    end
  end
end

def parse_dirs(input)
  root = Dir.new(input.first.split[2])
  wd = root

  all_dirs = Set.new
  all_dirs.add(wd)

  input.drop(1).each do |line|
    case line
    when /^\$ cd/ # directory change
      dirname = line.split[2]

      if dirname == '..'
        wd = wd.parent
      else
        subdir = Dir.new(dirname)

        subdir.parent = wd
        wd.subdirs.push(subdir)

        wd = subdir

        all_dirs.add(wd)
      end
    when /^\d+/ # file listing
      size, filename = line.split
      size = size.to_i

      file = File.new(filename, size)

      wd.files.push(file)
      wd.add_file_size_sum(size)
    end
  end

  [all_dirs, root]
end

input = File.readlines('input.txt')
all_dirs, root = parse_dirs(input)

day07a = all_dirs.select { |dir| dir.file_size_sum <= 100000 }.map(&:file_size_sum).sum

TOTAL_CAPACITY = 70000000
NECESSARY_SPACE = 30000000
FREE_SPACE_ALREADY = TOTAL_CAPACITY - root.file_size_sum
TO_BE_FREED = NECESSARY_SPACE - FREE_SPACE_ALREADY
day07b =
  all_dirs.map(&:file_size_sum).sort.find do |size|
    size >= TO_BE_FREED
  end

puts 'Day 07:'
puts "  Part A: #{day07a}"
puts "  Part B: #{day07b}"
