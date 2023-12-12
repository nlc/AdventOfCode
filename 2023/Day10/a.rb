require 'pp'
require 'set'

def vadd(a, b)
  a.zip(b).map { |ea, eb| ea + eb }
end

fname = ARGV.shift || 'input.txt'

grid = File.readlines(fname, chomp: true).map(&:chars)

# DIRS = {
#   E: [1, 0],
# 
# }

E = [ 1,  0]
S = [ 0,  1]
W = [-1,  0]
N = [ 0, -1]

graph = {}
starting_point = nil
grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    point = [x, y]

    case char
    when '-'
      graph[point] = [E, W].map { |direction| vadd(direction, point) }.select { |other_point| other_point.none?(&:negative?) }
    when '|'
      graph[point] = [N, S].map { |direction| vadd(direction, point) }.select { |other_point| other_point.none?(&:negative?) }
    when '7'
      graph[point] = [W, S].map { |direction| vadd(direction, point) }.select { |other_point| other_point.none?(&:negative?) }
    when 'J'
      graph[point] = [N, W].map { |direction| vadd(direction, point) }.select { |other_point| other_point.none?(&:negative?) }
    when 'L'
      graph[point] = [N, E].map { |direction| vadd(direction, point) }.select { |other_point| other_point.none?(&:negative?) }
    when 'F'
      graph[point] = [S, E].map { |direction| vadd(direction, point) }.select { |other_point| other_point.none?(&:negative?) }
    when 'S'
      graph[point] = [E, N, W, S].map { |direction| vadd(direction, point) }.select { |other_point| other_point.none?(&:negative?) }
      starting_point = point
    end
  end
end

# puts grid.map(&:join)
# p starting_point
# pp graph

pipe_distances = {}

graph[starting_point].each do |adj_point|
  current_point = adj_point
  visited = Set.new([starting_point])

  aborting = false
  until current_point.nil? || aborting
    pipe_distances[current_point] = [visited.length, (pipe_distances[current_point] || Float::INFINITY)].min

    visited.add(current_point)

    to_visit = graph[current_point].reject { |nbr| visited.include?(nbr) }
    aborting = to_visit.length > 1 || to_visit.length == 0

    current_point = to_visit.first
    # print " #{visited.length}\r" if visited.length % 100 == 0
  end
end
p pipe_distances.values.max
