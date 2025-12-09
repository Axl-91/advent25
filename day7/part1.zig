const std = @import("std");
const data = @embedFile("input");

fn value_exists(value: usize, array: *std.ArrayList(usize)) bool {
    for (array.items) |array_value| {
        if (array_value == value) {
            return true;
        }
    }
    return false;
}

fn check_rays(pos_line: usize, pos_vec: *std.ArrayList(usize), allocator: std.mem.Allocator) !bool {
    for (0.., pos_vec.items) |i, ray| {
        if (ray == pos_line) {
            _ = pos_vec.orderedRemove(i);
            if (!value_exists(ray + 1, pos_vec)) {
                try pos_vec.append(allocator, ray + 1);
            }
            if (ray != 0 and !value_exists(ray - 1, pos_vec)) {
                try pos_vec.append(allocator, ray - 1);
            }
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    var total: u32 = 0;
    var splits = std.mem.splitSequence(u8, data, "\n");
    const first_line = splits.next() orelse @panic("no first line");

    const allocator = std.heap.page_allocator;
    var pos_vec: std.ArrayList(usize) = .empty;
    defer pos_vec.deinit(allocator);

    for (0.., first_line) |i, val| {
        if (val == 'S') {
            try pos_vec.append(allocator, i);
        }
    }

    while (splits.next()) |line| {
        var changes: u32 = 0;

        for (0.., line) |i, val| {
            if (val == '^') {
                const change: bool = try check_rays(i, &pos_vec, allocator);
                if (change) changes += 1;
            }
        }
        total += changes;
    }
    std.debug.print("Result {}\n", .{total});
}
