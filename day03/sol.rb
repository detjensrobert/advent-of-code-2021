#!/usr/bin/env ruby

input = ARGF.readlines.map(&:strip)

# PART 1: Generate the gamma and epsilon rate from the binary input. The gamma
# rate is the most common bit for each positon, and epsilon is the least common.

# bit_totals = [0] * input[0].size

# input.each do |num|
#   # add each bit to totals array
#   num.size.times { |i| bit_totals[i] += num.to_i[i] }
# end

# puts "#{bit_totals.join(' ')}"

# # convert any majority bit counts to 1/0
# gamma = bit_totals.map { |count| count > (input.size / 2) ? 1 : 0 }.reverse.join.to_i(2)
# # hacky binary inversion
# epsilon = (1 << input[0].size) - gamma - 1

# ^ this didnt work, try array transpose + sum

transposed = input.map { |l| l.split '' }.transpose

# now this iterates over each digit instead of each number
gamma = 0
transposed.each do |digits|
  gamma <<= 1
  gamma += 1 if digits.count('1') > input.size / 2
end
epsilon = (1 << input[0].size) - gamma - 1

puts "gamma  : #{gamma.to_s(2).rjust(input[0].size, '0')}"
puts "epsilon: #{epsilon.to_s(2).rjust(input[0].size, '0')}"
puts "gm * ep: #{gamma * epsilon}"

# PART 2: Find the O2 generator and CO2 scrubber ratings. To find oxygen generator rating, determine the most common
# value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are
# equally common, keep values with a 1 in the position being considered. To find CO2 scrubber rating, determine the
# least common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0
# and 1 are equally common, keep values with a 0 in the position being considered.

def delete_col(matrix, i)
  matrix.each {|r| r.delete_at(i) }
end

i = 0
while transposed[0].size > 1
  puts
  puts transposed.transpose.inspect
  majority_ones = transposed[i].count('1') > input.size / 2
  transposed.each.with_index do |digits, di|
    delete_col(transposed, di) unless digits[i] == (majority_ones ? '1' : '0')
  end
  i += 1
end

puts transposed.transpose.join
