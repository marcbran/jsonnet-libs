local equal(value) = {
  output(field): '%s="%s"' % [field, value],
};

local not(value) = {
  output(field): '%s!="%s"' % [field, value],
};

local regex(value) = {
  output(field): '%s=~"%s"' % [field, value],
};

local regexNot(value) = {
  output(field): '%s!~"%s"' % [field, value],
};

local metric = {
  __name__:: error 'required',
  local labels = [[field, self[field]] for field in std.sort(std.objectFields(self)) if field != '__name__' && field != 'output'],
  local comparisons = [[label[0], if std.type(label[1]) == 'string' then equal(label[1]) else label[1]] for label in labels],
  local filters = [comparison[1].output(comparison[0]) for comparison in comparisons],
  local filterString = std.join(', ', filters),
  output: if (std.length(filterString) > 0) then '%s{%s}' % [self.__name__, filterString] else self.__name__,
};

local operator(left, operator, right, by, ignoring, group_left, group_right) = {
  local byString = if (std.length(by) > 0) then 'by(%s)' % std.join(', ', by) else '',
  local ignoringString = if (std.length(ignoring) > 0) then 'ignoring(%s)' % std.join(', ', ignoring) else '',
  local groupLeftString = if (std.length(group_left) > 0) then 'group_left(%s)' % std.join(', ', group_left) else '',
  local groupRightString = if (std.length(group_right) > 0) then 'group_right(%s)' % std.join(', ', group_right) else '',
  local parts = [left.output, operator, byString, ignoringString, groupLeftString, groupRightString, right.output],
  output: std.join(' ', [part for part in parts if part != '']),
};

local add(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '+', right, by, ignoring, group_left, group_right);
local sub(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '-', right, by, ignoring, group_left, group_right);
local mul(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '*', right, by, ignoring, group_left, group_right);
local div(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '/', right, by, ignoring, group_left, group_right);
local mod(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '%', right, by, ignoring, group_left, group_right);
local pow(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '^', right, by, ignoring, group_left, group_right);

local equal(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '==', right, by, ignoring, group_left, group_right);
local notEqual(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '!=', right, by, ignoring, group_left, group_right);
local greaterThan(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '>', right, by, ignoring, group_left, group_right);
local lessThan(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '<', right, by, ignoring, group_left, group_right);
local greaterOrEqual(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '>=', right, by, ignoring, group_left, group_right);
local lessOrEqual(left, right, by=[], ignoring=[], group_left=[], group_right=[]) =
  operator(left, '<=', right, by, ignoring, group_left, group_right);

local aggregate(operator, parameter, expression, by, without) = {
  local byString = if (std.length(by) > 0) then 'by(%s)' % std.join(', ', by) else '',
  local withoutString = if (std.length(without) > 0) then 'without(%s)' % std.join(', ', without) else '',
  local expressionString = if (parameter == '') then '(%s)' % expression.output else '(%s, %s)' % [parameter, expression.output],
  local parts = [operator, byString, withoutString, expressionString],
  output: std.join(' ', [part for part in parts if part != '']),
};

local sum(expression, by=[], without=[]) = aggregate('sum', '', expression, by, without);
local min(expression, by=[], without=[]) = aggregate('min', '', expression, by, without);
local max(expression, by=[], without=[]) = aggregate('max', '', expression, by, without);
local avg(expression, by=[], without=[]) = aggregate('avg', '', expression, by, without);
local group(expression, by=[], without=[]) = aggregate('group', '', expression, by, without);
local stddev(expression, by=[], without=[]) = aggregate('stddev', '', expression, by, without);
local stdvar(expression, by=[], without=[]) = aggregate('stdvar', '', expression, by, without);
local count(expression, by=[], without=[]) = aggregate('count', '', expression, by, without);
local count_values(expression, by=[], without=[]) = aggregate('count_values', '', expression, by, without);
local bottomk(parameter, expression, by=[], without=[]) = aggregate('bottomk', parameter, expression, by, without);
local topk(parameter, expression, by=[], without=[]) = aggregate('topk', parameter, expression, by, without);
local quantile(parameter, expression, by=[], without=[]) = aggregate('quantile', parameter, expression, by, without);

local range(vector, range) = {
  output: '%s[%s]' % [vector.output, range],
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

local abs(vector) = funcInstant('abs', vector);
local absent(vector) = funcInstant('absent', vector);
local absent_over_time(vector, range) = funcRange('absent_over_time', vector, range);
local rate(vector, range) = funcRange('rate', vector, range);
local ceil(vector) = funcInstant('ceil', vector);
local changes(vector, range) = funcRange('changes', vector, range);
local clamp(vector, min, max) = funcInstantScalarScalar('clamp', vector, min, max);
local clamp_max(vector, max) = funcInstantScalar('clamp_max', vector, max);
local clamp_min(vector, min) = funcInstantScalar('clamp_min', vector, min);
local day_of_month(vector) = funcInstant('day_of_month', vector);
local day_of_week(vector) = funcInstant('day_of_week', vector);
local day_of_year(vector) = funcInstant('day_of_year', vector);
local days_in_month(vector) = funcInstant('days_in_month', vector);
local delta(vector, range) = funcRange('delta', vector, range);
local deriv(vector, range) = funcRange('deriv', vector, range);
local exp(vector) = funcInstant('exp', vector);
local floor(vector) = funcInstant('floor', vector);
local histogram_avg(vector) = funcInstant('histogram_avg', vector);
local histogram_count(vector) = funcInstant('histogram_count', vector);
local histogram_sum(vector) = funcInstant('histogram_sum', vector);
local histogram_fraction(lower, upper, vector) = funcScalarScalarInstant('histogram_sum', lower, upper, vector);
local histogram_quantile(phi, vector) = funcScalarScalarInstant('histogram_quantile', phi, vector);
local histogram_stddev(vector) = funcInstant('histogram_stddev', vector);
local histogram_stdvar(vector) = funcInstant('histogram_stdvar', vector);
local holt_winters(vector, sf, tf) = funcRangeScalarScalar('holt_winters', vector, sf, tf);
local hour(vector) = funcInstant('hour', vector);
local idelta(vector, range) = funcRange('idelta', vector, range);
local increase(vector, range) = funcRange('increase', vector, range);
local irate(vector, range) = funcRange('irate', vector, range);
local ln(vector) = funcInstant('ln', vector);
local log2(vector) = funcInstant('log2', vector);
local log10(vector) = funcInstant('log10', vector);
local minute(vector) = funcInstant('minute', vector);
local month(vector) = funcInstant('month', vector);
local predict_linear(vector, range, t) = funcRangeScalar('predict_linear', vector, range, t);
local rate(vector, range) = funcRange('rate', vector, range);
local resets(vector, range) = funcRange('resets', vector, range);
local round(vector, to_nearest) = funcInstantScalar('round', vector, max);
local scalar(vector) = funcInstant('scalar', vector);
local sgn(vector) = funcInstant('sgn', vector);
local sort(vector) = funcInstant('sort', vector);
local sort_desc(vector) = funcInstant('sort_desc', vector);
local sqrt(vector) = funcInstant('sqrt', vector);
local time() = func('time');
local timestamp(vector) = funcInstant('timestamp', vector);
local vector(scalar) = funcScalar('vector', scalar);
local year(vector) = funcInstant('year', vector);
local avg_over_time(vector, range) = funcRange('avg_over_time', vector, range);
local min_over_time(vector, range) = funcRange('min_over_time', vector, range);
local max_over_time(vector, range) = funcRange('max_over_time', vector, range);
local sum_over_time(vector, range) = funcRange('sum_over_time', vector, range);
local count_over_time(vector, range) = funcRange('count_over_time', vector, range);
local quantile_over_time(scalar, vector, range) = funcScalarRange('quantile_over_time', scalar, vector, range);
local stddev_over_time(vector, range) = funcRange('stddev_over_time', vector, range);
local stdvar_over_time(vector, range) = funcRange('stdvar_over_time', vector, range);
local last_over_time(vector, range) = funcRange('last_over_time', vector, range);
local present_over_time(vector, range) = funcRange('present_over_time', vector, range);
local mad_over_time(vector, range) = funcRange('mad_over_time', vector, range);
local acos(vector) = funcInstant('acos', vector);
local acosh(vector) = funcInstant('acosh', vector);
local asin(vector) = funcInstant('asin', vector);
local asinh(vector) = funcInstant('asinh', vector);
local atan(vector) = funcInstant('atan', vector);
local atanh(vector) = funcInstant('atanh', vector);
local cos(vector) = funcInstant('cos', vector);
local cosh(vector) = funcInstant('cosh', vector);
local sin(vector) = funcInstant('sin', vector);
local sinh(vector) = funcInstant('sinh', vector);
local tan(vector) = funcInstant('tan', vector);
local tanh(vector) = funcInstant('tanh', vector);
local deg(vector) = funcInstant('deg', vector);
local pi() = func('pi');
local rad(vector) = funcInstant('rad', vector);

/*
label_join(v instant-vector, dst_label string, separator string, src_label_1 string, src_label_2 string, ...)
label_replace(v instant-vector, dst_label string, replacement string, src_label string, regex string)
sort_by_label(v instant-vector, label string, ...)
sort_by_label_desc(v instant-vector, label string, ...)
*/

local instance_memory_limit_bytes = metric {
  __name__:: 'instance_memory_limit_bytes',
};

local node_cpu_seconds_total = metric {
  __name__:: 'node_cpu_seconds_total',
};

local test = {
  actual: self.input.output,
  result: self.actual == self.expected,
};

local tests = [
  test {
    input:: instance_memory_limit_bytes,
    expected: 'instance_memory_limit_bytes',
  },
  test {
    input:: instance_memory_limit_bytes { pod: '$pod' },
    expected: 'instance_memory_limit_bytes{pod="$pod"}',
  },
  test {
    input:: instance_memory_limit_bytes { pod: '$pod', namespace: '$namespace' },
    expected: 'instance_memory_limit_bytes{namespace="$namespace", pod="$pod"}',
  },
  test {
    input:: sub(instance_memory_limit_bytes, instance_memory_limit_bytes),
    expected: 'instance_memory_limit_bytes - instance_memory_limit_bytes',
  },
  test {
    input:: sub(
      instance_memory_limit_bytes,
      instance_memory_limit_bytes,
      by=['pod']
    ),
    expected: 'instance_memory_limit_bytes - by(pod) instance_memory_limit_bytes',
  },
  test {
    input:: sub(
      instance_memory_limit_bytes,
      instance_memory_limit_bytes,
      ignoring=['pod']
    ),
    expected: 'instance_memory_limit_bytes - ignoring(pod) instance_memory_limit_bytes',
  },
  test {
    input:: sub(
      instance_memory_limit_bytes,
      instance_memory_limit_bytes,
      ignoring=['pod'],
      group_left=['namespace']
    ),
    expected: 'instance_memory_limit_bytes - ignoring(pod) group_left(namespace) instance_memory_limit_bytes',
  },
  test {
    input:: node_cpu_seconds_total { mode: not('idle') },
    expected: 'node_cpu_seconds_total{mode!="idle"}',
  },
  test {
    input:: node_cpu_seconds_total { mode: not('idle'), instance: '192.168.0.10' },
    expected: 'node_cpu_seconds_total{instance="192.168.0.10", mode!="idle"}',
  },
  test {
    input:: rate(node_cpu_seconds_total { mode: not('idle') }, '5m'),
    expected: 'rate(node_cpu_seconds_total{mode!="idle"}[5m])',
  },
  test {
    input:: rate(node_cpu_seconds_total { mode: not('idle') }, range='5m'),
    expected: 'rate(node_cpu_seconds_total{mode!="idle"}[5m])',
  },
  test {
    input:: avg(rate(node_cpu_seconds_total { mode: not('idle') }, range='5m'), by=['instance']),
    expected: 'avg by(instance) (rate(node_cpu_seconds_total{mode!="idle"}[5m]))',
  },
  test {
    input:: topk(10, rate(node_cpu_seconds_total { mode: not('idle') }, range='5m'), by=['instance']),
    expected: 'topk by(instance) (10, rate(node_cpu_seconds_total{mode!="idle"}[5m]))',
  },
];

[test for test in tests if !test.result]
