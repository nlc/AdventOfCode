# the definitive version as of Day 11

require 'byebug'

class Intcode
  def initialize(fname, _debug = false)
    @memory = File.read(fname).split(/,/).map{|n|n.to_i}
    @memory = @memory + ([0] * 2048)
    @ipointer = 0
    @relbase = 0
    @running = true

    @opcodes = {
      1 => {
        code: 1,
        name: 'ADD',
        nparams: 3
      },
      2 => {
        code: 2,
        name: 'MUL',
        nparams: 3
      },
      3 => {
        code: 3,
        name: 'INP',
        nparams: 1
      },
      4 => {
        code: 4,
        name: 'OUT',
        nparams: 1
      },
      5 => {
        code: 5,
        name: 'JIT',
        nparams: 2
      },
      6 => {
        code: 6,
        name: 'JIF',
        nparams: 2
      },
      7 => {
        code: 7,
        name: 'LES',
        nparams: 3
      },
      8 => {
        code: 8,
        name: 'EQU',
        nparams: 3
      },
      9 => {
        code: 9,
        name: 'RBO',
        nparams: 1
      },
      99 => {
        code: 99,
        name: 'HAL',
        nparams: 0
      }
    }

    @debug = _debug

    # execute
  end

  def setmemory(index, value)
    @memory[index] = value
  end

  def running?
    return @running
  end

  # run until input or halt
  def execute(input = nil)
    output = []
    cont = true
    while cont do
      if input && @input_optr
        @memory[@input_optr] = input
        @input_optr = nil
      end

      # read extended opcode
      if(@ipointer >= @memory.length)
        raise "unexpected end of input at #{@ipointer}"
      end
      instruction = @memory[@ipointer]
      opcode = @opcodes[instruction % 100] # last two digits of instruction
      if opcode == nil
        raise "illegal instruction #{instruction} at #{@ipointer}"
      end

      # 0 is position mode
      # 1 is immediate mode
      # 2 is relative mode
      modes = opcode[:nparams].times.map do |i|
        mode = (instruction / (10**(i + 2))) % 10
        if [0, 1, 2].include? mode
          mode
        else
          raise "illegal mode #{mode}"
        end
      end

      params = modes.map.with_index do |mode, i|
        @memory[@ipointer + 1 + i]
      end

      if @debug
        print "  #{'%04d' % @ipointer}"
        print " ++#{'%-4d' % @relbase}"
        print " #{opcode[:name]}"
        print " #{'% 2d' % opcode[:code]}"
        print ' '
        params.zip(modes).each do |param, mode|
          if mode == 0
            print '       :'
          elsif mode == 1
            print '        '
          elsif mode == 2
            print ":(#{'%-4d' % @relbase}+)"
          else
            raise "illegal mode #{mode}"
          end

          print '%-9d' % param
        end
        puts
      end

      # execute
      jumped = false
      case opcode[:name]
      when 'ADD'
        arga, argb = actualize(params[0..1], modes[0..1])
        optr = params[2]
        # special logic
        if modes[opcode[:nparams] - 1] == 2
          optr += @relbase
        end

        @memory[optr] = arga + argb
      when 'MUL'
        arga, argb = actualize(params[0..1], modes[0..1])
        optr = params[2]
        # special logic
        if modes[opcode[:nparams] - 1] == 2
          optr += @relbase
        end

        @memory[optr] = arga * argb
      when 'INP'
        # special logic because INP is weird
        @input_optr = params[0]
        if modes[opcode[:nparams] - 1] == 2
          @input_optr += @relbase
        end

        cont = false
      when 'OUT'
        arga = actualize(params, modes)[0]

        output << arga
      when 'JIT'
        arga, argb = actualize(params, modes)

        if arga != 0
          @ipointer = argb
          jumped = true
        end
      when 'JIF'
        arga, argb = actualize(params, modes)

        if arga == 0
          @ipointer = argb
          jumped = true
        end
      when 'LES'
        arga, argb = actualize(params[0..1], modes[0..1])
        optr = params[2]
        if modes[opcode[:nparams] - 1] == 2
          optr += @relbase
        end

        @memory[optr] = (arga < argb) ? 1 : 0
      when 'EQU'
        arga, argb = actualize(params[0..1], modes[0..1])
        optr = params[2]
        if modes[opcode[:nparams] - 1] == 2
          optr += @relbase
        end

        @memory[optr] = (arga == argb) ? 1 : 0
      when 'RBO'
        arga = actualize(params, modes)[0]

        @relbase += arga
      when 'HAL'
        @running = false
        cont = false
      else
        raise "no logic implemented for opcode #{opcode[:code]} ('#{opcode[:name]})"
      end

      # Advance instruction pointer
      unless jumped
        @ipointer += opcode[:nparams] + 1
      end
    end

    return output
  end

  private

  def actualize(params, modes)
    params.zip(modes).map do |param, mode|
      case mode
      when 0
        @memory[param]
      when 1
        param
      when 2
        @memory[param + @relbase]
      else
        raise "illegal mode #{mode}"
      end
    end
  end
end
