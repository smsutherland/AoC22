var
  input = open("in/input6")
  line: string

discard input.readLine(line)
# line = "bvwbjplbgvbhsrlpgdmjqwftvncz"
# line = "nppdvjthqldpwncqszvftbrmjlhg"
# line = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
line = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

proc is_marker(s: string): bool =
  for i in 0..<3:
    for j in (i+1)..<4:
      if s[i] == s[j]:
        return false
  return true

for i in countup(0, line.len()-4):
  var sub = line.substr(i, i+3)
  if is_marker(sub):
    echo "Part 1: ", i+4
    break

proc is_message(s: string): bool =
  for i in 0..<13:
    for j in (i+1)..<14:
      if s[i] == s[j]:
        return false
  return true

for i in countup(0, line.len()-14):
  var sub = line.substr(i, i+13)
  if is_message(sub):
    echo "Part 1: ", i+14
    break
