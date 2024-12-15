local resolveExpr(value) =
  if std.type(value) == 'object'
  then
    if std.objectHas(value, '_') && std.type(value._) == 'object'
    then value._.expr
    else value.expr
  else value;

local withQuery = {
  dashboard+: {
    variable+: {
      query+: {
        queryTypes+: {
          withLabelValues(label, metric=''): super.withLabelValues(label, resolveExpr(metric)),
        },
      },
    },
  },
  query+: {
    prometheus+: {
      new(datasource, expr): super.new(datasource, resolveExpr(expr)),
      withExpr(value): super.withExpr(resolveExpr(value)),
    },
  },
};

{
  withQuery: withQuery,
}
