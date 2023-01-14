from std/parseutils import parseInt
from std/algorithm import sort, Descending

var elves = @[0]
var input = open("in/input1")
var line: string
while input.readLine(line):
  if line == "":
    elves.add(0)
  else:
    var num: int
    discard line.parseInt(num, 0)
    elves[elves.len() - 1] += num
elves.sort(Descending)
echo "Part 1: ", elves[0]
echo "Part 2: ", elves[0] + elves[1] + elves[2]
close(input)
