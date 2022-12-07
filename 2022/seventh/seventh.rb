#!/usr/bin/env ruby

require 'pathname'

def add_dir(dirs, dir, size)
  parent_dir = dirs
  subdirs = dir.root? ? [] : (dir.to_s.split('/')[1..-2] || []).insert(0, '/')
  subdirs.each do |subdir|
    parent_dir = parent_dir[subdir]
    parent_dir['size'] += size
    parent_dir = parent_dir['dirs']
  end
  parent_dir[dir.basename.to_s] = { 'dirs' => {}, 'size' => size }
end

def find_sum(dirs, sum)
  sum += dirs['size'] if dirs['size'] <= 100000

  dirs['dirs'].each do |_, dir|
    sum = find_sum(dir, sum)
  end

  sum
end

def dir_to_delete(dirs, available, result)
  if available + dirs['size'] >= 30000000 && dirs['size'] < result
    result = dirs['size']
  end

  dirs['dirs'].each do |_, dir|
    result = dir_to_delete(dir, available, result)
  end

  result
end

def first(root)
  find_sum(root, 0)
end

def second(root)
  dir_to_delete(root, 70000000 - root['size'], 70000000)
end

dirs = {}
cur_dir = Pathname.new("/")
list_files = false
total_size = 0

File.open('input').each do |line|
  if line.start_with?('$ cd')
    dir = line.split(' ').last
    add_dir(dirs, cur_dir, total_size) if list_files
    cur_dir = cur_dir.join(Pathname.new(dir))
    list_files = false
  elsif line.start_with?('$ ls')
    cur_dir
    list_files = true
    total_size = 0
  elsif list_files
    type, file = line.split(' ')
    if type != 'dir'
      size = type.to_i
      total_size += size
    end
  end
end
add_dir(dirs, cur_dir, total_size)

root = dirs.first.last
first_answer = first(root)
puts first_answer

second_answer = second(root)
puts second_answer
