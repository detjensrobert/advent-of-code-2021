#!/usr/bin/env ruby

# PART 1: count the number of times a depth measurement increases

input = ARGF.readlines.map(&:to_i)

increased = -1
prev = 0
input.each do |m|
  increased += 1 if m > prev
  prev = m
end

puts "# of measurement increases: #{increased}"

# PART 2: count the number of times a 3-element sliding sum increases

increased = -1
prev_sum = 0
input.each_cons(3) do |w|
  increased += 1 if w.sum > prev_sum
  prev_sum = w.sum
end

puts "# of 3-window increases: #{increased}"
