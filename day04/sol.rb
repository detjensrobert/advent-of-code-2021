#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.split("\n\n").map(&:strip)

# PART 1: Find the first winning bingo board.

require 'matrix'

numbers = input.shift.split(',').map(&:to_i)

boards = input.map do |b|
  Matrix.rows(b.split("\n").map { |r| r.split.map(&:to_i) })
end

# called numbers are negative, so if all numbers in row or col are negative
# that board has won
def board_won?(board)
  (board.row_vectors + board.column_vectors).map { |r| r.all?(&:negative?) }.any?
end

def game(numbers, boards)
  numbers.each do |call|
    boards.each do |b|
      i, j = b.find_index(call)
      b[i, j] *= -1 if i  # negate if called

      return b, call if board_won?(b)
    end
  end
end

def score(board, call)
  board.to_a.flatten.keep_if(&:positive?).sum * call
end

puts "Winning board score: #{score(*game(numbers, boards))}"

# PART 2: What is the score of the last board to win?

def last_game(numbers, boards)
  numbers.each do |call|
    boards.each do |b|
      i, j = b.find_index(call)
      b[i, j] *= -1 if i  # negate when called

      boards.delete b if board_won?(b)
      return b, call if boards.size == 1
    end
  end
end

puts "Last winning board score: #{score(*last_game(numbers, boards))}"
