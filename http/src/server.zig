const socklib = @import("./socket.zig");
const std = @import("std");
const net = std.net;

pub const ServerLoopFn = *const fn(*Server) anyerror!void;
fn defaultServerLoopFn(server: *Server) anyerror!void {
    while(server.socket) |*s| {
        var connection = try s.accept();
        try server.handleConnection(&connection);
    }
}

pub const ServerHandleConnectionFn = *const fn(*Server, *net.Server.Connection) anyerror!void;
fn defaultServerHandleConnectionFn(server: *Server, connection: *net.Server.Connection) anyerror!void {
    _ = server;
    var buf: [1024]u8 = undefined;
    var is_more_data = true;
    while(is_more_data){
        const count_read = try connection.stream.read(&buf);
        is_more_data = count_read >= buf.len;
        std.debug.print("{s}", .{ buf[0..count_read] });
    }
    std.debug.print("\n\nClosing stream\n", .{});
    connection.stream.close();
}

pub const Server = struct {
    socket: ?net.Server = null,
    port: u16 = 80,
    loopFn: ServerLoopFn = defaultServerLoopFn,
    handleConnectionFn: ServerHandleConnectionFn = defaultServerHandleConnectionFn,

    pub fn start(self: *Server) !void {
        self.socket = try socklib.createServerSocket(self.port);
        try self.loop();
    }

    pub fn loop(self: *Server) !void {
        try self.loopFn(self);
    }

    pub fn handleConnection(self: *Server, connection: *net.Server.Connection) !void {
        try self.handleConnectionFn(self, connection);
    }

};