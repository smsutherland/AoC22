from sequtils import map, foldl

type Rucksack = tuple[first: set[char], second: set[char]]

proc combine(sack: Rucksack): set[char] =
  return sack.first + sack.second

proc two_set(s: string): set[char] = 
  result = {} 
  for c in s:
    result.incl(c)

var
  sacks: seq[Rucksack]
  input = open("in/input3")
  line: string
while input.readLine(line):
  if line == "": continue
  var l = int(line.len()/2)
  sacks.add((line[0..<l].two_set(), line[l..<line.len()].two_set()))

proc priority(c: char): int =
    return case c:
      of 'a'..'z': c.ord() - 96
      of 'A'..'Z': c.ord() - 64 + 26
      else: 0

proc score(sack: Rucksack): int =
  var inter = sack.first * sack.second
  for c in inter:
    result += c.priority

echo "Part 1: ", sacks.map(score).foldl(a+b)

var score2 = 0

for i in 0..<int(sacks.len()/3):
  var
    sack1 = sacks[3*i].combine()
    sack2 = sacks[3*i+1].combine()
    sack3 = sacks[3*i+2].combine()

  var badge = sack1 * sack2 * sack3
  for c in badge:
    score2 += c.priority()

echo "Part 2: ", score2
