class Number
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

array_of_number_objects = 1.upto(10).inject([]) do |array, number|
  array << Number.new(number)
end

array_of_number_objects.each do |f|
  puts f.value
end