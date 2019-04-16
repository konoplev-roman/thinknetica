# frozen_string_literal: true

hash = ('a'..'z').each_with_index.select { |char, _i| %w[a e i o u].include?(char) }.to_h

puts hash
