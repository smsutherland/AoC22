from sequtils import map, foldl
from strutils import split
from parseutils import parseInt

type
  Range = array[0..1, int]
  Pair = array[0..1, Range]

proc contains(first: Range, second: Range): bool =
  return first[0] <= second[0] and first[1] >= second[1]

proc contains(pair: Pair): bool =
  return pair[0].contains(pair[1]) or pair[1].contains(pair[0])

proc overlaps(first: Range, second: Range): bool =
  return (first[0] <= second[0] and first[1] >= second[0]) or (first[0] <= second[1] and first[1] >= second[1]) or contains(first, second) or contains(second, first)

proc overlaps(pair: Pair): bool =
  return overlaps(pair[0], pair[1])

var 
  input = open("in/input4")
  line: string
  elves: seq[Pair]

while input.readLine(line):
  var
    parts = line.split(',')
    first = parts[0]
    second = parts[1]
    first_bounds = first.split('-')
    second_bounds = second.split('-')
    first_bound_1, first_bound_2, second_bound_1, second_bound_2: int
  discard first_bounds[0].parseInt(first_bound_1)
  discard first_bounds[1].parseInt(first_bound_2)
  discard second_bounds[0].parseInt(second_bound_1)
  discard second_bounds[1].parseInt(second_bound_2)
  elves.add([[first_bound_1, first_bound_2], [second_bound_1, second_bound_2]])

echo "Part 1: ", elves.map(proc (p: Pair): int =
  if p.contains():
    return 1
  else:
    return 0
  ).foldl(a+b)

echo "Part 2: ", elves.map(proc (p: Pair): int =
  if p.overlaps():
    return 1
  else:
    return 0
  ).foldl(a+b)
