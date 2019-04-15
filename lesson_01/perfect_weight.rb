# frozen_string_literal: true

print 'Ваше имя: '
name = gets.chomp

print 'Ваш рост: '
height = gets.to_f

perfect_weight = height - 110

if perfect_weight.negative?
  puts 'Ваш вес уже оптимальный'
else
  puts "#{name}, Ваш оптимальный вес: #{perfect_weight}"
end
