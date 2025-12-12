# TODO: Looks like the buttons need to be Arrays.

require 'z3'

# infile = 'input.txt'
infile = 'sample.txt'

input =
  File.readlines(infile, chomp: true).map do |line|
    _, lights_str, buttons_str, _, costs_str = line.match(/\[([\.#]+)\] ((\([0-9,]*\) )+)(\{[0-9,]+\})/).to_a

    lights = lights_str.chars.map { |chr| chr == '#' ? 1 : 0 }

    buttons =
      buttons_str.rstrip.split(' ').map do |button_str|
        button_str.gsub(/[()]/, '').split(',').sum { |ns| 2 ** ns.to_i }
      end

    costs = costs_str.gsub(/[{}]/, '').split(',').map(&:to_i)

    [lights, buttons, costs]
  end

def gen_smt_problem(problem, nametag = '')
  lights, buttons, costs = problem
  bitcount = 32

  solver = Z3::Solver.new
  optimizer = Z3::Optimize.new

  button_values =
    buttons.map.with_index do |button, ib|
      button_name = "btn#{nametag}#{ib}"
      button_value = Z3.Int(button_name)
      optimizer.assert(button_value == button)

      button_value
    end

  button_presses =
    buttons.map.with_index do |button, ib|
      button_name = "prs#{nametag}#{ib}"
      button_press = Z3.Int(button_name)
      optimizer.assert(button_press.unsigned_lt(2))

      button_press
    end

  cost_bitvecs =
    costs.map.with_index do |costs, ic|
      cost_name = "prs#{nametag}#{ic}"
      cost_bitvec = Z3.Int(cost_name)
      optimizer.assert(button_pressed_lt(2))

      button_press
    end

  total_presses = Z3.Int("total#{nametag}", bitcount)
  optimizer.assert(total_presses == Z3.Add(*button_presses))

  result_name = "res#{nametag}"
  result_bitvec = Z3.Bitvec(result_name, bitcount)
  solver.assert(result_bitvec == result_number)
  optimizer.assert(result_bitvec == result_number)

  optimizer.minimize(total_presses)

  optimizer.assert(result_bitvec == Z3.Xor(*button_presses.zip(button_values).map { |button_press, button_value| button_press * button_value }))

  if optimizer.satisfiable?
    optimizer.model[total_presses].to_s.to_i
  else
    raise 'unsatisfiable'
  end
end

total =
  input.map.with_index do |problem, ip|
    gen_smt_problem(problem, '_p%03d_' % ip)
  end.sum

puts total
