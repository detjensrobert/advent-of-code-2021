#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.split(',').map(&:to_i)
data = input.dup

# PART 1: Laternfish reproduce every 8 days. Given a list of Laternfish (as days
# remaining until next split), how many Laternfish are there after 80 days?

def fish_iter(fish)
  fish.map { |f| (f - 1).negative? ? 6 : f - 1 } + [8] * fish.count(0)
end

80.times { data = fish_iter(data) }

puts "Number of fish in 80 days: #{data.size}"

# PART 2: How many fish fter 256 days?

data = input.dup

# Lets try Ractors for multicore
# each ractor takes a chunk of data
# modifies its array

# monkeypatch Array to add .in_groups https://stackoverflow.com/questions/12374645/
class Array
  def in_groups(number)
    group_size = size / number
    leftovers = size % number

    groups = []
    start = 0
    number.times do |index|
      length = group_size + (leftovers.positive? && leftovers > index ? 1 : 0)
      groups << slice(start, length)
      start += length
    end

    groups
  end
end

require 'etc'
n = Etc.nprocessors - 2

puts "using #{n} ractors"

256.times do |i|
  parts = data.in_groups(n)

  # puts "made #{parts.size} chunks: #{parts}"
  workers = parts.map do |p|
    # create ractor with job data as arg
    Ractor.new(p.clone) do |slice|
      # wait for work
      # puts "got data: #{slice}"
      Ractor.yield fish_iter(slice)
    end
  end

  # wait for all jobs to finish
  data = workers.map(&:take).flatten

  # puts data.sort.to_s
  puts "iter #{i}: #{data.size} fish"
end

puts "Number of fish in 256 days: #{data.size}"
