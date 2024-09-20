# grafonnet-query

Jsonnet library that adds shortcuts to [grafonnet](https://github.com/grafana/grafonnet) for working with Jsonnet-based implementations of query languages.

Currently, it only works with [promql](../promql).

## Install

To add grafonnet-query to a jsonnet project:

```console
jb install github.com/marcbran/jsonnet-libs/grafonnet-query/gen/grafonnet-query@main
```

## Usage

```jsonnet
// dashboard.jsonnet
local grafonnet = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local query = import 'github.com/marcbran/jsonnet-libs/grafonnet-query/gen/grafonnet-query/main.libsonnet';
local promql = import 'github.com/marcbran/jsonnet-libs/promql/gen/promql/main.libsonnet';
// Metric code for prometheus needs to be created by prom2jsonnet
local prometheus = import './prometheus.libsonnet';

// Mixin the library to add the query functions to grafonnet
local g = grafonnet + query.withQuery;

// Use promql to write the query for a panel
local httpRequests = {
  panel: g.panel.timeSeries.new('test')
         + g.panel.timeSeries.queryOptions.withTargets([self.query]),
  query:
    g.query.prometheus.new(
      '$datasource',
      p.sum(
        p.rate(
          prometheus.http_requests_total {
            code: 200,
            handler: '/',
          },
          '$__rate_interval'
        ),
        by=['cluster', 'namespace', 'job']
      ),
    ),
};

// Use the panel in a dashboard
g.dashboard.new('Test Dashboard')
+ g.dashboard.withUid('test')
+ g.dashboard.withPanels([
  httpRequests.panel,
])
```

```console
jsonnet -J vendor dashboard.jsonnet
```

## Example

You can find an example in the [integration tests](./it/main.jsonnet).
