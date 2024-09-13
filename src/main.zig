const std = @import("std");

const git2 = @cImport({
    @cInclude("git2.h");
});

const diff_print = @cImport({
    @cInclude("diff_print.h");
});

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const result = git2.git_libgit2_init();
    std.debug.print("libgit2 init: {d}\n", .{result});
    defer _ = git2.git_libgit2_shutdown();

    const path = ".";
    var repo: ?*git2.git_repository = undefined;
    const err = git2.git_repository_open(&repo, path);
    defer _ = git2.git_repository_free(repo);
    std.debug.print("repo: {any}\n", .{repo});
    std.debug.print("err: {d}\n", .{err});

    var diff: ?*git2.git_diff = undefined;
    const diffErr = git2.git_diff_index_to_workdir(&diff, repo, null, null);

    std.debug.print("err: {d}\n", .{diffErr});
    std.debug.print("diff: {any}\n", .{diff.?});

    var stats: ?*git2.git_diff_stats = undefined;
    const statsErr = git2.git_diff_get_stats(&stats, diff);
    std.debug.print("statsErr: {d}\n", .{statsErr});

    // load the stats into a buffer
    var buf = git2.git_buf{ .ptr = null, .reserved = 0, .size = 0 };

    const loadErr = git2.git_diff_stats_to_buf(&buf, stats, git2.GIT_DIFF_STATS_FULL | git2.GIT_DIFF_STATS_SHORT | git2.GIT_DIFF_STATS_NUMBER | git2.GIT_DIFF_STATS_INCLUDE_SUMMARY, 256);
    std.debug.print("statsErr: {d}\n", .{loadErr});

    // print the stats
    std.debug.print("diff summary ptr: {any}\n", .{buf.ptr});
    std.debug.print("diff summary reserved: {any}\n", .{buf.reserved});
    std.debug.print("diff summary size: {any}\n", .{buf.size});
    std.debug.print("diff summary:\n{s}\n", .{buf.ptr});
    // yo
    //
    // diff_git.diff_print_info_init_fromdiff

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
