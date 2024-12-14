local rangeSelector(vector, range) = {
  expr: '%s[%s]' % [vector.expr, range],
};

local offsetModifier(vector, offset) = {
  expr: '%s offset %s' % [vector.expr, offset],
};

local atModifier(vector, time) = {
  expr: '%s @ %s' % [vector.expr, time],
};

local subquery(vector, range, resolution=null) = {
  expr:
    if (resolution == null)
    then '%s[%s]' % [vector.expr, range]
    else '%s[%s:%s]' % [vector.expr, range, resolution],
};

local selectors = {
  range: rangeSelector,
  offset: offsetModifier,
  at: atModifier,
  subquery: subquery,
};

local matcher(value, operator) = {
  expr(field): '%s%s"%s"' % [field, operator, value],
};

local matchers = {
  eq(value): matcher(value, '='),
  not(value): matcher(value, '!='),
  regex(value): matcher(value, '=~'),
  regexNot(value): matcher(value, '!~'),
};

local resolveOperand(value) =
  if std.type(value) == 'object' then
    if std.objectHas(value, 'type') && value.type == 'operator'
    then '(%s)' % value.expr
    else value.expr
  else if std.type(value) == 'number' then value + ''
  else value;

local operator(left, operator, right, by, ignoring, group_left, group_right) = {
  local leftString = resolveOperand(left),
  local byString = if (std.length(by) > 0) then 'by(%s)' % std.join(', ', by) else '',
  local ignoringString = if (std.length(ignoring) > 0) then 'ignoring(%s)' % std.join(', ', ignoring) else '',
  local groupLeftString = if (std.length(group_left) > 0) then 'group_left(%s)' % std.join(', ', group_left) else '',
  local groupRightString = if (std.length(group_right) > 0) then 'group_right(%s)' % std.join(', ', group_right) else '',
  local rightString = resolveOperand(right),
  local parts = [leftString, operator, byString, ignoringString, groupLeftString, groupRightString, rightString],
  type: 'operator',
  expr: std.join(' ', [part for part in parts if part != '']),
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
  local byString = if (std.length(by) > 0) then 'by(%s)' % std.join(', ', by) else '',
  local withoutString = if (std.length(without) > 0) then 'without(%s)' % std.join(', ', without) else '',
  local expressionString = if (parameter == '') then '(%s)' % expression.expr else '(%s, %s)' % [std.manifestJson(parameter), expression.expr],
  local parts = [operator, byString, withoutString, expressionString],
  expr: std.join(' ', [part for part in parts if part != '']),
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
  local params =
    if std.length(parameters) == 0
    then []
    else
      if std.type(parameters[std.length(parameters) - 1]) == 'array'
      then parameters[:std.length(parameters) - 1] + parameters[std.length(parameters) - 1]
      else parameters,
  local parameterString = if (std.length(params) > 0) then std.join(', ', [
    if (std.type(parameter) == 'object') then parameter.expr else std.manifestJson(parameter)
    for parameter in params
  ]) else '',
  expr: '%s(%s)' % [name, parameterString],
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
