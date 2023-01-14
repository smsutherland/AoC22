from parseutils import parseInt
from std/enumerate import enumerate
from strutils import split

var
  input = open("in/input5")
  line: string

# read initial stacks
var stack_strs: seq[string]
while input.readLine(line):
  if line == "":
    break
  stack_strs.add(line)

var
  num_stacks: int
  num_row = stack_strs[stack_strs.len() - 1]
discard parseInt($num_row[num_row.len() - 2], num_stacks)

var stacks: seq[seq[char]]
for _ in 0..<num_stacks:
  stacks.add(@[])

for i in countdown(stack_strs.len()-2, 0):
  var row = stack_strs[i]
  for j, k in enumerate(countup(1, 4*num_stacks-3, 4)):
    var c = row[k]
    if c != ' ':
      stacks[j].add(c)

var stacks2 = stacks
# read operations
type Operation = tuple[num: int, src: int, dst: int]

var ops: seq[Operation]

while input.readLine(line):
  if line == "": continue
  var
    num, src, dst: int
    parts = line.split(' ')
  discard parseInt(parts[1], num)
  discard parseInt(parts[3], src)
  discard parseInt(parts[5], dst)
  ops.add((num, src-1, dst-1))
close(input)

# execute ops
for op in ops:
  var temp_stack: seq[char]
  for _ in 1..op.num:
    var crate = stacks[op.src].pop()
    stacks[op.dst].add(crate)
    crate = stacks2[op.src].pop()
    temp_stack.add(crate)
  for _ in 1..op.num:
    var crate = temp_stack.pop()
    stacks2[op.dst].add(crate)

var part1 = ""
for stack in stacks:
  part1.add(stack[stack.len()-1])

var part2 = ""
for stack in stacks2:
  part2.add(stack[stack.len()-1])

echo "Part 1: ", part1
echo "Part 2: ", part2
