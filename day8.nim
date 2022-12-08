from sequtils import newSeqWith, all
import std/enumerate
import std/terminal

type
  Tree = object
    height: int
    visible: bool
  Forest = seq[seq[Tree]]

proc `[]`(forest: Forest, x: int, y: int): Tree =
  return forest[y][x]

proc `[]=`(forest: var Forest, x: int, y: int, rhs: Tree) =
  forest[y][x] = rhs

proc `[]=`(forest: var Forest, x: int, y: int, rhs: tuple[height: int, visible: bool]) =
  var new_tree = Tree(height: rhs.height, visible: rhs.visible)
  forest[y][x] = new_tree

proc to_int(c: char): int =
  return ord(c) - 48

proc echo_forest(forest: Forest) =
  for row in forest:
    for tree in row:
      if tree.visible:
        stdout.styledWrite(fgGreen, $tree.height)
      else:
        stdout.styledWrite(fgRed, $tree.height)
    stdout.write("\n")

var
  input = open("in/input8")
  line: string
  trees: Forest

discard input.readLine(line)
var size_len = line.len()
trees = newSeqWith(size_len, newSeq[Tree](size_len))

for x, c in enumerate(line):
  trees[x, 0] = (to_int(c), false)

var y = 1
while input.readLine(line):
  for x, c in enumerate(line):
    trees[x, y] = (to_int(c), false)
  inc(y)

var visible_trees = 0
var max_heights = newSeq[int](size_len)

# check from the top
for y in countup(0, size_len-1):
  if y == 0:
    for x in countup(0, size_len-1):
      var tree = trees[x, y]
      tree.visible = true
      if not trees[x, y].visible:
        inc(visible_trees)
      trees[x, y] = tree
      max_heights[x] = tree.height
    continue
  for x in countup(0, size_len-1):
    var
      tree = trees[x, y]
      new_tree = (tree.height, tree.height > max_heights[x] or tree.visible)
    if tree.height > max_heights[x]:
      max_heights[x] = tree.height
    if new_tree[1] and not tree.visible:
      inc(visible_trees)
    trees[x, y] = new_tree

# check from the bottom
for y in countdown(size_len-1, 0):
  if y == size_len-1:
    for x in countup(0, size_len-1):
      var tree = trees[x, y]
      if not trees[x, y].visible:
        inc(visible_trees)
      tree.visible = true
      trees[x, y] = tree
      max_heights[x] = tree.height
    continue
  for x in countup(0, size_len-1):
    var
      tree = trees[x, y]
      new_tree = (tree.height, tree.height > max_heights[x] or tree.visible)
    if tree.height > max_heights[x]:
      max_heights[x] = tree.height
    if new_tree[1] and not tree.visible:
      inc(visible_trees)
    trees[x, y] = new_tree

# check from the left
for x in countup(0, size_len-1):
  if x == 0:
    for y in countup(0, size_len-1):
      var tree = trees[x, y]
      if not trees[x, y].visible:
        inc(visible_trees)
      tree.visible = true
      trees[x, y] = tree
      max_heights[y] = tree.height
    continue
  for y in countup(0, size_len-1):
    var
      tree = trees[x, y]
      new_tree = (tree.height, tree.height > max_heights[y] or tree.visible)
    if tree.height > max_heights[y]:
      max_heights[y] = tree.height
    if new_tree[1] and not tree.visible:
      inc(visible_trees)
    trees[x, y] = new_tree

# check from the right
for x in countdown(size_len-1, 0):
  if x == size_len-1:
    for y in countup(0, size_len-1):
      var tree = trees[x, y]
      if not trees[x, y].visible:
        inc(visible_trees)
      tree.visible = true
      trees[x, y] = tree
      max_heights[y] = tree.height
    continue
  for y in countup(0, size_len-1):
    var
      tree = trees[x, y]
      new_tree = (tree.height, tree.height > max_heights[y] or tree.visible)
    if tree.height > max_heights[y]:
      max_heights[y] = tree.height
    if new_tree[1] and not tree.visible:
      inc(visible_trees)
    trees[x, y] = new_tree

echo_forest trees
echo ""
echo "Part 1: ", visible_trees

var max_score = 0

for x in countup(0, size_len-1):
  for y in countup(0, size_len-1):
    let height = trees[x, y].height
    var
      finished = [false, false, false, false]
      visibilities = [0, 0, 0, 0]
    for i in countup(1, size_len-1):
      if all(finished, proc (a: bool): bool = a):
        break
      let 
        left = x-i
        right = x+i
        up = y-i
        down = y+i
      # left
      if not finished[0]:
        if left < 0:
          finished[0] = true
        else:
          let other_height = trees[left, y].height
          if other_height >= height:
            finished[0] = true
          inc(visibilities[0])
      # right
      if not finished[1]:
        if right >= size_len:
          finished[1] = true
        else:
          let other_height = trees[right, y].height
          if other_height >= height:
            finished[1] = true
          inc(visibilities[1])
      # up
      if not finished[2]:
        if up < 0:
          finished[2] = true
        else:
          let other_height = trees[x, up].height
          if other_height >= height:
            finished[2] = true
          inc(visibilities[2])
      # down
      if not finished[3]:
        if down >= size_len:
          finished[3] = true
        else:
          let other_height = trees[x, down].height
          if other_height >= height:
            finished[3] = true
          inc(visibilities[3])
    let score = visibilities[0]*visibilities[1]*visibilities[2]*visibilities[3]
    if score > max_score:
      max_score = score

echo "Part 2: ", max_score
