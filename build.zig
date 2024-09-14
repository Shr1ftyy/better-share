const std = @import("std");

fn root() []const u8 {
    return std.fs.path.dirname(@src().file) orelse unreachable;
}

const root_path = root() ++ "/";

fn runCMake(b: *std.Build) !void {
    const cmake_step = b.step("cmake", "Run CMake");

    const cmake_cmd = b.addSystemCommand(&[_][]const u8{
        "cmake",
        "-S", "libgit2", // Source directory
        "-B", "libgit2/build", // Build directory
        // "-DCMAKE_C_FLAGS=-I\\ " ++ root_path ++ "third-party/http-parser", "-DBUILD_SHARED_LIBS=0",
        // // TODO: womp womp ;(
        // // "-DLINK_WITH_STATIC_LIBRARIES=1",
        // "-DLIBGIT2_NO_FEATURES_H=1",                                       "-DGIT_IO_POLL=1",
        // "-DGIT_TRACE=1",                                                   "-DGIT_THREADS=0",
        // "-DGIT_USE_FUTIMENS=1", // "-DGIT_REGEX_PCRE=1",
        // "-DGIT_SSH=0",
        // "-DGIT_SSH_MEMORY_CREDENTIALS=1",
        // "-DGIT_HTTPS=1",
        // "-DGIT_MBEDTLS=0",
        // "-DGIT_SHA1_MBEDTLS=0",
        // "-DGIT_SHA256_MBEDTLS=0",
        // "-DGIT_HTTPPARSER_LLHTTP=1",
        // "-DGIT_HTTPPARSER_HTTPPARSER=1",
        // "-G", "Ninja", // Optional: Use Ninja generator
    });

    cmake_step.dependOn(&cmake_cmd.step);
}

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "better-share",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "better-share",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(b.path("libgit2/include"));

    try runCMake(b);

    // Optional: Add a build step that depends on CMake
    const make_step = b.step("build", "Build with cmake");
    const make_cmd = b.addSystemCommand(&[_][]const u8{
        "cmake",
        "--build",
        "libgit2/build",
    });
    make_step.dependOn(&make_cmd.step);

    exe.linkLibC();
    exe.addIncludePath(b.path("include/"));

    exe.addLibraryPath(b.path("libgit2/build"));

    exe.linkSystemLibrary("git2");
    // exe.addObjectFile(b.path("libgit2/build/libgit2.a"));

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
