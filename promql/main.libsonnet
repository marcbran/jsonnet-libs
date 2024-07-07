local range(vector, range) = {
  output: '%s[%s]' % [vector.output, range],
};

local matcher(value, operator) = {
  output(field): '%s%s"%s"' % [field, operator, value],
};

local matchers = {
  eq(value): matcher(value, '='),
  not(value): matcher(value, '!='),
  regex(value): matcher(value, '=~'),
  regexNot(value): matcher(value, '!~'),
};

local operator(left, operator, right, by, ignoring, group_left, group_right) = {
  local byString = if (std.length(by) > 0) then 'by(%s)' % std.join(', ', by) else '',
  local ignoringString = if (std.length(ignoring) > 0) then 'ignoring(%s)' % std.join(', ', ignoring) else '',
  local groupLeftString = if (std.length(group_left) > 0) then 'group_left(%s)' % std.join(', ', group_left) else '',
  local groupRightString = if (std.length(group_right) > 0) then 'group_right(%s)' % std.join(', ', group_right) else '',
  local parts = [left.output, operator, byString, ignoringString, groupLeftString, groupRightString, right.output],
  output: std.join(' ', [part for part in parts if part != '']),
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
  local expressionString = if (parameter == '') then '(%s)' % expression.output else '(%s, %s)' % [parameter, expression.output],
  local parts = [operator, byString, withoutString, expressionString],
  output: std.join(' ', [part for part in parts if part != '']),
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
  count_values(expression, by=[], without=[]): aggregationOperator('count_values', '', expression, by, without),
  bottomk(parameter, expression, by=[], without=[]): aggregationOperator('bottomk', parameter, expression, by, without),
  topk(parameter, expression, by=[], without=[]): aggregationOperator('topk', parameter, expression, by, without),
  quantile(parameter, expression, by=[], without=[]): aggregationOperator('quantile', parameter, expression, by, without),
};

local func(name) = {
  output: '%s()' % [name],
};

local funcInstant(name, vector) = {
  output: '%s(%s)' % [name, vector.output],
};

local funcInstantScalar(name, vector, scalarA) = {
  output: '%s(%s, %d)' % [name, vector.output, scalarA],
};

local funcInstantScalarScalar(name, vector, scalarA, scalarB) = {
  output: '%s(%s, %d, %d)' % [name, vector.output, scalarA, scalarB],
};

local funcRange(name, vector, range) = {
  output: '%s(%s[%s])' % [name, vector.output, range],
};

local funcRangeScalar(name, vector, range, scalar) = {
  output: '%s(%s[%s], %d)' % [name, vector.output, range, scalar],
};

local funcRangeScalarScalar(name, vector, range, scalarA, scalarB) = {
  output: '%s(%s[%s], %d, %d)' % [name, vector.output, range, scalarA, scalarB],
};

local funcScalar(name, scalar) = {
  output: '%s(%d)' % [name, scalar],
};

local funcScalarInstant(name, scalar, vector) = {
  output: '%s(%d, %s)' % [name, scalar, vector.output],
};

local funcScalarScalarInstant(name, scalarA, scalarB, vector) = {
  output: '%s(%d, %d, %s)' % [name, scalarA, scalarB, vector.output],
};

local funcScalarRange(name, scalar, vector, range) = {
  output: '%s(%d, %s[%s])' % [name, scalar, vector.output, range],
};

/*
TODO
label_join(v instant-vector, dst_label string, separator string, src_label_1 string, src_label_2 string, ...)
label_replace(v instant-vector, dst_label string, replacement string, src_label string, regex string)
sort_by_label(v instant-vector, label string, ...)
sort_by_label_desc(v instant-vector, label string, ...)
*/
local functions = {
  abs(vector): funcInstant('abs', vector),
  absent(vector): funcInstant('absent', vector),
  absent_over_time(vector, range): funcRange('absent_over_time', vector, range),
  ceil(vector): funcInstant('ceil', vector),
  changes(vector, range): funcRange('changes', vector, range),
  clamp(vector, min, max): funcInstantScalarScalar('clamp', vector, min, max),
  clamp_max(vector, max): funcInstantScalar('clamp_max', vector, max),
  clamp_min(vector, min): funcInstantScalar('clamp_min', vector, min),
  day_of_month(vector): funcInstant('day_of_month', vector),
  day_of_week(vector): funcInstant('day_of_week', vector),
  day_of_year(vector): funcInstant('day_of_year', vector),
  days_in_month(vector): funcInstant('days_in_month', vector),
  delta(vector, range): funcRange('delta', vector, range),
  deriv(vector, range): funcRange('deriv', vector, range),
  exp(vector): funcInstant('exp', vector),
  floor(vector): funcInstant('floor', vector),
  histogram_avg(vector): funcInstant('histogram_avg', vector),
  histogram_count(vector): funcInstant('histogram_count', vector),
  histogram_sum(vector): funcInstant('histogram_sum', vector),
  histogram_fraction(lower, upper, vector): funcScalarScalarInstant('histogram_sum', lower, upper, vector),
  histogram_quantile(phi, vector): funcScalarScalarInstant('histogram_quantile', phi, vector),
  histogram_stddev(vector): funcInstant('histogram_stddev', vector),
  histogram_stdvar(vector): funcInstant('histogram_stdvar', vector),
  holt_winters(vector, sf, tf): funcRangeScalarScalar('holt_winters', vector, sf, tf),
  hour(vector): funcInstant('hour', vector),
  idelta(vector, range): funcRange('idelta', vector, range),
  increase(vector, range): funcRange('increase', vector, range),
  irate(vector, range): funcRange('irate', vector, range),
  ln(vector): funcInstant('ln', vector),
  log2(vector): funcInstant('log2', vector),
  log10(vector): funcInstant('log10', vector),
  minute(vector): funcInstant('minute', vector),
  month(vector): funcInstant('month', vector),
  predict_linear(vector, range, t): funcRangeScalar('predict_linear', vector, range, t),
  rate(vector, range): funcRange('rate', vector, range),
  resets(vector, range): funcRange('resets', vector, range),
  round(vector, to_nearest): funcInstantScalar('round', vector, to_nearest),
  scalar(vector): funcInstant('scalar', vector),
  sgn(vector): funcInstant('sgn', vector),
  sort(vector): funcInstant('sort', vector),
  sort_desc(vector): funcInstant('sort_desc', vector),
  sqrt(vector): funcInstant('sqrt', vector),
  time(): func('time'),
  timestamp(vector): funcInstant('timestamp', vector),
  vector(scalar): funcScalar('vector', scalar),
  year(vector): funcInstant('year', vector),
  avg_over_time(vector, range): funcRange('avg_over_time', vector, range),
  min_over_time(vector, range): funcRange('min_over_time', vector, range),
  max_over_time(vector, range): funcRange('max_over_time', vector, range),
  sum_over_time(vector, range): funcRange('sum_over_time', vector, range),
  count_over_time(vector, range): funcRange('count_over_time', vector, range),
  quantile_over_time(scalar, vector, range): funcScalarRange('quantile_over_time', scalar, vector, range),
  stddev_over_time(vector, range): funcRange('stddev_over_time', vector, range),
  stdvar_over_time(vector, range): funcRange('stdvar_over_time', vector, range),
  last_over_time(vector, range): funcRange('last_over_time', vector, range),
  present_over_time(vector, range): funcRange('present_over_time', vector, range),
  mad_over_time(vector, range): funcRange('mad_over_time', vector, range),
  acos(vector): funcInstant('acos', vector),
  acosh(vector): funcInstant('acosh', vector),
  asin(vector): funcInstant('asin', vector),
  asinh(vector): funcInstant('asinh', vector),
  atan(vector): funcInstant('atan', vector),
  atanh(vector): funcInstant('atanh', vector),
  cos(vector): funcInstant('cos', vector),
  cosh(vector): funcInstant('cosh', vector),
  sin(vector): funcInstant('sin', vector),
  sinh(vector): funcInstant('sinh', vector),
  tan(vector): funcInstant('tan', vector),
  tanh(vector): funcInstant('tanh', vector),
  deg(vector): funcInstant('deg', vector),
  pi(): func('pi'),
  rad(vector): funcInstant('rad', vector),
};

local promql =
  matchers
  + arithmeticOperators
  + comparisonOperators
  + aggregationOperators
  + functions;

promql
