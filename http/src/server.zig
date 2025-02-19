const socklib = @import("./socket.zig");
const std = @import("std");
const net = std.net;
const functions = @import("./serverfunctions.zig");

const Server = @This();

socket: ?net.Server = null,
port: u16 = 80,
loopFn: functions.ServerLoopFn = functions.defaultServerLoopFn,
handleConnectionFn: functions.ServerHandleConnectionFn = functions.defaultServerHandleConnectionFn,

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
