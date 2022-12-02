import sequtils

type RPS = enum Rock = 1, Paper = 2, Scissors = 3
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
    them = case line[0]:
        of 'A': Rock
        of 'B': Paper
        of 'C': Scissors
        else: continue
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
    return game.us.ord() + [3, 6, 0][(game.us.ord() - game.them.ord() + 3) mod 3]

echo "Part 1: ", games1.map(score).foldl(a + b)
echo "Part 2: ", games2.map(score).foldl(a + b)
