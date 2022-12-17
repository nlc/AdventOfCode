# Turning a valve on can be modeled as moving to another node!

input = File.readlines('input.txt', chomp: true)

neighbors = {}
flow_rates = {}

input.each do |line|
  valve, flow_rate_str, valve_neighbors_str = line.match(/^Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? (.*)$/).to_a.drop(1)
  raise "Unable to parse input #{line.inspect}!" if [valve, flow_rate_str, valve_neighbors_str].any?(&:nil?)

  flow_rate = flow_rate_str.to_i
  valve_neighbors = valve_neighbors_str.split(/, /)

  ghost_node = "#{valve}_on"

  neighbors[ghost_node] = valve_neighbors # populate ghost node with the same neigbors, with the transition representing turning the valve on
  neighbors[valve] = valve_neighbors + [ghost_node] # populate actual node, including adding a transition to the ghost node

  flow_rates[ghost_node] = flow_rate
end

p neighbors.values.sum(&:length) / neighbors.length.to_f
