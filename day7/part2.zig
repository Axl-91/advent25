const std = @import("std");
const data = @embedFile("input");

fn count_timelines(line_vec: *std.ArrayList([]const u8), pos_ray: usize, allocator: std.mem.Allocator) !u128 {
    var total: u128 = 0;

    var rays = std.AutoHashMap(usize, u128).init(allocator);
    defer rays.deinit();
    try rays.put(pos_ray, 1);

    for (0..line_vec.items.len - 1) |i| {
        if (line_vec.items.len - i == 2) {
            var rays_it = rays.iterator();
            while (rays_it.next()) |entry| {
                if (entry.value_ptr.* != 0) {
                    total += entry.value_ptr.*;
                }
            }
            break;
        }
        var rays_it = rays.iterator();
        while (rays_it.next()) |entry| {
            const ray = entry.key_ptr.*;
            const repetitions = entry.value_ptr.*;
            if (line_vec.items[i][ray] == '^') {
                if (rays.getPtr(ray + 1)) |ptr| {
                    ptr.* += repetitions;
                } else {
                    try rays.put(ray + 1, repetitions);
                }

                if (rays.getPtr(ray - 1)) |ptr| {
                    ptr.* += repetitions;
                } else {
                    try rays.put(ray - 1, repetitions);
                }

                try rays.put(ray, 0);
            }
        }
    }
    return total;
}

pub fn main() !void {
    var splits = std.mem.splitSequence(u8, data, "\n");
    const first_line = splits.next() orelse @panic("no first line");

    const allocator = std.heap.page_allocator;
    var pos_ray: usize = 0;
    var lines_vec: std.ArrayList([]const u8) = .empty;
    defer lines_vec.deinit(allocator);

    for (0.., first_line) |i, val| {
        if (val == 'S') {
            pos_ray = i;
        }
    }

    while (splits.next()) |line| {
        try lines_vec.append(allocator, line);
    }

    const timelines: u128 = try count_timelines(&lines_vec, pos_ray, allocator);

    std.debug.print("Result {}\n", .{timelines});
}
