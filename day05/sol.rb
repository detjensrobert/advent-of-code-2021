#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines

# PART 1: Find the number of lines that overlap

Point = Struct.new(:x, :y)

# parse into coord pair pairs
input.map! do |line|
  m = line.match(/(\d+),(\d+) -> (\d+),(\d+)/)
  pairs = [ Point[m[1].to_i, m[2].to_i], Point[m[3].to_i, m[4].to_i] ]
  pairs.sort_by { |p| "#{p.x}.#{p.y}".to_f } # enforce small->big with X.Y
end

# only look for vertical/horizontal lines
hv = input.keep_if { |s, e| s.x == e.x || s.y == e.y }

# convert pairs to all possible points in line
hv.map! { |s, e| ((s.x..e.x).to_a.product (s.y..e.y).to_a).map{|x, y| Point[x, y] } }

# puts hv.inspect

# find all common points
counts = Hash.new(0)
hv.flatten.each { |p| counts[p] += 1 }
counts.keep_if { |_p, c| c > 1 }

# puts counts

puts "Number of overlapping points: #{counts.size}"
