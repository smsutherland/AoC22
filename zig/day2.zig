const std = @import("std");

const RPS = enum(u8) { Rock = 1, Paper, Scissors };
const Game = struct {
    them: RPS,
    us: RPS,
    fn score(self: *const Game) u32 {
        const scores = [_]u32{ 3, 6, 0 };
        return @enumToInt(self.us) + scores[(3 + @enumToInt(self.us) - @enumToInt(self.them)) % 3];
    }
};

pub fn main() !void {
    const input = @embedFile("in/input2");
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    var games1 = std.ArrayList(Game).init(alloc.allocator());
    defer games1.deinit();
    var games2 = std.ArrayList(Game).init(alloc.allocator());
    defer games2.deinit();

    const a = .{
        RPS.Scissors,
        RPS.Rock,
    };
    _ = a;

    var games = std.mem.split(u8, input, "\n");
    while (games.next()) |game| {
        if (game.len == 0) continue;
        const them = switch (game[0]) {
            'A' => RPS.Rock,
            'B' => RPS.Paper,
            'C' => RPS.Scissors,
            else => unreachable,
        };
        const us: struct { RPS, RPS } = switch (game[2]) {
            'X' => .{ RPS.Rock, switch (them) {
                RPS.Rock => RPS.Scissors,
                RPS.Paper => RPS.Rock,
                RPS.Scissors => RPS.Paper,
            } },
            'Y' => .{ RPS.Paper, them },
            'Z' => .{ RPS.Scissors, switch (them) {
                RPS.Rock => RPS.Paper,
                RPS.Paper => RPS.Scissors,
                RPS.Scissors => RPS.Rock,
            } },
            else => unreachable,
        };
        const us1 = us.@"0";
        const us2 = us.@"1";
        try games1.append(.{ .us = us1, .them = them });
        try games2.append(.{ .us = us2, .them = them });
    }

    var score1: u32 = 0;
    for (games1.items) |game| {
        score1 += game.score();
    }
    var score2: u32 = 0;
    for (games2.items) |game| {
        score2 += game.score();
    }
    std.debug.print("Part 1: {}\nPart 2: {}", .{ score1, score2 });
}
