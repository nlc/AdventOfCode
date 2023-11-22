# TODO: ... matrix exponents?

def parse(fname = 'input.txt')
  File.readlines(fname, chomp: true).map do |line|
    matches = line.match(
      /Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./
    )

    raise 'bad assumption!' unless matches.length == 8

    index, ore_robot_ore_cost, clay_robot_ore_cost, obsidian_robot_ore_cost, obsidian_robot_clay_cost, geode_robot_ore_cost, geode_robot_obsidian_cost = matches.to_a[1..].map(&:to_i)

    {index:, ore_robot_ore_cost:, clay_robot_ore_cost:, obsidian_robot_ore_cost:, obsidian_robot_clay_cost:, geode_robot_ore_cost:, geode_robot_obsidian_cost:}
  end
end

STARTING_STATE = {
  num_ore_robots: 1,
  num_clay_robots: 0,
  num_obsidian_robots: 0,
  num_geode_robots: 0,
  amount_ore: 0,
  amount_clay: 0,
  amount_obsidian: 0,
  amount_geode: 0,
}.freeze

def iterate(state, blueprint)
  new_state = state.clone

  return new_state
end

blueprints = parse('sample.txt')
state = STARTING_STATE.clone
blueprint = blueprints.first

(1..24).each do |minute|
  puts "== Minute #{minute} =="
  p iterate(state, blueprint)
end
