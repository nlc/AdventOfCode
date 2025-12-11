require 'minisat'

infile = 'input.txt'

input =
  File.readlines(infile, chomp: true).map do |line|
    _, lights_str, buttons_str, _, costs_str = line.match(/\[([\.#]+)\] ((\([0-9,]*\) )+)(\{[0-9,]+\})/).to_a

    lights = lights_str.chars.map { |chr| chr == '#' ? 1 : 0 }

    # buttons =
    #   buttons_str.rstrip.split(' ').map do |button_str|
    #     a = [0] * lights.length
    #     button_str.gsub(/[()]/, '').split(',').map(&:to_i).each do |ib|
    #       a[ib] = 1
    #     end
    #     a
    #   end

    buttons =
      buttons_str.rstrip.split(' ').map do |button_str|
        button_str.gsub(/[()]/, '').split(',').map(&:to_i)
      end

    costs = costs_str.gsub(/[{}]/, '').split(',').map(&:to_i)

    [lights, buttons, costs]
  end

example = input.max { |l, b, c| b.length }
# puts "#{lites.join(' ')} (%. m. 2) #{butns.length - 2} #{lites.length} $ #{butns[0...-2].join(' ')}"

def satisfy(problem)
  lights, buttons, costs = problem

  solver = MiniSat::Solver.new

  vars = buttons.map { |button| solver.new_var }

  lights.each do 
end
