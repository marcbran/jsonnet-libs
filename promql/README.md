# promql

Jsonnet library that implements a DSL for [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/).

The goal is to be as close to PromQL as it is possible when writing correct Jsonnet code.

## Install

To add promql to a jsonnet project:

```console
jb install github.com/marcbran/jsonnet-libs/promql/gen/promql@main
```

## Usage

```jsonnet
// query.jsonnet
local p = import 'github.com/marcbran/jsonnet-libs/promql/gen/promql/main.libsonnet';

// Using the library you can write a PromQL query using jsonnet
// TODO raw metric expressions like 'prometheus.http_requests_total' will be provided by a different library
local query = p.sum(
  p.rate(prometheus.http_requests_total{ job: "apiserver", handler: "/api/comments" }, '5m'),
  by=['job']
);

// Fetches the string output
query.output

```

```shell
$ jsonnet -J vendor query.jsonnet

# sum by (job) (
#  rate(http_requests_total{job="apiserver", handler="/api/comments"}[5m])
# )
```

## Example

You can find more examples in the [test cases](./test/main.jsonnet).

## Todos

These things are still on the todo list:

- [ ] Integration with AlertManager
- [ ] More real world examples
- [ ] Parentheses support
