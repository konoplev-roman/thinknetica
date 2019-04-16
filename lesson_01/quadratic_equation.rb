# frozen_string_literal: true

print 'Введите коэффициент a: '
a = gets.to_f

print 'Введите коэффициент b: '
b = gets.to_f

print 'Введите коэффициент c: '
c = gets.to_f

d = b**2 - 4 * a * c

if d.negative?
  puts "Дискриминант = #{d}. Корней нет"
elsif d.zero?
  x = -b / (2 * a)

  puts "Дискриминант = #{d}; x = #{x}"
else
  sqrt = Math.sqrt(d)

  x1 = (-b + sqrt) / (2 * a)
  x2 = (-b - sqrt) / (2 * a)

  puts "Дискриминант = #{d}; x1 = #{x1}; x2 = #{x2}"
end
