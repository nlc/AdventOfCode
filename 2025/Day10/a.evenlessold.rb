infile = 'input.txt'

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
  bitcount = lights.length
  result_number = lights.map.with_index { |n, i| n * 2 ** i }.sum

  res_name = "res#{nametag}"
  <<~SMT
    (set-logic QF_BV)
    (set-info :smt-lib-version 2.0)
    (set-info :status sat)

    #{
      buttons.map.with_index do |button, ib|
        btn_name = "btn#{nametag}#{ib}"
        "(declare-fun #{btn_name} () (_ BitVec #{bitcount}))\n(assert (bvult #{btn_name} (_ bv2 #{bitcount})))"
      end.join("\n")
    }

    ; [#{lights.map { |l| l == 1 ? '#' : '.' }.join}]
    #{"(declare-fun #{res_name} () (_ BitVec #{bitcount}))"}
    #{"(assert (= #{res_name} (_ bv#{result_number} #{bitcount})))"}

    #{
      nbtns = buttons.length
      nbtns.times.map do |i|
        "(assert-soft (bvult (bvadd #{buttons.map.with_index { |button, ib| "btn#{nametag}#{ib}" }.join(' ')}) (_ bv#{i + 1} #{bitcount})))"
      end.join("\n")
    }

    (assert (= #{res_name} (bvxor #{
     buttons.map.with_index do |button, ib|
       btn_name = "btn#{nametag}#{ib}"
       "(bvmul #{btn_name} (_ bv#{button} #{bitcount}))"
     end.join(' ')
    })))

    (check-sat)

    (get-value (#{
       buttons.map.with_index { |button, ib| "btn#{nametag}#{ib}" }.join(' ')
    }))
    (exit)
  SMT
end

def parse_z3_output(string)
  string.scan(/^sat\s*\(((\(.*#[xb][01]+\)\s*)+\))/).to_a.last.first.scan(/\([^\)]*\)/).to_a.map { |ns| ns.match(/.*#[bx]0*([01])/)[1].to_i }.sum
end

total =
  input.map.with_index do |problem, ip|
    fname = 'problem_%03d.tmp' % ip
    File.open(fname, 'w') do |of|
      of.puts gen_smt_problem(problem, '_p%03d_' % ip)
    end

    parse_z3_output(%x(z3 #{fname}))
  end.sum

puts total
