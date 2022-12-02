type RPS = enum Rock, Paper, Scissors
type Game = tuple[them: RPS, us: RPS]

var games1: seq[Game]
var games2: seq[Game]
var input = open("in/input2")
var line: string
while input.readLine(line):
    if line == "": continue
    var them: RPS
    var us1: RPS
    var us2: RPS
    case line[0]
    of 'A':
        them = Rock
    of 'B':
        them = Paper
    of 'C':
        them = Scissors
    else:
        discard
    case line[2]
    of 'X':
        us1 = Rock
        case them:
        of Rock:
            us2 = Scissors
        of Paper:
            us2 = Rock
        of Scissors:
            us2 = Paper
    of 'Y':
        us1 = Paper
        us2 = them
    of 'Z':
        us1 = Scissors
        case them:
        of Rock:
            us2 = Paper
        of Paper:
            us2 = Scissors
        of Scissors:
            us2 = Rock
    else:
        discard

    games1.add((them, us1))
    games2.add((them, us2))

proc score(game: Game): int =
    case game.us:
    of Rock:
        result += 1
        case game.them:
        of Rock:
            result += 3
        of Paper:
            result += 0
        of Scissors:
            result += 6
    of Paper:
        result += 2
        case game.them:
        of Rock:
            result += 6
        of Paper:
            result += 3
        of Scissors:
            result += 0        
    of Scissors:
        result += 3
        case game.them:
        of Rock:
            result += 0
        of Paper:
            result += 6
        of Scissors:
            result += 3

var total_score = 0
for game in games1:
    total_score += game.score()

echo "Part 1: ", total_score

total_score = 0
for game in games2:
    total_score += game.score()

echo "Part 2: ", total_score
