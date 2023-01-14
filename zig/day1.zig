const std = @import("std");

pub fn main() !void {
    const input = @embedFile("in/input1");
    var nums = std.mem.split(u8, input, "\n");
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    var elves = std.ArrayList(u32).init(alloc.allocator());
    defer elves.deinit();
    var current_elf: u32 = 0;
    while (nums.next()) |elf| {
        if (elf.len == 0) {
            try elves.append(current_elf);
            current_elf = 0;
        } else {
            current_elf += try std.fmt.parseInt(u32, elf, 10);
        }
    }

    std.sort.sort(u32, elves.items, {}, std.sort.desc(u32));

    const items = elves.items;

    std.debug.print("Part 1: {}\nPart 2: {}\n", .{ items[0], items[0] + items[1] + items[2] });
}
