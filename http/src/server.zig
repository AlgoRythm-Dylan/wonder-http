const socklib = @import("./socket.zig");
const net = @import("std").net;

pub const Server = struct {
    socket: net.Server,
};

pub fn start(port: u16) !Server {
    return Server {
        .socket = socklib.createServerSocket(port)
    };
}
