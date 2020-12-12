# require '../../utilities/memo.rb'

# Return the amount of ore it takes to make a product
def ore(amount, product, reactions)
  return amount if product == 'ORE'

  raise "No reactants found for #{product}" unless reactions.key? product

  batch_amount, inputs = reactions[product]

  # Amount that can be produced must be an integer multiple of "batch_amount"
  # and it must be >= "amount"
  # Least multiple of batch_amount that's >= amount
  num_batches = ((amount - 1) / batch_amount) + 1

  inputs.map do |input, input_amount|
    ore(input_amount, input, reactions)
  end.inject(:+) * num_batches
end

fname = 'sample_165.txt'

reactions =
  File.readlines(fname, chomp: true).map do |line|
    input_str, output_str = line.split(' => ')

    output_amount, output_chemical = output_str.split(' ')
    output = output_chemical

    inputs =
      input_str.split(', ').map do |input|
        amount, chemical = input.split(' ')
        [chemical, amount.to_i]
      end.to_h
    [output, [output_amount.to_i, inputs]]
  end.to_h

p ore(1, 'FUEL', reactions)
