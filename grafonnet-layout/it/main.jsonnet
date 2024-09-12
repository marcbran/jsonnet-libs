local lt = import '../main.libsonnet';
local grafonnet = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local g = grafonnet + lt.withLayout;

local random(title) = {
  title: title,
  type: 'timeseries',
};

{
  override: true,
  dashboard:
    g.dashboard.new('Test Dashboard')
    + g.dashboard.withUid('test')
    + g.dashboard.withColumn(24, [
      g.panel.row.new('Test')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withColumn(5, [
        g.lt.row(6, [
          g.lt.panel(16, random('a')),
          g.lt.column(3, [
            g.lt.panel(2, random('b')),
            g.lt.panel(2, random('c')),
            g.lt.panel(2, random('d')),
          ]),
        ]),
      ]),
      g.panel.row.new('Test'),
      g.lt.row(6, [
        g.lt.space(1),
        g.lt.panel(16, random('a')),
        g.lt.column(3, [
          g.lt.panel(2, random('b')),
          g.lt.panel(2, random('c')),
          g.lt.panel(2, random('d')),
        ]),
        g.lt.panel(3, random('e')),
      ]),
    ]),
}
