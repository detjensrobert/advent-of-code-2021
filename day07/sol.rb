#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.split(',').map(&:to_i)

# PART 1: Given a list of positions, find the position for which the least fuel
# is spent to move to all listed positions. How much total fuel is spent?

# sort all possible values by fuel cost
starts = (input.min..input.max).map do |p|
  [p, input.reduce(0) { |fuel, x| fuel + (p - x).abs }]
end.sort_by { |x| x[1] }.to_h

puts "Total fuel from best position #{starts.first.join(': ')}"

# Part 2: Fuel cost is not linear and increases with distance. What is the total
# cost from the new best starting position?

# memoize cost calculation
$costs = { 0 => 0 }
def calc_fuel(dist)
  $costs[dist] || $costs[dist] = dist - 1
end

# sort all possible values by fuel cost -- non-linear
starts = (input.min..input.max).map do |p|
  [p, input.reduce(0) { |fuel, x| fuel + calc_fuel((p - x).abs) }]
end.sort_by { |x| x[1] }.to_h

puts "Total non-linear fuel from best position #{starts.first.join(': ')}"
