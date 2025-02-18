const server = @import("./server.zig");

pub fn main() !void {
    var sv: server.Server = .{ .port = 8081 };
    try sv.start();
}