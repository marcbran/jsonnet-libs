# jsonnet

Jsonnet library that renders other Jsonnet code.

## Install

To add the jsonnet generator lib to a jsonnet project:

```console
jb install github.com/marcbran/jsonnet-libs/jsonnet/gen/jsonnet@main
```

## Usage

```jsonnet
// gen.jsonnet
local j = import 'github.com/marcbran/jsonnet-libs/jsonnet/gen/jsonnet/main.libsonnet';

// Define code generation
local gen = j.Object([
  j.Local('a', j.Number(1)),
  j.Assert(j.Eq(j.Id('a'), j.Number(1)), j.String('a must be 1')),
  j.Field(j.String('b'), j.Id('a')),
]);

// Fetch the generated Jsonnet as a string
gen.output
```

```shell
$ jsonnet -J vendor gen.jsonnet

# "{local a = 1, assert a == 1: 'a must be 1', 'b': a}"
```

## Example

You can find more examples in the [test cases](./test/main.jsonnet).
