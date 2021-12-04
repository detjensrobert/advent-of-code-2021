#!/usr/bin/env ruby

input = ARGF.read.split("\n\n").map(&:strip)

# PART 1: Find the first winning bingo board.

require 'matrix'

numbers = input.shift.split(',').map(&:to_i)

boards = input.map do |b|
  Matrix.rows b.split("\n").map { |r| r.split.map(&:to_i) }
end

# called numbers are negative
def board_won?(board)
  [
    board.row_vectors.map { |r| r.all? { |v| v.negative? } }, # rows
    board.column_vectors.map { |c| c.all? { |v| v.negative? } } # cols
    # board.map(:diagonal) { |v| v.negative? },                             # NW diagonal
    # Matrix.rows(m.to_a.map(&:reverse)).map(:diagonal) { |v| v.negative? } # SW diagonal
  ].flatten.any?
end

# puts boards.inspect

def game(numbers, boards)
  numbers.each do |call|
    boards.each do |b|
      i, j = b.find_index(call)
      b[i, j] *= -1 if i          # negate if found

      return b, call if board_won?(b)
    end
  end
end

def score(board, call)
  board.to_a.flatten.keep_if(&:positive?).sum * call
end

win_board, win_call = game(numbers, boards)

puts "Board score: #{score(win_board, win_call)}"

# PART 2: What is the score of the last board to win?


def game(numbers, boards)
  numbers.each do |call|
    boards.each do |b|
      i, j = b.find_index(call)
      b[i, j] *= -1 if i          # negate if found

      boards.delete b if board_won?(b)
      return b, call if boards.size == 1
    end
  end
end

win_board, win_call = game(numbers, boards)
puts "Last winning board score: #{score(win_board, win_call)}"
