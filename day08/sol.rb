#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines

# PART 1: Given a list of unique inputs & outputs of scrambled 7-segment display
# signals, how many times to digits 1, 4, 7, 8 appear in the output?

# 1, 4, 7, 8 have unique numbers of segments

input.map! { |l| l.split('|').map(&:split) }

count_1478 = input.map do |line|
  line[1].count { |d| [2, 4, 3, 7].include? d.size }
end.flatten.sum

puts "Number of 1/4/7/8s: #{count_1478}"

# PART 2: The rest of the digits can be deduced from the segments in 1/4/7/8.
# What is the sum of all input values?

# Use top/middle/bottom/topleft/... instead of a/b/c/d/... for clarity
SSD = Struct.new(*%i[top mid bot tl bl tr br])

# now that we have the full mapping, calculate the output digits
def segment_to_digit(segments, m)
  case segments.chars.sort
  when [m.tr, m.br].sort
    '1'
  when [m.top, m.tr, m.mid, m.bl, m.bot].sort
    '2'
  when [m.top, m.tr, m.mid, m.br, m.bot].sort
    '3'
  when [m.tl, m.tr, m.mid, m.br].sort
    '4'
  when [m.top, m.tl, m.mid, m.br, m.bot].sort
    '5'
  when [m.top, m.tl, m.mid, +m.bl, m.br, m.bot].sort
    '6'
  when [m.top, m.tr, m.br].sort
    '7'
  when [m.top, m.tl, m.tr, m.mid, m.bl, m.br, m.bot].sort
    '8'
  when [m.top, m.tl, m.tr, m.mid, m.br, m.bot].sort
    '9'
  when [m.top, m.tl, m.tr, m.bl, m.br, m.bot].sort
    '0'
  else
    print_mapping(m)
    raise "unknown pattern: #{segments}"
  end
end

def print_mapping(m)
  puts <<~EOF.tr('tmblnrs', [m.top, m.mid, m.bot, m.tl, m.bl, m.tr, m.br].map { |s| s || '.' }.join)
     tttt
    l    r
    l    r
     mmmm
    n    s
    n    s
     bbbb
  EOF
end

output_values = input.map do |line, output|
  mapping = SSD.new

  one = line.find { |n| n.length == 2 }.chars
  four = line.find { |n| n.length == 4 }.chars
  seven = line.find { |n| n.length == 3 }.chars
  eight = line.find { |n| n.length == 7 }.chars

  # segment in 7 and not in 1 is the top segment
  mapping.top = (seven - one)[0]
  # puts "top seg: '#{mapping.top}'"

  # the 6-seg that has all segs in common with 4 is 9
  nine = line.find { |n| n.length == 6 && (four - n.chars).empty? }.chars
  # puts "nine: #{nine.join}"

  # segment in 8 and not in 9 is bottom left
  mapping.bl = (eight - nine)[0]

  # segment in 8 and not in 7 or in 4 or bl is bottom
  mapping.bot = (eight - four - seven - [mapping.bl])[0]

  # the 5-seg that has both bottom and botleft is 2
  two = line.find { |n| n.length == 5 && n.index(mapping.bl) && n.index(mapping.bot) }.chars
  # puts "two: #{two.join}"

  # segment in 9 but not in 2 or one is top left
  mapping.tl = (nine - two - one)[0]

  # segment in 7 but not in 2 is bot right
  mapping.br = (seven - two)[0]

  # one minus bottom right is top right
  mapping.tr = (one - [mapping.br])[0]

  # four minus topleft, topright, botright is mid
  mapping.mid = (four - [mapping.tl, mapping.tr, mapping.br])[0]

  digits = output.map { |s| segment_to_digit(s, mapping) }.join

  # puts "output digits: #{digits}"
  digits
end

# puts output_values

puts "sum of all outputs: #{output_values.map(&:to_i).sum}"
