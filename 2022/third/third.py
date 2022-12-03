#!/usr/bin/env python

def priority(letter):
    if letter >= "a" and letter <= "z":
        return ord(letter) - ord("a") + 1
    elif letter >= "A" and letter <= "Z":
        return ord(letter) - ord("A") + 27

def first():
    total = 0
    with open("input") as inp:
        for line in inp:
            line = line.strip()
            half = len(line) // 2
            first_compartment = line[0:half]
            second_compartment = line[half:]

            for i in range(len(first_compartment)):
                letter = first_compartment[i]
                if letter in second_compartment:
                    total += priority(letter)
                    break
    return total

def second():
    total = 0
    with open("input") as inp:
        group = [None, None, None]
        i = 0
        for line in inp:
            group[i] = set(x for x in line.strip())
            i += 1
            if i == 3:
                i = 0
                total += priority(next(iter(group[0] & group[1] & group[2])))
                continue
    return total

first_scores = first()
print(first_scores)

second_scores = second()
print(second_scores)
