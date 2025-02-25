const Server = @import("./server.zig");
const std = @import("std");
const net = std.net;

pub const ServerLoopFn = *const fn(*Server) anyerror!void;
pub fn defaultServerLoopFn(server: *Server) anyerror!void {
    while(server.socket) |*s| {
        var connection = try s.accept();
        try server.handleConnection(&connection);
    }
}

pub const ServerHandleConnectionFn = *const fn(*Server, *net.Server.Connection) anyerror!void;
pub fn defaultServerHandleConnectionFn(server: *Server, connection: *net.Server.Connection) anyerror!void {
    _ = server;
    var buf: [1024]u8 = undefined;
    var is_more_data = true;
    while(is_more_data){
        const count_read = try connection.stream.read(&buf);
        is_more_data = count_read >= buf.len;
        std.debug.print("{s}", .{ buf[0..count_read] });
    }
    _ = try connection.stream.write("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello world!");
    std.debug.print("\n\nClosing stream\n", .{});
    connection.stream.close();
}

pub const ServerCreateMessageAllocatorFn = *const fn(*Server) anyerror!std.mem.Allocator;
pub fn defaultServerCreateMessageAllocatorFn(server: *Server) anyerror!std.mem.Allocator {
    _ = server;
}