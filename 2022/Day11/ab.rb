# We can keep the numbers manageable by mapping them into Z/(n),
# the ring of integers modulo n=14908423530, where n is the product
# of the first 9 prime numbers. All relevant properties of the
# numbers are retained but their sizes remain less than n, avoiding
# costly bignum calculations.
$MAGIC = 14908423530

class Monkey
  attr_accessor :index, :items, :operation, :modulus, :dest_true, :dest_false, :items_inspected

  def initialize(index, items, operation, modulus, dest_true, dest_false)
    @items = items
    @operation = operation
    @modulus = modulus
    @dest_true = dest_true
    @dest_false = dest_false

    @items_inspected = 0
  end

  def self.parse(description)
    index_line, items_line, operation_line, modulus_line, dest_true_line, dest_false_line = description.split(/\n/)

    index = index_line.match(/Monkey (\d+):/)[1]&.to_i
    items = items_line.match(/Starting items: (.*)/)[1]&.split(/, /)&.map(&:to_i)
    modulus = modulus_line.match(/Test: divisible by (\d+)/)[1]&.to_i
    dest_true = dest_true_line.match(/If true: throw to monkey (\d+)/)[1]&.to_i
    dest_false = dest_false_line.match(/If false: throw to monkey (\d+)/)[1]&.to_i
    operator, operand = operation_line&.match(/Operation: new = old (.) (.+)/)&.to_a[1..2]

    if items.nil? || modulus.nil? || dest_true.nil? || dest_false.nil? || operator.nil? || operand.nil?
      raise 'Parsing error!'
    end

    operation =
      if operand == 'old'
        lambda { |old| old * old }
      else
        case operator
        when '+'
          lambda { |old| old + operand.to_i }
        when '*'
          lambda { |old| old * operand.to_i }
        else
          raise "Bad operation where operator = #{operator.inspect} and operand = #{operand.inspect}"
        end
      end

    Monkey.new(index, items, operation, modulus, dest_true, dest_false)
  end

  def inspect_item(divide_by_three = false)
    item = @items.shift

    item = @operation.call(item) % $MAGIC
    item = (item / 3).floor if divide_by_three

    dest = (item % modulus == 0) ? @dest_true : @dest_false

    @items_inspected += 1

    [dest, item]
  end

  def catch_item(item)
    @items.push(item)
  end
end

def round(monkeys, divide_by_3 = false)
  monkeys.each do |monkey|
    while monkey.items.any?
      dest, item = monkey.inspect_item(divide_by_3)

      monkeys[dest].catch_item(item)
    end
  end
end

def day11a(input)
  monkeys = input.split(/\n\n/).map { |description| Monkey.parse(description) }

  20.times { round(monkeys, true) }
  monkeys.map { |monkey| monkey.items_inspected }.max(2).inject(:*)
end

def day11b(input)
  monkeys = input.split(/\n\n/).map { |description| Monkey.parse(description) }

  10000.times { round(monkeys) }
  monkeys.map { |monkey| monkey.items_inspected }.max(2).inject(:*)
end

infile = ARGV.shift || 'input.txt'
input = File.read(infile)

puts 'Day 11:'
puts "  Part A: #{day11a(input)}"
puts "  Part B: #{day11b(input)}"
