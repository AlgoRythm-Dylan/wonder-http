const socklib = @import("./socket.zig");
const std = @import("std");
const net = std.net;
const functions = @import("./serverfunctions.zig");

const Self = @This();

socket: ?net.Server = null,
port: u16 = 80,
loopFn: functions.ServerLoopFn = functions.defaultServerLoopFn,
handleConnectionFn: functions.ServerHandleConnectionFn = functions.defaultServerHandleConnectionFn,
createMessageAllocatorFn: functions.ServerCreateMessageAllocatorFn = functions.defaultServerCreateMessageAllocatorFn,

pub fn start(self: *Self) !void {
    self.socket = try socklib.createServerSocket(self.port);
    try self.loop();
}

pub fn loop(self: *Self) !void {
    try self.loopFn(self);
}

pub fn handleConnection(self: *Self, connection: *net.Server.Connection) !void {
    try self.handleConnectionFn(self, connection);
}
