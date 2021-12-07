#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.split(',').map(&:to_i)
data = input.dup

# PART 1: Laternfish reproduce every 8 days. Given a list of Laternfish (as days
# remaining until next split), how many Laternfish are there after 80 days?

def fish_iter(fish)
  # new_fish = [8] * fish.count(0)
  new_fish = []
  new_fish += fish.map { |f| (f - 1) % 7}
end

10.times do
  data = fish_iter(data)

  STDERR.puts data.sort.to_s
end

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
      length = group_size + (leftovers > 0 && leftovers > index ? 1 : 0)
      groups << slice(start, length)
      start += length
    end

    groups
  end
end

require 'etc'
n = Etc.nprocessors

puts "using #{n} ractors"

10.times do |i|
  # puts "iter #{i}"

  parts = data.in_groups(n)

  # puts "made #{parts.size} chunks: #{parts}"
  workers = parts.map do |p|
    # create ractor with job data as arg
    Ractor.new(p.clone) do |slice|
      # wait for work
      # puts "got data: #{slice}"

      # do the work
      new_fish = 0
      new_slice = slice.map do |f|
        f -= 1 # decrement count

        if f < 0        # time to split?
          f = 6         # reset counter
          new_fish += 1 # add another fish to add
        end

        f # return new counter  q
      end

      # add any new fish
      new_fish.times { new_slice << 8 }

      # send result back to main thread
      Ractor.yield new_slice
    end
  end

  # wait for all jobs to finish
  data = workers.map(&:take).flatten

  puts data.sort.to_s
end

puts "Number of fish in 256 days: #{data.size}"
