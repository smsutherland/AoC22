import sets
import parseutils

type Position = (int, int)

var
  visited1: HashSet[Position]
  visited2: HashSet[Position]
  input = open("in/input9")
  line: string
  positions1 = [(0, 0), (0, 0)]
  positions2 = [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]
visited1.incl(positions1[1])
visited2.incl(positions2[9])

proc `+=`(lhs: var Position, rhs: Position) =
  lhs = (lhs[0] + rhs[0], lhs[1] + rhs[1])

proc sgn(a: int): int =
  if a > 0:
    return 1
  if a < 0:
    return -1
  return 0

proc update_tail_pos(head_pos: Position, tail_pos: var Position) =
  while true:
    var
      dx = head_pos[0] - tail_pos[0]
      dy = head_pos[1] - tail_pos[1]
    if abs(dx) <= 1 and abs(dy) <= 1:
      return
    tail_pos += (sgn(dx), sgn(dy))

while input.readLine(line):
  if line == "":
    continue
  var dist: int
  discard parseInt(line, dist, 2)
  var dr = case line[0]:
    of 'L':
      (-1, 0)
    of 'R':
      (1, 0)
    of 'U':
      (0, 1)
    of 'D':
      (0, -1)
    else:
      continue
  for _ in countup(1, dist):
    positions1[0] += dr
    update_tail_pos(positions1[0], positions1[1])
    visited1.incl(positions1[1])
    
    positions2[0] += dr
    for i in countup(0, 8):
      update_tail_pos(positions2[i], positions2[i+1])
    visited2.incl(positions2[9])

echo "Part 1: ", visited1.len()
echo "Part 2: ", visited2.len()