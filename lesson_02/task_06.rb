# frozen_string_literal: true

items = {}
total = {}
sum = 0

loop do
  print 'Товар: '
  item = gets.chomp

  break if item == 'стоп'

  print 'Цена за единицу: '
  price = gets.to_f

  print 'Кол-во: '
  quantity = gets.to_f

  items[item] = { price: price, quantity: quantity }

  sum += total[item] = price * quantity
end

puts "Хэш: #{items}"

total.each { |i, t| puts "#{i}: #{t}" }

puts "Сумма: #{sum}"
