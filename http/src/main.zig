const Server = @import("./server.zig");

pub fn main() !void {
    var sv: Server = .{ .port = 8081 };
    try sv.start();
}