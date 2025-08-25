# Protolink

Protolink is a Bazel utility forked from https://github.com/tailscale/golink for linking protocol buffer (protobuf) generated source files into your project directory. This tool simplifies workflows by copying generated files for Go (via `rules_go` and `gazelle`), gRPC-Gateway Swagger files (via `grpc-gateway`), and TypeScript (via `rules_js`) into your source directory. This is particularly useful for ensuring IDEs can resolve imports for generated files, which are often inaccessible in Bazel's default output structure.

> **Note**: Protolink is a temporary workaround for IDE compatibility issues with Bazel-generated protobuf files. More robust solutions may emerge in the future.

## Features

- Copies generated protobuf files to your source directory.
- Supports Go, TypeScript, and gRPC-Gateway Swagger outputs.
- Improves IDE import resolution for Bazel projects.


## Installation

To use Protolink, add it as a dependency in your Bazel workspace.

### Step 1: Update `MODULE.bazel`

Add the following to your `MODULE.bazel` file to include Protolink as a dependency and override it with the specific commit from the forked repository:

```bazel
bazel_dep(name = "protolink", version = "2.0.0")
git_override(
    module_name = "protolink",
    commit = "LATEST_COMMIT",
    remote = "https://github.com/lucascarvalho/golink.git",
)
```

### Step 2: Sync Dependencies

Run the following command to sync your Bazel dependencies:

```bash
bazel mod deps
```

## Usage

To link generated protobuf files, add the `proto_link` rule to your `BUILD.bazel` file. The `deps` attribute must reference supported targets, which include:

- `ts_proto_library` (TypeScript protos)
- `go_proto_library` (Go protos)
- `gateway_openapiv2_compile` (gRPC-Gateway Swagger files)
- `gateway_grpc_compile` (gRPC-Gateway gRPC files)

### Example

In your `BUILD.bazel` file:

```bazel
load("@protolink//proto:proto.bzl", "proto_link")

proto_link(
    name = "api_proto_link",
    visibility = ["//visibility:public"],
    deps = [
        ":api_ts_proto",
        ":api_openapiv2",
        ":api_pb",
    ],
)
```

### Explanation of Attributes

- `name`: The name of the `proto_link` target (e.g., `api_proto_link`).
- `visibility`: Controls which packages can access the linked files (e.g., `["//visibility:public"]`).
- `deps`: A list of supported Bazel targets containing the generated protobuf files to link.

## Running Protolink

To execute the linking process, run:

```bash
bazel run //path/to:api_proto_link
```

This copies the generated files into your source directory, making them accessible to your IDE and other tools.
