# protolink

Bazel hack for linking proto generated srcs.

You can use it for copying over golang generated proto files (rules_go & gazelle), grpc-gateway swagger files (grpc-gateway), typescript (rules_js) generated proto files into your source directory.
This is important if you want to make your IDE work because in many cases the IDE can't resolve the imports to generated files under bazel structure.

Note that this is a hack and there will be more ideal solutions in the future. Unfortunately no solution exists for the problem stated above just yet.

# Installation

Follow these instructions strictly.

## Add this to your `MODULE.bazel`

```bazel
bazel_dep(name = "golink", version = "2.0.0")
bazel_dep(name = "bazel_skylib", version = "1.7.1")

```
