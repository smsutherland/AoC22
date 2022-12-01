from std/parseutils import parseInt
import std/algorithm

var elves: seq[int] = @[0]
var input = open("in/input1")
var line: string
while input.readLine(line):
  if line == "":
    add(elves, 0)
  else:
    var num: int
    discard parseInt(line, num, 0)
    elves[len(elves) - 1] += num
sort(elves, Descending)
echo "Part 1: ", elves[0]
echo "Part 2: ", elves[0] + elves[1] + elves[2]
close(input)
