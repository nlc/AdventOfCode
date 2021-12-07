require 'Set'

require 'pp'

def do_dfs(nodes, values, starting, visited, &predicate)
  visited.add(starting)

  return nil if nodes[starting].empty?

  nodes[starting].keys.each do |k|
    return [k] if predicate.call(values[k])

    result = do_dfs(nodes, values, k, visited, &predicate) unless visited.include? k
    return [k] + result unless result.nil?
    return nil
  end
end

class Graph # sparse directed weighted graph
  attr_accessor :nodes, :values

  def initialize(num_nodes = 0)
    @nodes = Array.new(num_nodes){ {} } # array of hashes of indices to other nodes
    @values = Array.new(num_nodes){ {} } # array of values for nodes to have
  end

  def from_adjmat!(adjmat, values = [])
    dim = adjmat.length
    initialize(dim)

    @values = values.clone
    adjmat.each_with_index do |row, i|
      row.each_with_index do |elt, j|
        unless elt.zero?
          @nodes[i][j] = elt
        end
      end
    end
  end

  def to_adjmat
    adjmat = Array.new(@nodes.length) { Array.new(@nodes.length) { 0 } }
    @nodes.each_with_index do |node, n|
      node.keys.each do |k|
        adjmat[n][k] = node[k]
      end
    end

    adjmat
  end

  def make_undirected!
    @nodes.each_with_index do |node, n|
      node.keys.each do |k|
        fwd = node[k]
        bak = @nodes[k][n]

        if !bak.nil? && bak.nonzero? && bak != fwd
          raise "Conflicting weights cannot be merged! (#{fwd} != #{bak} @ n#{n}<->n#{k})"
        end

        @nodes[k][n] = fwd
      end
    end
  end

  def dfs(starting, &predicate)
    do_dfs(@nodes, @values, starting, Set.new, &predicate)
  end
end

def test_adjmat
  adjmat = [
    [0, 0, 1, 0],
    [1, 2, 0, 0],
    [0, 0, 0, 1],
    [0, 1, 2, 1]
  ]

  g = Graph.new
  g.from_adjmat!(adjmat)

  pp adjmat
  pp g.nodes
end

def test_make_undirected!
  adjmat = [
    [0, 0, 1, 0],
    [1, 2, 0, 0],
    [0, 0, 0, 0],
    [0, 1, 2, 1]
  ]

  g = Graph.new
  g.from_adjmat!(adjmat)

  pp adjmat
  pp g.nodes
  g.make_undirected!
  pp g.nodes
end

def test_to_adjmat
  adjmat = Array.new(5) { Array.new(5) { rand 5 } }

  pp adjmat
  g = Graph.new
  g.from_adjmat!(adjmat)

  g_adjmat = g.to_adjmat

  if adjmat == g_adjmat
    puts 'MATCH'
  else
    puts 'MISMATCH'
    pp g_adjmat
  end
end

def test_dfs
  adjmat = [
    [0, 0, 1, 0],
    [1, 2, 0, 0],
    [0, 0, 0, 1],
    [0, 1, 2, 1]
  ]

  values = [2, 3, 5, 7]

  g = Graph.new
  g.from_adjmat!(adjmat, values)

  pp g.dfs(0) { |value| value == 3 }
end

test_dfs
