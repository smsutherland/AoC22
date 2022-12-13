import parseutils, strutils, std/enumerate, algorithm

type
  Monkey = object
    items: seq[int]
    operation: (Op, int)
    divisibility_check: int
    test_pass_target: int
    test_fail_target: int
  
  MonkeyRef = ref Monkey
  
  Op = enum Mul, Plus

proc apply_op(operand: int, op: tuple[op: Op, operand: int]): int =
  case op[0]:
  of Mul:
    if op[1] == -1:
      return operand * operand
    else:
      return operand * op[1]
  of Plus:
    if op[1] == -1:
      return operand + operand
    else:
      return operand + op[1]


var
  input = open("in/input11")
  line: string
  monkeys1: seq[MonkeyRef]
  monkeys2: seq[MonkeyRef]

while input.readLine(line):
  if line == "":
    continue
  
  discard input.readLine(line)
  var
    items = line.split(": ")[1].split(", ")
    item_nums = newSeq[int](items.len())
  for i, item in enumerate(items):
    discard item.parseInt(item_nums[i])

  discard input.readLine(line)
  var exp_parts = line.split("= ")[1].split(' ')
  assert exp_parts[0] == "old"
  var
    op = case exp_parts[1]:
      of "*":
        Mul
      of "+":
        Plus
      else:
        continue
    operand: int
  if exp_parts[2] == "old":
    operand = -1
  else:
    discard exp_parts[2].parseInt(operand)
  
  discard input.readLine(line)
  var divisibility_check: int
  discard line.split("by ")[1].parseInt(divisibility_check)

  discard input.readLine(line)
  var test_pass_target: int
  discard line.split("key ")[1].parseInt(test_pass_target)

  discard input.readLine(line)
  var test_fail_target: int
  discard line.split("key ")[1].parseInt(test_fail_target)

  monkeys1.add(MonkeyRef(
    items: item_nums,
    operation: (op, operand),
    divisibility_check: divisibility_check,
    test_pass_target: test_pass_target,
    test_fail_target: test_fail_target,
  ))
  monkeys2.add(MonkeyRef(
    items: item_nums,
    operation: (op, operand),
    divisibility_check: divisibility_check,
    test_pass_target: test_pass_target,
    test_fail_target: test_fail_target,
  ))

var
  num_inspections = newSeq[int](monkeys1.len())
  max_worry = 1

for monkey in monkeys1:
  max_worry *= monkey.divisibility_check

for round in countup(1, 20):
  for i, monkey in enumerate(monkeys1):
    for item in monkey.items:
      inc(num_inspections[i])
      var new_item = apply_op(item, monkey.operation)
      new_item = new_item div 3
      if new_item mod monkey.divisibility_check == 0:
        monkeys1[monkey.test_pass_target].items.add(new_item)
      else:
        monkeys1[monkey.test_fail_target].items.add(new_item)
    monkey.items = @[]

num_inspections.sort(Descending)
echo num_inspections
echo "Part 1: ", num_inspections[0] * num_inspections[1]

num_inspections = newSeq[int](monkeys1.len())

for round in countup(1, 10000):
  for i, monkey in enumerate(monkeys2):
    for item in monkey.items:
      inc(num_inspections[i])
      var new_item = apply_op(item, monkey.operation)
      new_item = new_item mod max_worry
      if new_item mod monkey.divisibility_check == 0:
        monkeys2[monkey.test_pass_target].items.add(new_item)
      else:
        monkeys2[monkey.test_fail_target].items.add(new_item)
    monkey.items = @[]

num_inspections.sort(Descending)
echo num_inspections
echo "Part 1: ", num_inspections[0] * num_inspections[1]

