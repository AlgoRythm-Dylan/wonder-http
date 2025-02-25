const std = @import("std");
const http = std.http;

pub const HeaderCollection = std.AutoHashMap(u8, std.ArrayList(u8));

const Self = @This();

method: http.Method = http.Method.GET, // Use GET as default verb
path: ?[]u8 = null,
headers: ?HeaderCollection = null,
allocator: std.mem.Allocator = undefined,

pub fn init(alloc: std.mem.Allocator) Self {
    return .{
        .headers = HeaderCollection.init(alloc),
        .allocator = alloc
    };
}