local p = import '../../promql/gen/promql/main.libsonnet';
local q = import '../main.libsonnet';
local prometheus = import './prometheus.libsonnet';
local grafonnet = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local g = grafonnet + q.withQuery;

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

{
  override: true,
  dashboard:
    g.dashboard.new('Test Dashboard')
    + g.dashboard.withUid('test')
    + g.dashboard.withPanels([
      httpRequests.panel,
    ]),
}
