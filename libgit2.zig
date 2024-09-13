const std = @import("std");

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse unreachable;
}

// const root_path = root() ++ "/";
const root_path = "";
// pub const include_dir = root_path ++ "libgit2/include";

pub fn create(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) !*std.Build.Step.Compile {
    const ret = b.addStaticLibrary(.{
        .name = "git2",
        .target = target,
        .optimize = optimize,
    });

    var flags = std.ArrayList([]const u8).init(b.allocator);
    defer flags.deinit();

    try flags.appendSlice(&.{
        "-DLIBGIT2_NO_FEATURES_H",
        "-DGIT_IO_POLL=1",
        "-DGIT_TRACE=1",
        "-DGIT_THREADS=0",
        "-DGIT_USE_FUTIMENS=1",
        "-DGIT_REGEX_PCRE",
        "-DGIT_SSH=0",
        "-DGIT_SSH_MEMORY_CREDENTIALS=1",
        "-DGIT_HTTPS=1",
        "-DGIT_MBEDTLS=1",
        "-DGIT_SHA1_MBEDTLS=1",
        "-DGIT_SHA256_MBEDTLS=1",
        "-DGIT_HTTPPARSER_LLHTTP=1",
        "-DGIT_HTTPPARSER_HTTPPARSER=1",
        "-fno-sanitize=all",
    });

    if (64 == target.result.ptrBitWidth())
        try flags.append("-DGIT_ARCH_64=1");

    ret.addCSourceFiles(.{ .files = srcs, .flags = flags.items });
    if (target.result.os.tag == .windows) {
        try flags.appendSlice(&.{
            "-DGIT_WIN32",
            "-DGIT_WINHTTP",
        });
        ret.addCSourceFiles(.{ .files = win32_srcs, .flags = flags.items });

        if (target.result.isGnu()) {
            ret.addCSourceFiles(.{ .files = posix_srcs, .flags = flags.items });
            ret.addCSourceFiles(.{ .files = unix_srcs, .flags = flags.items });
        }
    } else {
        ret.addCSourceFiles(.{ .files = posix_srcs, .flags = flags.items });
        ret.addCSourceFiles(.{ .files = unix_srcs, .flags = flags.items });
    }

    if (target.result.os.tag == .linux)
        try flags.appendSlice(&.{
            "-DGIT_USE_NSEC=1",
            "-DGIT_USE_STAT_MTIM=1",
        });

    ret.addCSourceFiles(.{ .files = pcre_srcs, .flags = &.{
        "-DLINK_SIZE=2",
        "-DNEWLINE=10",
        "-DPOSIX_MALLOC_THRESHOLD=10",
        "-DMATCH_LIMIT_RECURSION=MATCH_LIMIT",
        "-DPARENS_NEST_LIMIT=250",
        "-DMATCH_LIMIT=10000000",
        "-DMAX_NAME_SIZE=32",
        "-DMAX_NAME_COUNT=10000",
    } });

    // if (target.result.os.tag == .windows) {
    //     ret.addCSourceFiles(.{ .files = zlib_srcs, .flags = &.{
    //         "-DNO_VIZ",
    //         "-DSTDC",
    //         "-DNO_GZIP",
    //         "-DHAVE_SYS_TYPES_H",
    //         "-DHAVE_STDINT_H",
    //         "-DHAVE_STDDEF_H",
    //         "-DZ_HAVE_UNISTD_H",
    //         "-D_LFS64_LARGEFILE",
    //         "-D_LARGEFILE64_SOURCE=1",
    //     } });
    // } else {
    //     ret.addCSourceFiles(.{ .files = zlib_srcs, .flags = &.{
    //         "-DNO_VIZ",
    //         "-DSTDC",
    //         "-DNO_GZIP",
    //         "-DHAVE_SYS_TYPES_H",
    //         "-DHAVE_STDINT_H",
    //         "-DHAVE_STDDEF_H",
    //     } });
    // }
    //
    ret.addIncludePath(b.path("third-party/http-parser"));
    ret.addCSourceFile(.{ .file = b.path("third-party/http-parser/http_parser.c") });

    ret.addIncludePath(b.path("libgit2/include"));
    ret.addIncludePath(b.path("libgit2/src"));
    ret.addIncludePath(b.path("libgit2/deps/pcre"));
    // ret.addIncludePath(b.path("libgit2/deps/http-parser"));
    ret.addIncludePath(b.path("libgit2/include"));
    ret.addIncludePath(b.path("libgit2/src"));
    ret.addIncludePath(b.path("libgit2/src/util"));
    ret.addIncludePath(b.path("libgit2/src/util/transports"));
    ret.addIncludePath(b.path("libgit2/src/util/hash"));
    ret.addIncludePath(b.path("libgit2/src/libgit2"));
    ret.addIncludePath(b.path("libgit2/deps/pcre"));
    ret.addIncludePath(b.path("libgit2/deps/xdiff"));
    ret.addIncludePath(b.path("libgit2/deps/llhttp"));
    ret.addIncludePath(b.path("libgit2/deps/zlib"));

    // TODO: this works fine for brew users on macs - what about other platforms?
    if (target.result.os.tag == .macos) {
        ret.addIncludePath(.{ .cwd_relative = "/opt/homebrew/opt/mbedtls/include/" });
        ret.addLibraryPath(.{ .cwd_relative = "/opt/homebrew/opt/zlib/lib/" });
        ret.addLibraryPath(.{ .cwd_relative = "/opt/homebrew/opt/mbedtls/lib/" });
        ret.addLibraryPath(.{ .cwd_relative = "/opt/homebrew/Cellar/libssh2/1.11.0_1/lib/" });
    }

    ret.linkSystemLibrary("mbedtls");
    ret.linkSystemLibrary("mbedx509");
    ret.linkSystemLibrary("mbedcrypto");
    ret.linkSystemLibrary("z");
    ret.linkSystemLibrary("libssh2");
    // ret.linkSystemLibrary("http_parser");
    ret.linkLibC();

    return ret;
}

const srcs = &.{
    // root_path ++ "libgit2/deps/http-parser/http_parser.c",
    root_path ++ "libgit2/src/libgit2/transports/httpparser.c",
    root_path ++ "libgit2/src/libgit2/transports/httpclient.c",
    root_path ++ "libgit2/src/libgit2/transports/ssh_libssh2.c",
    root_path ++ "libgit2/src/util/allocators/failalloc.c",
    root_path ++ "libgit2/src/util/allocators/stdalloc.c",
    root_path ++ "libgit2/src/libgit2/streams/openssl.c",
    root_path ++ "libgit2/src/libgit2/streams/registry.c",
    root_path ++ "libgit2/src/libgit2/streams/socket.c",
    root_path ++ "libgit2/src/libgit2/streams/tls.c",
    // root_path ++ "mbedtls.c",
    root_path ++ "libgit2/src/libgit2/transports/ssh.c",
    root_path ++ "libgit2/src/libgit2/transports/ssh_exec.c",
    root_path ++ "libgit2/src/libgit2/transports/auth.c",
    root_path ++ "libgit2/src/libgit2/transports/credential.c",
    root_path ++ "libgit2/src/libgit2/transports/http.c",
    root_path ++ "libgit2/src/libgit2/transports/httpclient.c",
    root_path ++ "libgit2/src/libgit2/transports/smart_protocol.c",
    // root_path ++ "libgit2/src/libgit2/transports/ssh.c",
    root_path ++ "libgit2/src/libgit2/transports/git.c",
    root_path ++ "libgit2/src/libgit2/transports/smart.c",
    root_path ++ "libgit2/src/libgit2/transports/smart_pkt.c",
    root_path ++ "libgit2/src/libgit2/transports/local.c",
    root_path ++ "libgit2/deps/xdiff/xdiffi.c",
    root_path ++ "libgit2/deps/xdiff/xemit.c",
    root_path ++ "libgit2/deps/xdiff/xhistogram.c",
    root_path ++ "libgit2/deps/xdiff/xmerge.c",
    root_path ++ "libgit2/deps/xdiff/xpatience.c",
    root_path ++ "libgit2/deps/xdiff/xprepare.c",
    root_path ++ "libgit2/deps/xdiff/xutils.c",
    root_path ++ "libgit2/src/util/hash/mbedtls.c",
    root_path ++ "libgit2/src/util/rand.c",
    root_path ++ "libgit2/src/libgit2/streams/mbedtls.c",
    root_path ++ "libgit2/src/util/alloc.c",
    root_path ++ "libgit2/src/libgit2/annotated_commit.c",
    root_path ++ "libgit2/src/libgit2/apply.c",
    root_path ++ "libgit2/src/libgit2/attr.c",
    root_path ++ "libgit2/src/libgit2/attrcache.c",
    root_path ++ "libgit2/src/libgit2/attr_file.c",
    root_path ++ "libgit2/src/libgit2/blame.c",
    root_path ++ "libgit2/src/libgit2/blame_git.c",
    root_path ++ "libgit2/src/libgit2/blob.c",
    root_path ++ "libgit2/src/libgit2/branch.c",
    // root_path ++ "libgit2/src/libgit2/buffer.c",
    root_path ++ "libgit2/src/libgit2/cache.c",
    root_path ++ "libgit2/src/libgit2/checkout.c",
    root_path ++ "libgit2/src/libgit2/cherrypick.c",
    root_path ++ "libgit2/src/libgit2/clone.c",
    root_path ++ "libgit2/src/libgit2/commit.c",
    root_path ++ "libgit2/src/libgit2/commit_graph.c",
    root_path ++ "libgit2/src/libgit2/commit_list.c",
    root_path ++ "libgit2/src/util/fs_path.c",
    root_path ++ "libgit2/src/util/str.c",
    root_path ++ "libgit2/src/libgit2/settings.c",
    root_path ++ "libgit2/src/libgit2/config.c",
    root_path ++ "libgit2/src/libgit2/config_cache.c",
    // root_path ++ "libgit2/src/libgit2/config_entries.c",
    root_path ++ "libgit2/src/libgit2/config_list.c",
    root_path ++ "libgit2/src/libgit2/config_file.c",
    root_path ++ "libgit2/src/libgit2/config_mem.c",
    root_path ++ "libgit2/src/libgit2/config_parse.c",
    root_path ++ "libgit2/src/libgit2/config_snapshot.c",
    root_path ++ "libgit2/src/libgit2/crlf.c",
    root_path ++ "libgit2/src/util/date.c",
    root_path ++ "libgit2/src/libgit2/delta.c",
    root_path ++ "libgit2/src/libgit2/describe.c",
    root_path ++ "libgit2/src/libgit2/diff.c",
    root_path ++ "libgit2/src/libgit2/diff_driver.c",
    root_path ++ "libgit2/src/libgit2/diff_file.c",
    root_path ++ "libgit2/src/libgit2/diff_generate.c",
    root_path ++ "libgit2/src/libgit2/diff_parse.c",
    root_path ++ "libgit2/src/libgit2/diff_print.c",
    root_path ++ "libgit2/src/libgit2/diff_stats.c",
    root_path ++ "libgit2/src/libgit2/diff_tform.c",
    root_path ++ "libgit2/src/libgit2/diff_xdiff.c",
    root_path ++ "libgit2/src/util/errors.c",
    root_path ++ "libgit2/src/libgit2/email.c",
    root_path ++ "libgit2/src/libgit2/fetch.c",
    root_path ++ "libgit2/src/libgit2/fetchhead.c",
    root_path ++ "libgit2/src/libgit2/buf.c",
    root_path ++ "libgit2/src/util/filebuf.c",
    root_path ++ "libgit2/src/libgit2/filter.c",
    root_path ++ "libgit2/src/util/futils.c",
    root_path ++ "libgit2/src/libgit2/graph.c",
    root_path ++ "libgit2/src/util/hash.c",
    root_path ++ "libgit2/src/libgit2/hashsig.c",
    root_path ++ "libgit2/src/libgit2/ident.c",
    root_path ++ "libgit2/src/libgit2/idxmap.c",
    root_path ++ "libgit2/src/libgit2/ignore.c",
    root_path ++ "libgit2/src/libgit2/index.c",
    root_path ++ "libgit2/src/libgit2/indexer.c",
    root_path ++ "libgit2/src/libgit2/iterator.c",
    root_path ++ "libgit2/src/libgit2/libgit2.c",
    root_path ++ "libgit2/src/libgit2/mailmap.c",
    root_path ++ "libgit2/src/libgit2/merge.c",
    root_path ++ "libgit2/src/libgit2/merge_driver.c",
    root_path ++ "libgit2/src/libgit2/merge_file.c",
    root_path ++ "libgit2/src/libgit2/message.c",
    root_path ++ "libgit2/src/libgit2/midx.c",
    root_path ++ "libgit2/src/libgit2/mwindow.c",
    root_path ++ "libgit2/src/util/net.c",
    // root_path ++ "libgit2/src/libgit2/netops.c",
    root_path ++ "libgit2/src/libgit2/notes.c",
    root_path ++ "libgit2/src/libgit2/grafts.c",
    root_path ++ "libgit2/src/util/utf8.c",
    root_path ++ "libgit2/src/libgit2/object_api.c",
    root_path ++ "libgit2/src/libgit2/object.c",
    root_path ++ "libgit2/src/libgit2/odb.c",
    root_path ++ "libgit2/src/libgit2/odb_loose.c",
    root_path ++ "libgit2/src/libgit2/odb_mempack.c",
    root_path ++ "libgit2/src/libgit2/odb_pack.c",
    root_path ++ "libgit2/src/libgit2/offmap.c",
    root_path ++ "libgit2/src/libgit2/oidarray.c",
    root_path ++ "libgit2/src/libgit2/oid.c",
    root_path ++ "libgit2/src/libgit2/oidmap.c",
    root_path ++ "libgit2/src/libgit2/pack.c",
    root_path ++ "libgit2/src/libgit2/pack-objects.c",
    root_path ++ "libgit2/src/libgit2/parse.c",
    root_path ++ "libgit2/src/libgit2/patch.c",
    root_path ++ "libgit2/src/libgit2/patch_generate.c",
    root_path ++ "libgit2/src/libgit2/patch_parse.c",
    root_path ++ "libgit2/src/libgit2/path.c",
    root_path ++ "libgit2/src/libgit2/pathspec.c",
    root_path ++ "libgit2/src/util/pool.c",
    root_path ++ "libgit2/src/util/pqueue.c",
    root_path ++ "libgit2/src/libgit2/proxy.c",
    root_path ++ "libgit2/src/libgit2/push.c",
    root_path ++ "libgit2/src/libgit2/reader.c",
    root_path ++ "libgit2/src/libgit2/rebase.c",
    root_path ++ "libgit2/src/libgit2/refdb.c",
    root_path ++ "libgit2/src/libgit2/refdb_fs.c",
    root_path ++ "libgit2/src/libgit2/reflog.c",
    root_path ++ "libgit2/src/libgit2/refs.c",
    root_path ++ "libgit2/src/libgit2/refspec.c",
    root_path ++ "libgit2/src/util/regexp.c",
    root_path ++ "libgit2/src/libgit2/remote.c",
    root_path ++ "libgit2/src/libgit2/repository.c",
    root_path ++ "libgit2/src/libgit2/reset.c",
    root_path ++ "libgit2/src/libgit2/revert.c",
    root_path ++ "libgit2/src/libgit2/revparse.c",
    root_path ++ "libgit2/src/libgit2/revwalk.c",
    root_path ++ "libgit2/src/util/runtime.c",
    root_path ++ "libgit2/src/libgit2/signature.c",
    root_path ++ "libgit2/src/util/sortedcache.c",
    root_path ++ "libgit2/src/libgit2/stash.c",
    root_path ++ "libgit2/src/libgit2/status.c",
    root_path ++ "libgit2/src/libgit2/strarray.c",
    root_path ++ "libgit2/src/util/strmap.c",
    root_path ++ "libgit2/src/libgit2/submodule.c",
    root_path ++ "libgit2/src/libgit2/sysdir.c",
    root_path ++ "libgit2/src/libgit2/tag.c",
    root_path ++ "libgit2/src/util/thread.c",
    // root_path ++ "libgit2/src/libgit2/threadstate.c",
    root_path ++ "libgit2/src/libgit2/trace.c",
    root_path ++ "libgit2/src/libgit2/trailer.c",
    root_path ++ "libgit2/src/libgit2/transaction.c",
    root_path ++ "libgit2/src/libgit2/transport.c",
    root_path ++ "libgit2/src/libgit2/tree.c",
    root_path ++ "libgit2/src/libgit2/tree-cache.c",
    root_path ++ "libgit2/src/util/tsort.c",
    // root_path ++ "libgit2/src/libgit2/utf8.c",
    root_path ++ "libgit2/src/util/util.c",
    root_path ++ "libgit2/src/util/varint.c",
    root_path ++ "libgit2/src/util/vector.c",
    root_path ++ "libgit2/src/util/wildmatch.c",
    root_path ++ "libgit2/src/libgit2/worktree.c",
    root_path ++ "libgit2/src/util/zstream.c",
};

const pcre_srcs = &.{
    root_path ++ "libgit2/deps/pcre/pcre_byte_order.c",
    root_path ++ "libgit2/deps/pcre/pcre_chartables.c",
    root_path ++ "libgit2/deps/pcre/pcre_compile.c",
    root_path ++ "libgit2/deps/pcre/pcre_config.c",
    root_path ++ "libgit2/deps/pcre/pcre_dfa_exec.c",
    root_path ++ "libgit2/deps/pcre/pcre_exec.c",
    root_path ++ "libgit2/deps/pcre/pcre_fullinfo.c",
    root_path ++ "libgit2/deps/pcre/pcre_get.c",
    root_path ++ "libgit2/deps/pcre/pcre_globals.c",
    root_path ++ "libgit2/deps/pcre/pcre_jit_compile.c",
    root_path ++ "libgit2/deps/pcre/pcre_maketables.c",
    root_path ++ "libgit2/deps/pcre/pcre_newline.c",
    root_path ++ "libgit2/deps/pcre/pcre_ord2utf8.c",
    root_path ++ "libgit2/deps/pcre/pcreposix.c",
    root_path ++ "libgit2/deps/pcre/pcre_printint.c",
    root_path ++ "libgit2/deps/pcre/pcre_refcount.c",
    root_path ++ "libgit2/deps/pcre/pcre_string_utils.c",
    root_path ++ "libgit2/deps/pcre/pcre_study.c",
    root_path ++ "libgit2/deps/pcre/pcre_tables.c",
    root_path ++ "libgit2/deps/pcre/pcre_ucd.c",
    root_path ++ "libgit2/deps/pcre/pcre_valid_utf8.c",
    root_path ++ "libgit2/deps/pcre/pcre_version.c",
    root_path ++ "libgit2/deps/pcre/pcre_xclass.c",
};

const zlib_srcs = &.{
    root_path ++ "libgit2/deps/zlib/adler32.c",
    root_path ++ "libgit2/deps/zlib/crc32.c",
    root_path ++ "libgit2/deps/zlib/deflate.c",
    root_path ++ "libgit2/deps/zlib/infback.c",
    root_path ++ "libgit2/deps/zlib/inffast.c",
    root_path ++ "libgit2/deps/zlib/inflate.c",
    root_path ++ "libgit2/deps/zlib/inftrees.c",
    root_path ++ "libgit2/deps/zlib/trees.c",
    root_path ++ "libgit2/deps/zlib/zutil.c",
};

const posix_srcs = &.{
    root_path ++ "libgit2/src/util/posix.c",
};

const unix_srcs = &.{
    root_path ++ "libgit2/src/util/unix/map.c",
    root_path ++ "libgit2/src/util/unix/realpath.c",
};

const win32_srcs = &.{
    root_path ++ "libgit2/src/util/win32/dir.c",
    root_path ++ "libgit2/src/util/win32/error.c",
    // root_path ++ "libgit2/src/win32/findfile.c",
    root_path ++ "libgit2/src/util/win32/map.c",
    root_path ++ "libgit2/src/util/win32/path_w32.c",
    root_path ++ "libgit2/src/util/win32/posix_w32.c",
    root_path ++ "libgit2/src/util/win32/precompiled.c",
    root_path ++ "libgit2/src/util/win32/thread.c",
    root_path ++ "libgit2/src/util/win32/utf-conv.c",
    root_path ++ "libgit2/src/util/win32/w32_buffer.c",
    root_path ++ "libgit2/src/util/win32/w32_leakcheck.c",
    root_path ++ "libgit2/src/util/win32/w32_util.c",
};
