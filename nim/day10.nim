import parseutils

var
  input = open("in/input10")
  line: string
  x = 1
  cycle = 1
  signal_sum = 0

while input.readLine(line):
  if line == "":
    continue
  var
    num_cycles: int
    dx = 0
  case line[0]:
  of 'a':
    num_cycles = 2
    discard parseInt(line, dx, 5)
  of 'n':
    num_cycles = 1
  else:
    discard

  for _ in countup(1, num_cycles):
    if (cycle - 1) mod 40 == 0:
      stdout.write("\n")
    if abs(x - ((cycle - 1) mod 40)) <= 1:
      stdout.write("#")
    else:
      stdout.write(" ")
    if (cycle - 20) mod 40 == 0:
      signal_sum += cycle*x
    inc(cycle)

  x += dx

echo ""
echo "Part 1: ", signal_sum