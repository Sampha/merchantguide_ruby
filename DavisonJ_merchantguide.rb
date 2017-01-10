if File.file?("testinput.txt")
  else
  puts "Hello and welcome to the merchant's guide to the galaxy! To run this app you must create a text file in the filepath of this app name 'testinput.txt'"
  puts "once you have done so, just run this program again and it will immediately print the results to your console."
end

class AlienNumeral
  attr_accessor :value, :numeral, :roman_numeral

  def initialize(numeral, roman_numeral)
    @numeral = numeral
    @roman_numeral = roman_numeral
    @value = 1 if @roman_numeral == "I"
    @value = 5 if @roman_numeral == "V"
    @value = 10 if @roman_numeral == "X"
    @value = 50 if @roman_numeral == "L"
    @value = 100 if @roman_numeral == "C"
    @value = 500 if @roman_numeral == "D"
    @value = 1000 if @roman_numeral == "M"
  end

end

class AlienMineral
  attr_accessor :mineral, :alien_numeral_one, :alien_numeral_two, :total_price, :value, :alien_value_one, :alien_value_two

  def initialize(mineral, alien_numeral_one, alien_numeral_two, total_price)
    @mineral = mineral
    @alien_numeral_one = alien_numeral_one
    @alien_numeral_two = alien_numeral_two
    @total_price = if total_price.to_f < 1 then total_price.to_f else total_price.to_i end
  end
end

class NumeralCombination
  attr_accessor :alien_numeral_one, :alien_numeral_two, :alien_numeral_three, :alien_numeral_four, :alien_value_one, :alien_value_two, :alien_value_three, :alien_value_four, :sum_one, :sum_two, :total

  def initialize(alien_numeral_one, alien_numeral_two, alien_numeral_three, alien_numeral_four)
    @alien_numeral_one = alien_numeral_one
    @alien_numeral_two = alien_numeral_two
    @alien_numeral_three = alien_numeral_three
    @alien_numeral_four = alien_numeral_four
  end
end

class MineralCombination
  attr_accessor :alien_numeral_one, :alien_numeral_two, :mineral, :alien_value_one, :alien_value_two, :mineral_value, :total

  def initialize(alien_numeral_one, alien_numeral_two, mineral)
    @alien_numeral_one = alien_numeral_one
    @alien_numeral_two = alien_numeral_two
    @mineral = mineral
  end
end



# This iterator pulls the information from the first set of inputs and sets the alien_numerals i.e. "blob is I = 1"
alien_numerals = IO.readlines("testinput.txt").each.map do |line|
  split_line = line.split(" ")
  if split_line[1] == "is"
    alien_numeral = AlienNumeral.new(split_line[0], split_line[2])
    alien_numeral
  end
end

# This iterator pulls the information from the second set of inputs and sets the required attributes we need to find the mineral values
alien_minerals = IO.readlines("testinput.txt").each.map do |line|
  split_line = line.split(" ")
  if split_line[5] == "Credits"
    alien_mineral = AlienMineral.new(split_line[2], split_line[0], split_line[1], split_line[4])
    alien_mineral
  end
end

# This iterator sets the value of the minerals using the attributes entered earlier
alien_minerals.each do |f| if f != nil
  f.alien_value_one = alien_numerals.find{|g| g.numeral == f.alien_numeral_one}.value
  f.alien_value_two = alien_numerals.find{|g| g.numeral == f.alien_numeral_two}.value
  f.value = (f.total_price) / (if f.alien_value_one < f.alien_value_two then f.alien_value_two - f.alien_value_one else f.alien_value_two + f.alien_value_one end)
 end
end

# This iterator will work through the third sets of inputs, i.e. "how much is pish tegj glob glob" and stores the values in the NumeralCombination class
numeral_combinations = IO.readlines("testinput.txt").each.map do |line|
  split_line = line.split(" ")
  if split_line[7] == "?" && split_line[1] == "much"
    numeral_combination = NumeralCombination.new(split_line[3], split_line[4], split_line[5], split_line[6])
    numeral_combination
  end
end

# This iterator will set the resulting value of the third set of inputs using the values entered earlier

numeral_combinations.each do |f| if f != nil
   f.alien_value_one = alien_numerals.find{|g| g.numeral == f.alien_numeral_one}.value
   f.alien_value_two = alien_numerals.find{|g| g.numeral == f.alien_numeral_two}.value
   f.alien_value_three = alien_numerals.find{|g| g.numeral == f.alien_numeral_three}.value
   f.alien_value_four = alien_numerals.find{|g| g.numeral == f.alien_numeral_four}.value
   f.sum_one = (if f.alien_value_one < f.alien_value_two then f.alien_value_two - f.alien_value_one else f.alien_value_two + f.alien_value_one end)
   f.sum_two = (if f.alien_value_three < f.alien_value_four then f.alien_value_four - f.alien_value_three else f.alien_value_four + f.alien_value_three end)
   f.total = f.sum_one + f.sum_two
  end
end


# This iterator will work through the fourth sets of inputs i.e. "how many Credits is glob prok Silver ?" and sotre the as a MineralCombination class object
mineral_combinations = IO.readlines("testinput.txt").each.map do |line|
  split_line = line.split(" ")
  if split_line[1] == "many"
    mineral_combination = MineralCombination.new(split_line[4], split_line[5], split_line[6])
    mineral_combination
  end
end


# This iterator will calculate the value for the mineral combinations based on the attributes set in the prior iterator
mineral_combinations.each do |f|
  if f != nil
    f.alien_value_one = alien_numerals.find{|g| g.numeral == f.alien_numeral_one}.value
    f.alien_value_two = alien_numerals.find{|g| g.numeral == f.alien_numeral_two}.value
    f.mineral_value = alien_minerals.find{|g| g != nil && g.mineral == f.mineral}.value
    f.total = (if f.alien_value_one < f.alien_value_two then f.alien_value_two - f.alien_value_one else f.alien_value_two + f.alien_value_one end) * f.mineral_value
  end
end

# This iterator will read from the file and line by line respond with output where expected or throw an error if the input doesn't match expectations
IO.readlines("testinput.txt").each do |line|
  split_line = line.split(" ")
  if split_line[2] == "is"
    n = numeral_combinations.find{|f| f != nil && f.alien_numeral_one == split_line[3] && f.alien_numeral_two == split_line[4] && f.alien_numeral_three == split_line[5] && f.alien_numeral_four == split_line[6]}
    print "#{n.alien_numeral_one} #{n.alien_numeral_two} #{n.alien_numeral_three} #{n.alien_numeral_four} is #{n.total}"
    puts " "
  elsif split_line[2] == "Credits"
    n = mineral_combinations.find{|f| f != nil && f.mineral == split_line[6] && f.alien_numeral_one == split_line[4] && f.alien_numeral_two == split_line[5]}
    print "#{n.alien_numeral_one} #{n.alien_numeral_two} #{n.mineral} is #{n.total} Credits"
    puts " "
  elsif split_line[1] != "is" && split_line[5] != "Credits" && split_line[7] != "?"
    puts "I have no idea what you are talking about"
    else
  end
end