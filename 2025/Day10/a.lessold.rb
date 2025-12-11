infile = 'input.txt'

def load_input(infile)
  File.readlines(infile, chomp: true).map do |line|
    _, lights_str, buttons_str, _, costs_str = line.match(/\[([\.#]+)\] ((\([0-9,]*\) )+)(\{[0-9,]+\})/).to_a

    lights = lights_str.chars.map { |chr| chr == '#' ? 1 : 0 }

    buttons =
      buttons_str.rstrip.split(' ').map do |button_str|
        a = [0] * lights.length
        button_str.gsub(/[()]/, '').split(',').map(&:to_i).each do |ib|
          a[ib] = 1
        end
        a
      end

    costs = costs_str.gsub(/[{}]/, '').split(',').map(&:to_i)

    [lights, buttons, costs]
  end
end

# example = input.max { |l, b, c| b.length }

MEMO_MAT = {}
def mat(n)
  return MEMO_MAT[n] if MEMO_MAT.key?(n)

  MEMO_MAT[n] = (2**n).times.map{ |k|k.to_s(2).rjust(n, '0').chars.map(&:to_i) }
end

def brute_force_console(console)
  lights, buttons, costs = console

  mat(buttons.length).each do |subset_indices|
    subset_indices.each do |switch|
      if switch == 1
        
      end
    end
  end
end
