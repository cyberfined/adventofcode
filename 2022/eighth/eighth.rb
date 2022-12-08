#!/usr/bin/env ruby

def is_visible(grid, x, y)
  return true if (x+1..grid[y].length-1).all? { |right| grid[y][right] < grid[y][x] }
  return true if (x-1).downto(0).all? { |left| grid[y][left] < grid[y][x] }
  return true if (y+1..grid.length-1).all? { |up| grid[up][x] < grid[y][x] }
  return true if (y-1).downto(0).all? { |down| grid[down][x] < grid[y][x] }
  
  false
end

def first(grid)
  num_visible = 0
  (0..grid.length-1).each do |y|
    (0..grid[y].length-1).each do |x|
      num_visible += 1 if is_visible(grid, x, y)
    end
  end
  num_visible
end

def scenic_score(grid, x, y)
  right_score = left_score = up_score = down_score = 0
  (x+1..grid[y].length-1).each do |right|
    right_score += 1

    break if grid[y][right] >= grid[y][x]
  end
  (x-1).downto(0).each do |left|
    left_score += 1

    break if grid[y][left] >= grid[y][x]
  end
  (y+1..grid.length-1).each do |up|
    up_score += 1

    break if grid[up][x] >= grid[y][x]
  end
  (y-1).downto(0).each do |down|
    down_score += 1

    break if grid[down][x] >= grid[y][x]
  end

  [right_score, left_score, up_score, down_score].inject(1) { |x, acc| x * acc }
end

def second(grid)
  max_score = 0
  (0..grid.length-1).each do |y|
    (0..grid[y].length-1).each do |x|
      current_score = scenic_score(grid, x, y)
      max_score = current_score if current_score > max_score
    end
  end
  max_score
end

grid = File.read('input').split("\n").map { |line| line.chars.map(&:to_i) }
puts first(grid)
puts second(grid)
