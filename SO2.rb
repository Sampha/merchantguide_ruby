class Number
  attr_accessor :value
end

numbers = (1..10).map do |n|
  number = Number.new
  number.value = n
  number
end

numbers.each do |f|
 puts f.value
end