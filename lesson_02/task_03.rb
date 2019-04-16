# frozen_string_literal: true

arr = [0, 1]

while (a = arr[-1] + arr[-2]) < 100
  arr << a
end

puts arr
