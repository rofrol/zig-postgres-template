const std = @import("std");
const Pkg = std.build.Pkg;
const FileSource = std.build.FileSource;
const builtin = @import("builtin");

const pkg_postgres = Pkg{
    .name = "postgres",
    .source = FileSource{
        .path = "zig-postgres/src/postgres.zig",
    },
};

const include_dir = switch (builtin.target.os.tag) {
    .linux => "/usr/include",
    .windows => "C:\\Program Files\\PostgreSQL\\14\\include",
    .macos => "/opt/homebrew/opt/libpq",
    else => "/usr/include",
};

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    b.addSearchPrefix(include_dir);

    const db_uri = b.option(
        []const u8,
        "db",
        "Specify the database url",
    ) orelse "postgresql://postgresql:postgresql@localhost:5432/mydb";

    const db_options = b.addOptions();
    db_options.addOption([]const u8, "db_uri", db_uri);

    const exe = b.addExecutable("import-zig-tryout", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addOptions("build_options", db_options);
    exe.addPackage(pkg_postgres);
    exe.linkSystemLibrary("pq");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
