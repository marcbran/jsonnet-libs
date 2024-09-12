# grafonnet-layout

Jsonnet library that adds simple layout functions to [grafonnet](https://github.com/grafana/grafonnet).

## Install

To add grafonnet-layout to a jsonnet project:

```console
jb install github.com/marcbran/jsonnet-libs/grafonnet-layout/gen@main
```

## Usage

```jsonnet
// dashboard.jsonnet
local grafonnet = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local layout = import 'github.com/marcbran/jsonnet-libs/grafonnet-layout/gen/main.libsonnet';

// Mixin the layout to add the layout functions to grafonnet
local g = grafonnet + layout.withLayout;

// Example panel
local random(title) = {
  title: title,
  type: 'timeseries',
};

// Using the new functions to create a 24-wide column with three 2-high panels
g.dashboard.new('My Dashboard')
+ g.dashboard.withColumn(24, [
  g.lt.panel(2, random('b')),
  g.lt.panel(2, random('c')),
  g.lt.panel(2, random('d')),
])
```

```console
jsonnet -J vendor dashboard.jsonnet
```

## Example

You can find more examples in the [test cases](./test/main.jsonnet) or the [integration tests](./it/main.jsonnet).
