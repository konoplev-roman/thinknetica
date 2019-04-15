# frozen_string_literal: true

sides = []

3.times do
  print 'Введите сторону треугольника: '
  sides << gets.to_f
end

first_leg, second_leg, hypotenuse = sides.sort

properties = []

properties << 'прямоугольный' if hypotenuse**2 == first_leg**2 + second_leg**2
properties << 'равнобедренный' if sides.uniq.count == 2
properties << 'равносторонний' if sides.uniq.count == 1

if properties.any?
  puts "Треугольник #{properties.join(', ')}"
else
  puts 'Треугольник не является прямоугольным, равнобедренным или равносторонним'
end
