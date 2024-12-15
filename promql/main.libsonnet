local matcher(value, operator) = {
  expr(field): '%s%s"%s"' % [field, operator, value],
};

local matchers = {
  eq(value): matcher(value, '='),
  not(value): matcher(value, '!='),
  regex(value): matcher(value, '=~'),
  regexNot(value): matcher(value, '!~'),
};

local resolveExpr(value) =
  if std.type(value) == 'object' then value._.expr
  else if std.type(value) == 'array' then [resolveExpr(element) for element in value]
  else std.manifestJson(value);

local rangeSelector(vector, range) = {
  _: {
    kind: 'rangeSelector',
    vector: vector,
    match(matchers): $ {
      _+: {
        vector: super.vector._.match(matchers),
      },
    },
    expr: '%s[%s]' % [resolveExpr(self.vector), range],
  },
};

local subquery(vector, range, resolution=null) =
  local rangeString = if resolution == null then range else '%s:%s' % [range, resolution];
  rangeSelector(vector, rangeString);

local modifier(vector, operator, modification) = {
  _: {
    kind: 'modifier',
    vector: vector,
    match(matchers): $ {
      _+: {
        vector: super.vector._.match(matchers),
      },
    },
    expr: '%s %s %s' % [resolveExpr(self.vector), operator, modification],
  },
};

local offsetModifier(vector, offset) = modifier(vector, 'offset', offset);

local atModifier(vector, time) = modifier(vector, '@', time);

local selectors = {
  range: rangeSelector,
  subquery: subquery,
  offset: offsetModifier,
  at: atModifier,
};

local resolveOperand(value) =
  if std.type(value) == 'object' && std.objectHas(value, '_') && std.objectHas(value._, 'kind') && value._.kind == 'operator'
  then '(%s)' % value._.expr
  else resolveExpr(value);

local operator(left, operator, right, by, ignoring, group_left, group_right) = {
  _: {
    kind: 'operator',
    left: left,
    operator: operator,
    right: right,
    by: by,
    ignoring: ignoring,
    group_left: group_left,
    group_right: group_right,
    match(matchers): $ {
      _+: {
        left: super.left._.match(matchers),
        right: super.right._.match(matchers),
      },
    },
    expr:
      local leftString = resolveOperand(self.left);
      local byString = if (std.length(self.by) > 0) then 'by(%s)' % std.join(', ', self.by) else '';
      local ignoringString = if (std.length(self.ignoring) > 0) then 'ignoring(%s)' % std.join(', ', self.ignoring) else '';
      local groupLeftString = if (std.length(self.group_left) > 0) then 'group_left(%s)' % std.join(', ', self.group_left) else '';
      local groupRightString = if (std.length(self.group_right) > 0) then 'group_right(%s)' % std.join(', ', self.group_right) else '';
      local rightString = resolveOperand(self.right);
      local parts = [leftString, operator, byString, ignoringString, groupLeftString, groupRightString, rightString];
      std.join(' ', [part for part in parts if part != '']),
  },
};

local arithmeticOperators = {
  add(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '+', right, by, ignoring, group_left, group_right),
  sub(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '-', right, by, ignoring, group_left, group_right),
  mul(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '*', right, by, ignoring, group_left, group_right),
  div(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '/', right, by, ignoring, group_left, group_right),
  mod(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '%', right, by, ignoring, group_left, group_right),
  pow(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '^', right, by, ignoring, group_left, group_right),
};

local comparisonOperators = {
  equal(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '==', right, by, ignoring, group_left, group_right),
  notEqual(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '!=', right, by, ignoring, group_left, group_right),
  greaterThan(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '>', right, by, ignoring, group_left, group_right),
  lessThan(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '<', right, by, ignoring, group_left, group_right),
  greaterOrEqual(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '>=', right, by, ignoring, group_left, group_right),
  lessOrEqual(left, right, by=[], ignoring=[], group_left=[], group_right=[]):
    operator(left, '<=', right, by, ignoring, group_left, group_right),
};

local aggregationOperator(operator, parameter, expression, by, without) = {
  _: {
    kind: 'aggregationOperator',
    operator: operator,
    parameter: parameter,
    expression: expression,
    by: by,
    without: without,
    match(matchers): $ {
      _+: {
        expression: super.expression._.match(matchers),
      },
    },
    expr:
      local byString = if (std.length(self.by) > 0) then 'by (%s)' % std.join(', ', self.by) else '';
      local withoutString = if (std.length(without) > 0) then 'without (%s)' % std.join(', ', self.without) else '';
      local expressionString = if (self.parameter == '') then '(%s)' % self.expression._.expr else '(%s, %s)' % [std.manifestJson(self.parameter), self.expression._.expr];
      local parts = [operator, byString, withoutString, expressionString];
      std.join(' ', [part for part in parts if part != '']),
  },
};

local aggregationOperators = {
  sum(expression, by=[], without=[]): aggregationOperator('sum', '', expression, by, without),
  min(expression, by=[], without=[]): aggregationOperator('min', '', expression, by, without),
  max(expression, by=[], without=[]): aggregationOperator('max', '', expression, by, without),
  avg(expression, by=[], without=[]): aggregationOperator('avg', '', expression, by, without),
  group(expression, by=[], without=[]): aggregationOperator('group', '', expression, by, without),
  stddev(expression, by=[], without=[]): aggregationOperator('stddev', '', expression, by, without),
  stdvar(expression, by=[], without=[]): aggregationOperator('stdvar', '', expression, by, without),
  count(expression, by=[], without=[]): aggregationOperator('count', '', expression, by, without),
  count_values(parameter, expression, by=[], without=[]): aggregationOperator('count_values', parameter, expression, by, without),
  bottomk(parameter, expression, by=[], without=[]): aggregationOperator('bottomk', parameter, expression, by, without),
  topk(parameter, expression, by=[], without=[]): aggregationOperator('topk', parameter, expression, by, without),
  quantile(parameter, expression, by=[], without=[]): aggregationOperator('quantile', parameter, expression, by, without),
};

local func(name, parameters=[]) = {
  _: {
    kind: 'function',
    name: name,
    parameters: parameters,
    match(matchers): $ {
      _+: {
        parameters: [
          if std.type(parameter) == 'object' then parameter._.match(matchers) else parameter
          for parameter in super.parameters
        ],
      },
    },
    expr:
      local params = if std.length(self.parameters) == 0 then [] else
        if std.type(self.parameters[std.length(self.parameters) - 1]) == 'array'
        then self.parameters[:std.length(self.parameters) - 1] + self.parameters[std.length(self.parameters) - 1]
        else self.parameters;
      local parameterString = if (std.length(params) > 0) then std.join(', ', resolveExpr(params)) else '';
      '%s(%s)' % [self.name, parameterString],
  },
};

local functions = {
  abs(vector): func('abs', [vector]),
  absent(vector): func('absent', [vector]),
  absent_over_time(vector, range): func('absent_over_time', [rangeSelector(vector, range)]),
  ceil(vector): func('ceil', [vector]),
  changes(vector, range): func('changes', [rangeSelector(vector, range)]),
  clamp(vector, min, max): func('clamp', [vector, min, max]),
  clamp_max(vector, max): func('clamp_max', [vector, max]),
  clamp_min(vector, min): func('clamp_min', [vector, min]),
  day_of_month(vector): func('day_of_month', [vector]),
  day_of_week(vector): func('day_of_week', [vector]),
  day_of_year(vector): func('day_of_year', [vector]),
  days_in_month(vector): func('days_in_month', [vector]),
  delta(vector, range): func('delta', [rangeSelector(vector, range)]),
  deriv(vector, range): func('deriv', [rangeSelector(vector, range)]),
  exp(vector): func('exp', [vector]),
  floor(vector): func('floor', [vector]),
  histogram_avg(vector): func('histogram_avg', [vector]),
  histogram_count(vector): func('histogram_count', [vector]),
  histogram_sum(vector): func('histogram_sum', [vector]),
  histogram_fraction(lower, upper, vector): func('histogram_fraction', [lower, upper, vector]),
  histogram_quantile(phi, vector): func('histogram_quantile', [phi, vector]),
  histogram_stddev(vector): func('histogram_stddev', [vector]),
  histogram_stdvar(vector): func('histogram_stdvar', [vector]),
  holt_winters(vector, range, sf, tf): func('holt_winters', [rangeSelector(vector, range), sf, tf]),
  hour(vector): func('hour', [vector]),
  idelta(vector, range): func('idelta', [rangeSelector(vector, range)]),
  increase(vector, range): func('increase', [rangeSelector(vector, range)]),
  irate(vector, range): func('irate', [rangeSelector(vector, range)]),
  label_join(v, dst_label, separator, src_labels): func('label_join', [v, dst_label, separator, src_labels]),
  label_replace(v, dst_label, replacement, src_label, regex): func('label_replace', [v, dst_label, replacement, src_label, regex]),
  ln(vector): func('ln', [vector]),
  log2(vector): func('log2', [vector]),
  log10(vector): func('log10', [vector]),
  minute(vector): func('minute', [vector]),
  month(vector): func('month', [vector]),
  predict_linear(vector, range, t): func('predict_linear', [rangeSelector(vector, range), t]),
  rate(vector, range): func('rate', [rangeSelector(vector, range)]),
  resets(vector, range): func('resets', [rangeSelector(vector, range)]),
  round(vector, to_nearest=1): func('round', [vector, to_nearest]),
  scalar(vector): func('scalar', [vector]),
  sgn(vector): func('sgn', [vector]),
  sort(vector): func('sort', [vector]),
  sort_by_label(v, labels): func('sort_by_label', [v, labels]),
  sort_by_label_desc(v, labels): func('sort_by_label_desc', [v, labels]),
  sort_desc(vector): func('sort_desc', [vector]),
  sqrt(vector): func('sqrt', [vector]),
  time(): func('time'),
  timestamp(vector): func('timestamp', [vector]),
  vector(scalar): func('vector', [scalar]),
  year(vector): func('year', [vector]),
  avg_over_time(vector, range): func('avg_over_time', [rangeSelector(vector, range)]),
  min_over_time(vector, range): func('min_over_time', [rangeSelector(vector, range)]),
  max_over_time(vector, range): func('max_over_time', [rangeSelector(vector, range)]),
  sum_over_time(vector, range): func('sum_over_time', [rangeSelector(vector, range)]),
  count_over_time(vector, range): func('count_over_time', [rangeSelector(vector, range)]),
  quantile_over_time(scalar, vector, range): func('quantile_over_time', [scalar, rangeSelector(vector, range)]),
  stddev_over_time(vector, range): func('stddev_over_time', [rangeSelector(vector, range)]),
  stdvar_over_time(vector, range): func('stdvar_over_time', [rangeSelector(vector, range)]),
  last_over_time(vector, range): func('last_over_time', [rangeSelector(vector, range)]),
  present_over_time(vector, range): func('present_over_time', [rangeSelector(vector, range)]),
  mad_over_time(vector, range): func('mad_over_time', [rangeSelector(vector, range)]),
  acos(vector): func('acos', [vector]),
  acosh(vector): func('acosh', [vector]),
  asin(vector): func('asin', [vector]),
  asinh(vector): func('asinh', [vector]),
  atan(vector): func('atan', [vector]),
  atanh(vector): func('atanh', [vector]),
  cos(vector): func('cos', [vector]),
  cosh(vector): func('cosh', [vector]),
  sin(vector): func('sin', [vector]),
  sinh(vector): func('sinh', [vector]),
  tan(vector): func('tan', [vector]),
  tanh(vector): func('tanh', [vector]),
  deg(vector): func('deg', [vector]),
  pi(): func('pi'),
  rad(vector): func('rad', [vector]),
};

local promql =
  selectors
  + matchers
  + arithmeticOperators
  + comparisonOperators
  + aggregationOperators
  + functions;

promql
