const std = @import("std.zig");
const tokenizer = @import("zig/tokenizer.zig");

pub const Token = tokenizer.Token;
pub const Tokenizer = tokenizer.Tokenizer;
pub const parse = @import("zig/parse.zig").parse;
pub const parseStringLiteral = @import("zig/string_literal.zig").parse;
pub const render = @import("zig/render.zig").render;
pub const renderStringLiteral = @import("zig/string_literal.zig").render;
pub const ast = @import("zig/ast.zig");
pub const system = @import("zig/system.zig");
pub const CrossTarget = @import("zig/cross_target.zig").CrossTarget;

pub const SrcHash = [16]u8;

/// If the source is small enough, it is used directly as the hash.
/// If it is long, blake3 hash is computed.
pub fn hashSrc(src: []const u8) SrcHash {
    var out: SrcHash = undefined;
    if (src.len <= SrcHash.len) {
        std.mem.copy(u8, &out, src);
        std.mem.set(u8, out[src.len..], 0);
    } else {
        std.crypto.Blake3.hash(src, &out);
    }
    return out;
}

pub fn findLineColumn(source: []const u8, byte_offset: usize) struct { line: usize, column: usize } {
    var line: usize = 0;
    var column: usize = 0;
    for (source[0..byte_offset]) |byte| {
        switch (byte) {
            '\n' => {
                line += 1;
                column = 0;
            },
            else => {
                column += 1;
            },
        }
    }
    return .{ .line = line, .column = column };
}

test "" {
    @import("std").meta.refAllDecls(@This());
}
