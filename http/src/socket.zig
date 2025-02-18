const net = @import("std").net;

pub fn createServerSocket(port: u16) !net.Server {
    const addr = try net.Address.parseIp4("127.0.0.1", port);
    return try addr.listen(.{});
}