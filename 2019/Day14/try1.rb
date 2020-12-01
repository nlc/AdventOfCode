require 'pp'

def parse(fname)
  products = {}
  lines = File.readlines(fname).map(&:chomp)
  lines.each do |line|
    ingredientlist, product = line.split(/\s*=>\s*/)
    ingredients = ingredientlist.split(/\s*,\s*/).map{|ing|ing = ing.split(/\s+/); ing[0] = ing[0].to_i; ing.reverse}.to_h
    productamount, producttype = product.split(/\s+/)
    productamount = productamount.to_i

    unless products[producttype]
      products[producttype] = {}
    end

    if products[producttype][productamount]
      raise 'this may be a problem'
    end

    products[producttype][productamount] = ingredients
  end
  products
end

# generate "minimal" subsets of nums that add to at least sum
def pseudopartition(sum, nums)
  
end

# naive
def footprint(products, amount, type, surplus = {})
  unless products[type]
    return [amount]
  end

  possibleamounts = products[type].keys

  possibleamounts.map do |possibleamount|
    recipe = products[type][possibleamount]
    recipemultiple = (amount.to_f / possibleamount).ceil
    # puts "#{amount} / #{possibleamount} = #{recipemultiple}"

    surplusproduct = recipemultiple * possibleamount - amount
    unless surplus[type]
      surplus[type] = 0
    end
    surplus[type] += surplusproduct

    recipe.map do |rectype, recamount|
      # if surplus[rectype]
      #   while surplus[rectype] > recamount
      #     puts "pull #{recamount} from surplus #{rectype}"
      #     surplus[rectype] -= recamount
      #     recipemultiple -= 1
      #   end
      # end

      # puts "#{amount} #{type} requires #{recamount * recipemultiple} #{rectype}"
      footprint(products, recamount * recipemultiple, rectype, surplus).inject(:+)
    end.inject(:+)
  end
end

# There's only one amount that can be generated per type
# Only one "recipe" exists per material
%w{ sample_31.txt sample_165.txt sample_13312.txt sample_180697.txt sample_2210736.txt }.each do |fname|
  products = parse(fname)

  surplus = {}
  fp = footprint(products, 1, 'FUEL', surplus).first

  surplus.each do |type, amount|
    bundle = products[type].keys.first

    bolusbelow = footprint(products, (amount / bundle) * bundle, type).first
    puts "  remove #{bolusbelow} ORE from making #{type}"

    fp -= bolusbelow
  end

  target = fname.gsub(/\D/, '').to_i
  puts "#{target} - #{fp} = #{target - fp}"
end
