load("@bazel_skylib//lib:shell.bzl", "shell")
load("//:golink.bzl", "gen_copy_files_script")

def go_proto_link_impl(ctx, **kwargs):
    all_files = []
    for dep in ctx.attr.deps:
        if hasattr(dep[OutputGroupInfo], 'go_generated_srcs'):
            all_files = dep[OutputGroupInfo].go_generated_srcs.to_list()

        # Check for runfiles property and filter out directories
        if hasattr(dep[OutputGroupInfo], 'runfiles'):
            all_files = all_files + dep[OutputGroupInfo].runfiles.to_list()

        if hasattr(dep[OutputGroupInfo], 'types'):
            all_files = all_files + dep[OutputGroupInfo].types.to_list()

        # Fallback to _hidden_top_level_INTERNAL_ if available
        if hasattr(dep[OutputGroupInfo], '_hidden_top_level_INTERNAL_'):
            all_files = all_files + dep[OutputGroupInfo]._hidden_top_level_INTERNAL_.to_list()

    files = []
    for f in all_files:
        if not f.is_directory and not f.is_symlink and f not in files:
            files.append(f)

    return gen_copy_files_script(ctx, files)

_go_proto_link = rule(
    implementation = go_proto_link_impl,
    attrs = {
        "dir": attr.string(),
        "deps": attr.label_list(),
        "_template": attr.label(
            default = "//:copy_into_workspace.sh",
            allow_single_file = True,
        ),
        # It is not used, just used for versioning since this is experimental
        "version": attr.string(),
    },
)

def go_proto_link(name, **kwargs):
    if not "dir" in kwargs:
        dir = native.package_name()
        kwargs["dir"] = dir

    gen_rule_name = "%s_copy_gen" % name
    _go_proto_link(name = gen_rule_name, **kwargs)

    
    native.sh_binary(
        name = name,
        srcs = [":%s" % gen_rule_name]
    )
