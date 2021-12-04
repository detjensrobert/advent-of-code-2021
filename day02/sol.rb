#!/usr/bin/env ruby

input = ARGF.readlines

# PART 1: Calculate the horizontal position and depth you would have after
# following the planned course. What do you get if you multiply your final
# horizontal position by your final depth?

input.map! { |l| [l.split[0], l.split[1].to_i] }

depth = 0
h_pos = 0

input.each do |dir, dist|
  case dir
  when 'forward'
    h_pos += dist
  when 'up'
    depth -= dist
  when 'down'
    depth += dist
  end
end

puts "pos * depth = #{depth * h_pos}"

# PART 2: Instead of explicit depth changes, up/down change the aiming.

depth = 0
h_pos = 0
aim = 0

input.each do |dir, dist|
  case dir
  when 'forward'
    h_pos += dist
    depth += dist * aim
  when 'up'
    aim -= dist
  when 'down'
    aim += dist
  end
end

puts "pos * depth with aiming = #{depth * h_pos}"
