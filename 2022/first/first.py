#!/usr/bin/env python

with open("input") as inp:
    calories_by_elf = []
    for calories in inp.read().split("\n\n"):
        calories_by_elf.append(sum(int(x) for x in calories.split("\n") if x != ''))
    calories_by_elf.sort(reverse = True)
    print(calories_by_elf[0])
    print(calories_by_elf[0] + calories_by_elf[1] + calories_by_elf[2])
