#!/usr/bin/env ruby

def parse_stacks(stacks_str)
  stacks = []
  stacks_str.split("\n").reverse.drop(1).each do |stack_str|
    stack_str.chars.each_with_index do |chr, idx|
      next unless ('A'..'Z').include?(chr)

      current_stack = idx / 4
      stacks[current_stack] = [] unless stacks[current_stack]
      stacks[current_stack] << chr
    end
  end
  stacks
end

def commands_processor(commands)
  command_regex = /move\s+(\d+)\s+from\s+(\d+)\s+to\s+(\d+)/
  commands.split("\n").each do |command|
    match = command_regex.match(command)
    count = match[1].to_i
    from = match[2].to_i - 1
    to = match[3].to_i - 1
    yield(count, from, to)
  end
end

def generic_solution
  input = File.open('input') { |fd| fd.read }
  stacks_str, commands = input.split("\n\n")
  stacks = parse_stacks(stacks_str)
  commands_processor(commands) { |count, from, to| yield(stacks, count, from, to) }
  stacks.map { |stack| stack.last }.join
end

def first
  result = generic_solution do |stacks, count, from, to|
    count.times do
      elem = stacks[from].pop
      stacks[to] << elem
    end
  end
  puts result
end

def second
  result = generic_solution do |stacks, count, from, to|
    stacks[to] += stacks[from].pop(count)
  end
  puts result
end

first
second
