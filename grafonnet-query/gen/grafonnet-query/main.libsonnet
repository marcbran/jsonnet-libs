local withQuery = {
  query+: {
    prometheus+: {
      new(datasource, expr):
        if std.type(expr) == 'object'
        then super.new(datasource, expr.expr)
        else super.new(datasource, expr),
      withExpr(value):
        if std.type(value) == 'object'
        then super.withExpr(value.expr)
        else super.withExpr(value),
    },
  },
};

{
  withQuery: withQuery,
}
