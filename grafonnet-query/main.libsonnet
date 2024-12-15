local withQuery = {
  dashboard+: {
    variable+: {
      query+: {
        queryTypes+: {
          withLabelValues(label, metric=''):
            if std.type(metric) == 'object'
            then super.withLabelValues(label, metric._.expr)
            else super.withLabelValues(label, metric),
        },
      },
    },
  },
  query+: {
    prometheus+: {
      new(datasource, expr):
        if std.type(expr) == 'object'
        then super.new(datasource, expr._.expr)
        else super.new(datasource, expr),
      withExpr(value):
        if std.type(value) == 'object'
        then super.withExpr(value._.expr)
        else super.withExpr(value),
    },
  },
};

{
  withQuery: withQuery,
}
