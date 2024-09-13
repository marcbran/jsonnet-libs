local printNewlines(newlines) = std.join('', std.map(function(index) '\\n', std.range(1, newlines)));

local joinExpr(sep, exprs) = std.join(sep, [expr.output for expr in exprs]);

{
  Null: {
    output: 'null',
  },
  True: {
    output: 'true',
  },
  False: {
    output: 'false',
  },
  Self: {
    output: 'self',
  },
  Outer: {
    output: '$',
  },
  Super: {
    output: 'super',
  },
  String(val, format=[]): {
    output:
      if std.length(format) == 0
      then "'%s'" % [val]
      else "'%s' %% [%s]" % [val, joinExpr(', ', format)],
  },
  Number(val, format='%d'): {
    output: format % [val],
  },
  Id(id): {
    output: '%s' % [id],
  },
  Member(expr, id): {
    output: '%s.%s' % [expr.output, id],
  },
  Index(expr, index): {
    output: '%s[%s]' % [expr.output, index.output],
  },
  Func(params, expr): {
    output: 'function(%s) %s' % [joinExpr(', ', params), expr.output],
  },
  DefaultParam(id, expr): {
    output: '%s=%s' % [id, expr.output],
  },
  Call(expr, params): {
    output: '%s(%s)' % [expr.output, joinExpr(', ', params)],
  },
  NamedParam(id, expr): {
    output: '%s=%s' % [id, expr.output],
  },
  Object(members, newlines=0): {
    output: '{%s%s}' % [printNewlines(newlines), joinExpr(', ', members)],
  },
  Field(name, expr, override='', hidden=':'): {
    output: '%s%s%s %s' % [name.output, override, hidden, expr.output],
  },
  FieldFunc(name, params, expr, hidden=':'): {
    output: '%s(%s)%s %s' % [name.output, joinExpr(', ', params), hidden, expr.output],
  },
  FieldNameExpr(expr): {
    output: '[%s]' % [expr.output],
  },
  ObjectComp(exprs): {
    local objectCompExprs = exprs,
    local forSpec(id, expr) = {
      output: 'for %s in %s' % [id, expr.output],
    },
    local ifSpec(expr) = {
      output: 'if %s' % [expr.output],
    },
    local compspec(comps) = {
      output: '{%s %s}' % [joinExpr(', ', objectCompExprs), joinExpr(' ', comps)],
      For(id, expr): compspec(comps + [forSpec(id, expr)]),
      If(expr): compspec(comps + [ifSpec(expr)]),
    },
    For(id, expr): compspec([forSpec(id, expr)]),
  },
  KeyValue(key, value): {
    output: '[%s]: %s' % [key.output, value.output],
  },
  Array(exprs, newlines=0): {
    output: '[%s%s]' % [printNewlines(newlines), std.join(
      ' ',
      std.mapWithIndex(
        function(i, expr)
          if (i < std.length(exprs) - 1)
          then '%s%s' % [expr.output, std.get(expr, 'sep', ',')]
          else expr.output,
        exprs
      )
    )],
  },
  ArrayComp(expr): {
    local arrayCompExpr = expr,
    local forSpec(id, expr) = {
      output: 'for %s in %s' % [id, expr.output],
    },
    local ifSpec(expr) = {
      output: 'if %s' % [expr.output],
    },
    local compspec(comps) = {
      output: '[%s %s]' % [arrayCompExpr.output, joinExpr(' ', comps)],
      For(id, expr): compspec(comps + [forSpec(id, expr)]),
      If(expr): compspec(comps + [ifSpec(expr)]),
    },
    For(id, expr): compspec([forSpec(id, expr)]),
  },
  Local(id, expr): {
    output: 'local %s = %s' % [id, expr.output],
    sep: ';',
  },
  LocalFunc(id, params, expr): {
    output: 'local %s(%s) = %s' % [id, joinExpr(', ', params), expr.output],
    sep: ';',
  },
  If(expr): {
    local ifExpr = expr,
    Then(expr): {
      local thenExpr = expr,
      output: 'if %s then %s' % [ifExpr.output, expr.output],
      Else(expr): {
        output: 'if %s then %s else %s' % [ifExpr.output, thenExpr.output, expr.output],
      },
    },
  },
  Error(expr): {
    output: 'error %s' % [expr.output],
  },
  Assert(expr, msg): {
    output: 'assert %s: %s' % [expr.output, msg.output],
  },
  SuperCheck(expr): {
    output: '%s in super' % [expr.output],
  },
  Import(string): {
    output: "import '%s'" % [string],
  },
  ImportStr(string): {
    output: "importstr '%s'" % [string],
  },
  ImportBin(string): {
    output: "importbin '%s'" % [string],
  },
  Exprs(exprs, newlines=0): {
    local sep = if newlines == 0 then '' else ['\n' for _ in std.range(1, newlines)],
    output: joinExpr(';%s' % sep, exprs),
  },
  BinaryOp(a, op, b): {
    output: '%s %s %s' % [a.output, op, b.output],
  },
  Mul(a, b): self.BinaryOp(a, '*', b),
  Div(a, b): self.BinaryOp(a, '/', b),
  Mod(a, b): self.BinaryOp(a, '%', b),
  Add(a, b): self.BinaryOp(a, '+', b),
  Sub(a, b): self.BinaryOp(a, '-', b),
  LShift(a, b): self.BinaryOp(a, '<<', b),
  RShift(a, b): self.BinaryOp(a, '>>', b),
  Lt(a, b): self.BinaryOp(a, '<', b),
  Lte(a, b): self.BinaryOp(a, '<=', b),
  Gt(a, b): self.BinaryOp(a, '>', b),
  Gte(a, b): self.BinaryOp(a, '>=', b),
  Eq(a, b): self.BinaryOp(a, '==', b),
  Neq(a, b): self.BinaryOp(a, '!=', b),
  In(a, b): self.BinaryOp(a, 'in', b),
  BitAnd(a, b): self.BinaryOp(a, '&', b),
  BitXor(a, b): self.BinaryOp(a, '^', b),
  BitOr(a, b): self.BinaryOp(a, '|', b),
  LogicalAnd(a, b): self.BinaryOp(a, '&&', b),
  LogicalOr(a, b): self.BinaryOp(a, '||', b),
  UnaryOp(a, op): {
    output: '%s%s' % [op, a.output],
  },
  Neg(a): self.UnaryOp(a, '-'),
  Pos(a): self.UnaryOp(a, '+'),
  Not(a): self.UnaryOp(a, '!'),
  BitNot(a): self.UnaryOp(a, '~'),
}
