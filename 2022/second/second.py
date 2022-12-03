#!/usr/bin/env python

wins = {"A": "Y", "B": "Z", "C": "X"}
draws = {"A": "X", "B": "Y", "C": "Z"}
losses = {"A": "Z", "B": "X", "C": "Y"}
scores = {"X": 1, "Y": 2, "Z": 3}

def first():
    total = 0
    with open("input") as inp:
        for line in inp:
            toks = line.split(" ")
            opponent = toks[0].strip()
            yours = toks[1].strip()
            total += scores[yours]

            if wins[opponent] == yours:
                total += 6
            elif draws[opponent] == yours:
                total += 3
    return total

def second():
    total = 0
    with open("input") as inp:
        for line in inp:
            toks = line.split(" ")
            opponent = toks[0].strip()
            yours = toks[1].strip()

            if yours == "X":
                yours = losses[opponent]
            elif yours == "Y":
                yours = draws[opponent]
                total += 3
            elif yours == "Z":
                yours = wins[opponent]
                total += 6

            total += scores[yours]

    return total

first_scores = first()
print(first_scores)

second_scores = second()
print(second_scores)
