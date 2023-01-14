import union
from strutils import delete, startsWith
from parseutils import parseInt

type
  Fiel = object
    name: string
    length: int

  DirRef = ref Dir
  Dir = object
    name: string
    children: seq[union(DirRef | Fiel)]
    size: int

var
  line: string
  input = open("in/input7")
  root_dir = DirRef(name: "/", children: @[])
  dir_stack = @[root_dir]

proc echo_dir(dir: DirRef, depth: Natural) =
  for _ in 1..depth:
    stdout.write "  "
  echo "- ", dir.name, " (dir, size=", dir.size, ")"
  for child in dir.children:
    unpack(child):
      when it is DirRef:
        echo_dir(it, depth + 1)
      elif it is Fiel:
        for _ in 0..depth:
          stdout.write "  "
        echo "- ", it.name, " (file, size=", it.length, ")"

proc echo_dir(dir: DirRef) =
  echo_dir(dir, 0)

proc `$`(dir: DirRef): string =
  return $dir[]

while input.readLine(line):
  if line[0] == '$':
    line.delete(0..1)
    if line.startsWith("cd "):
      line.delete(0..2)
      if line == "..":
        discard dir_stack.pop()
      elif line == "/":
        while dir_stack.len() > 1:
          discard dir_stack.pop()
      else:
        for child in dir_stack[dir_stack.len() - 1].children:
          unpack(child):
            when it is DirRef:
              if it.name == line:
                dir_stack.add(it)
  else:
    if line.startsWith("dir"):
      line.delete(0..3)
      var new_dir = DirRef(name: line, children: @[])
      var current_dir: DirRef = dir_stack[dir_stack.len() - 1]
      current_dir.children.add(new_dir as union(DirRef | Fiel))
    else:
      var
        size: int
        num_len = line.parseInt(size)
      line.delete(0..num_len)
      var new_fiel = Fiel(name: line, length: size)
      dir_stack[dir_stack.len() - 1].children.add(new_fiel as union(DirRef | Fiel))
      for dir in dir_stack:
        dir.size += size
close(input)

echo_dir(root_dir)

proc sum_dirs_no_more_than_n(root: DirRef, n: int): int =
  if root.size <= n:
    result = root.size
  for child in root.children:
    unpack(child):
      when it is DirRef:
        result += sum_dirs_no_more_than_n(it, n)

var space_needed = root_dir.size - 40000000
proc find_smallest_larger_than_n(root: DirRef, n: int): DirRef =
  var min_size = high(int)
  if root.size >= n and root.size < min_size:
    result = root
    min_size = root.size
  for child in root.children:
    unpack(child):
      when it is DirRef:
        var smallest = find_smallest_larger_than_n(it, n)
        if not isNil smallest:
          if smallest.size >= n and smallest.size < min_size:
              result = smallest
              min_size = smallest.size

echo "Part 1: ", sum_dirs_no_more_than_n(root_dir, 100000)
echo "Part 2: ", find_smallest_larger_than_n(root_dir, space_needed).size