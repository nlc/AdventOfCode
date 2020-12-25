fname = ARGV.shift || raise('Usage: ruby a.rb <input file name>')

all_allergens = []
all_ingredients = []

possible_allergens_of = {}
possible_ingredients_of = {}
impossible_allergens_of = {}
impossible_ingredients_of = {}

foods =
  File.readlines(fname, chomp: true).map.with_index do |line, i|
    _, ingredients_str, allergens_str = line.match(/(.*) \(contains (.*)\)/).to_a
    ingredients = ingredients_str.split
    allergens = allergens_str.split(', ')

    allergens.product(ingredients).each do |allergen, ingredient|
      possible_ingredients_of[allergen] = [] unless possible_ingredients_of.key? allergen
      possible_ingredients_of[allergen] += ingredients

      possible_allergens_of[ingredient] = [] unless possible_allergens_of.key? ingredient
      possible_allergens_of[ingredient] += allergens
    end

    all_allergens += allergens
    all_ingredients += ingredients
    { index: i, allergens: allergens, ingredients: ingredients }
  end

all_allergens.uniq!
all_ingredients.uniq!

possible_allergens_of.each do |k, v|
  v.uniq!
  impossible_allergens_of[k] = all_allergens - possible_allergens_of[k]
end

possible_ingredients_of.each do |k, v|
  v.uniq!
  impossible_ingredients_of[k] = all_ingredients - possible_ingredients_of[k]
end

p all_allergens
p all_ingredients

p possible_allergens_of
p possible_ingredients_of

p impossible_allergens_of
p impossible_ingredients_of

puts

may_contain = {}
contains = {}

all_allergens.each do |allergen|
  containing_foods =
    foods.select do |food|
      food[:allergens].include? allergen
    end

  may_contain[allergen] = containing_foods.map { |e| e[:ingredients] }.inject(:&)
end

until may_contain.none?

  singletons = may_contain.select { |_allergen, foods| foods.length == 1 }

  contains.merge!(singletons)
  singletons.each do |k, v|
    may_contain.delete(k)
    may_contain.each do |allergen, foods|
      foods.delete(v.first)
    end
  end

end

contains = contains.map { |k, v| [k, v.first] }.to_h

sum = 0
(all_ingredients - contains.values).each do |ingredient|
  foods.count do |food|
    sum += food[:ingredients].include?(ingredient) ? 1 : 0
  end
end
p sum

result =
  contains.sort_by do |allergen, _ingredient|
    allergen
  end.map do |allergen, ingredient|
    ingredient
  end.join(',')

puts result
