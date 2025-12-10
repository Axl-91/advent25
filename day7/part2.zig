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

fn count_timelines(line_vec: std.ArrayList([]const u8), pos_ray: usize, allocator: std.mem.Allocator) !u32 {
    var rays_vec: std.ArrayList(usize) = .empty;
    try rays_vec.append(allocator, pos_ray);
    defer rays_vec.deinit(allocator);

    var rays_vec_aux: std.ArrayList(usize) = .empty;
    defer rays_vec_aux.deinit(allocator);

    for (0.., line_vec.items) |i, line| {
        std.debug.print("I -> {}\n", .{i});
        if (line_vec.items.len - i == 3) {
            var total: u32 = 0;
            for (rays_vec.items) |ray| {
                if (line_vec.items[i][ray] == '^') total += 2 else total += 1;
            }
            return total;
        }

        for (rays_vec.items) |ray| {
            if (line[ray] == '^') {
                try rays_vec_aux.append(allocator, ray + 1);
                try rays_vec_aux.append(allocator, ray - 1);
            } else {
                try rays_vec_aux.append(allocator, ray);
            }
        }
        if (rays_vec_aux.items.len > 0) {
            rays_vec = .empty;
            try rays_vec.appendSlice(allocator, rays_vec_aux.items[0..]);
            rays_vec_aux = .empty;
        }
    }

    return 0;
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

    const timelines: u32 = try count_timelines(lines_vec, pos_ray, allocator);

    std.debug.print("Result {}\n", .{timelines});
}
