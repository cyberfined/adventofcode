#!/usr/bin/env python

def is_contains(first_range, second_range):
    return (first_range[0] <= second_range[0] and first_range[1] >= second_range[1] or
            second_range[0] <= first_range[0] and second_range[1] >= first_range[1])

def is_overlap(first_range, second_range):
    return (first_range[0] >= second_range[0] and first_range[0] <= second_range[1] or
            first_range[1] >= second_range[0] and first_range[1] <= second_range[1] or
            second_range[0] >= first_range[0] and second_range[0] <= first_range[1] or
            second_range[1] >= first_range[0] and second_range[1] <= first_range[0])


def generic_solution(pred):
    total = 0
    with open("input") as inp:
        for line in inp:
            ranges = list(map(lambda x: x.split("-"), line.strip().split(",")))
            first_range = list(map(int, ranges[0]))
            second_range = list(map(int, ranges[1]))
            if pred(first_range, second_range):
                total += 1
    return total

first_result = generic_solution(is_contains)
print(first_result)

second_result = generic_solution(is_overlap)
print(second_result)
