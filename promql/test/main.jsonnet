local p = import '../main.libsonnet';
local prometheus = import 'prometheus.libsonnet';

local metricTests = {
  name: 'metric',
  tests: [
    {
      name: 'simple metric',
      input:: prometheus.http_requests_total,
      expected: 'prometheus_http_requests_total',
    },
  ],
};

local matcherTests = {
  name: 'matchers',
  tests: [
    {
      name: 'default',
      input:: prometheus.http_requests_total { code: '$code' },
      expected: 'prometheus_http_requests_total{code="$code"}',
    },
    {
      name: 'eq',
      input:: prometheus.http_requests_total { code: p.eq('$code') },
      expected: 'prometheus_http_requests_total{code="$code"}',
    },
    {
      name: 'regex',
      input:: prometheus.http_requests_total { code: p.regex('$code') },
      expected: 'prometheus_http_requests_total{code=~"$code"}',
    },
    {
      name: 'regexNot',
      input:: prometheus.http_requests_total { code: p.regexNot('$code') },
      expected: 'prometheus_http_requests_total{code!~"$code"}',
    },
    {
      name: 'multiple',
      input:: prometheus.http_requests_total { code: '$code', handler: '$handler' },
      expected: 'prometheus_http_requests_total{code="$code", handler="$handler"}',
    },
  ],
};

local arithmeticOperatorTests = {
  name: 'arithmeticOperators',
  tests: [
    {
      name: 'add',
      input:: p.add(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total + prometheus_http_requests_total',
    },
    {
      name: 'sub',
      input:: p.sub(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total - prometheus_http_requests_total',
    },
    {
      name: 'mul',
      input:: p.mul(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total * prometheus_http_requests_total',
    },
    {
      name: 'div',
      input:: p.div(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total / prometheus_http_requests_total',
    },
    {
      name: 'mod',
      input:: p.mod(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total % prometheus_http_requests_total',
    },
    {
      name: 'pow',
      input:: p.pow(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total ^ prometheus_http_requests_total',
    },
  ],
};

local comparisonOperatorTests = {
  name: 'comparisonOperators',
  tests: [
    {
      name: 'equal',
      input:: p.equal(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total == prometheus_http_requests_total',
    },
    {
      name: 'notEqual',
      input:: p.notEqual(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total != prometheus_http_requests_total',
    },
    {
      name: 'greaterThan',
      input:: p.greaterThan(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total > prometheus_http_requests_total',
    },
    {
      name: 'lessThan',
      input:: p.lessThan(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total < prometheus_http_requests_total',
    },
    {
      name: 'greaterOrEqual',
      input:: p.greaterOrEqual(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total >= prometheus_http_requests_total',
    },
    {
      name: 'lessOrEqual',
      input:: p.lessOrEqual(prometheus.http_requests_total, prometheus.http_requests_total),
      expected: 'prometheus_http_requests_total <= prometheus_http_requests_total',
    },
  ],
};

local aggregationOperatorTests = {
  name: 'aggregationOperators',
  tests: [
    {
      name: 'sum',
      input:: p.sum(prometheus.http_requests_total, by=['instance']),
      expected: 'sum by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'min',
      input:: p.min(prometheus.http_requests_total, by=['instance']),
      expected: 'min by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'max',
      input:: p.max(prometheus.http_requests_total, by=['instance']),
      expected: 'max by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'avg',
      input:: p.avg(prometheus.http_requests_total, by=['instance']),
      expected: 'avg by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'count',
      input:: p.group(prometheus.http_requests_total, by=['instance']),
      expected: 'group by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'stddev',
      input:: p.stddev(prometheus.http_requests_total, by=['instance']),
      expected: 'stddev by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'stdvar',
      input:: p.stdvar(prometheus.http_requests_total, by=['instance']),
      expected: 'stdvar by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'count',
      input:: p.count(prometheus.http_requests_total, by=['instance']),
      expected: 'count by(instance) (prometheus_http_requests_total)',
    },
    {
      name: 'count_values',
      input:: p.count_values('instance', prometheus.http_requests_total, by=['instance']),
      expected: 'count_values by(instance) ("instance", prometheus_http_requests_total)',
    },
    {
      name: 'bottomk',
      input:: p.bottomk(10, prometheus.http_requests_total, by=['instance']),
      expected: 'bottomk by(instance) (10, prometheus_http_requests_total)',
    },
    {
      name: 'topk',
      input:: p.topk(10, prometheus.http_requests_total, by=['instance']),
      expected: 'topk by(instance) (10, prometheus_http_requests_total)',
    },
    {
      name: 'quantile',
      input:: p.quantile(0.9, prometheus.http_requests_total, by=['instance']),
      expected: 'quantile by(instance) (0.90000000000000002, prometheus_http_requests_total)',
    },
  ],
};

local funcTests = {
  name: 'funcs',
  tests: [
    {
      name: 'abs',
      input:: p.abs(prometheus.http_requests_total),
      expected: 'abs(prometheus_http_requests_total)',
    },
    {
      name: 'absent',
      input:: p.absent(prometheus.http_requests_total),
      expected: 'absent(prometheus_http_requests_total)',
    },
    {
      name: 'absent_over_time',
      input:: p.absent_over_time(prometheus.http_requests_total, '5m'),
      expected: 'absent_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'ceil',
      input:: p.ceil(prometheus.http_requests_total),
      expected: 'ceil(prometheus_http_requests_total)',
    },
    {
      name: 'changes',
      input:: p.changes(prometheus.http_requests_total, '5m'),
      expected: 'changes(prometheus_http_requests_total[5m])',
    },
    {
      name: 'clamp',
      input:: p.clamp(prometheus.http_requests_total, 5, 10),
      expected: 'clamp(prometheus_http_requests_total, 5, 10)',
    },
    {
      name: 'clamp_max',
      input:: p.clamp_max(prometheus.http_requests_total, 10),
      expected: 'clamp_max(prometheus_http_requests_total, 10)',
    },
    {
      name: 'clamp_min',
      input:: p.clamp_min(prometheus.http_requests_total, 10),
      expected: 'clamp_min(prometheus_http_requests_total, 10)',
    },
    {
      name: 'day_of_month',
      input:: p.day_of_month(prometheus.http_requests_total),
      expected: 'day_of_month(prometheus_http_requests_total)',
    },
    {
      name: 'day_of_week',
      input:: p.day_of_week(prometheus.http_requests_total),
      expected: 'day_of_week(prometheus_http_requests_total)',
    },
    {
      name: 'day_of_year',
      input:: p.day_of_year(prometheus.http_requests_total),
      expected: 'day_of_year(prometheus_http_requests_total)',
    },
    {
      name: 'days_in_month',
      input:: p.days_in_month(prometheus.http_requests_total),
      expected: 'days_in_month(prometheus_http_requests_total)',
    },
    {
      name: 'delta',
      input:: p.delta(prometheus.http_requests_total, '5m'),
      expected: 'delta(prometheus_http_requests_total[5m])',
    },
    {
      name: 'deriv',
      input:: p.deriv(prometheus.http_requests_total, '5m'),
      expected: 'deriv(prometheus_http_requests_total[5m])',
    },
    {
      name: 'exp',
      input:: p.exp(prometheus.http_requests_total),
      expected: 'exp(prometheus_http_requests_total)',
    },
    {
      name: 'floor',
      input:: p.floor(prometheus.http_requests_total),
      expected: 'floor(prometheus_http_requests_total)',
    },
    {
      name: 'histogram_avg',
      input:: p.histogram_avg(prometheus.http_requests_total),
      expected: 'histogram_avg(prometheus_http_requests_total)',
    },
    {
      name: 'histogram_count',
      input:: p.histogram_count(prometheus.http_requests_total),
      expected: 'histogram_count(prometheus_http_requests_total)',
    },
    {
      name: 'histogram_sum',
      input:: p.histogram_sum(prometheus.http_requests_total),
      expected: 'histogram_sum(prometheus_http_requests_total)',
    },
    {
      name: 'histogram_fraction',
      input:: p.histogram_fraction(0, 0.2, prometheus.http_requests_total),
      expected: 'histogram_fraction(0, 0.20000000000000001, prometheus_http_requests_total)',
    },
    {
      name: 'histogram_quantile',
      input:: p.histogram_quantile(0.9, prometheus.http_requests_total),
      expected: 'histogram_quantile(0.90000000000000002, prometheus_http_requests_total)',
    },
    {
      name: 'histogram_stddev',
      input:: p.histogram_stddev(prometheus.http_requests_total),
      expected: 'histogram_stddev(prometheus_http_requests_total)',
    },
    {
      name: 'histogram_stdvar',
      input:: p.histogram_stdvar(prometheus.http_requests_total),
      expected: 'histogram_stdvar(prometheus_http_requests_total)',
    },
    {
      name: 'holt_winters',
      input:: p.holt_winters(prometheus.http_requests_total, '5m', 0.5, 0.5),
      expected: 'holt_winters(prometheus_http_requests_total[5m], 0.5, 0.5)',
    },
    {
      name: 'hour',
      input:: p.hour(prometheus.http_requests_total),
      expected: 'hour(prometheus_http_requests_total)',
    },
    {
      name: 'idelta',
      input:: p.idelta(prometheus.http_requests_total, '5m'),
      expected: 'idelta(prometheus_http_requests_total[5m])',
    },
    {
      name: 'increase',
      input:: p.increase(prometheus.http_requests_total, '5m'),
      expected: 'increase(prometheus_http_requests_total[5m])',
    },
    {
      name: 'irate',
      input:: p.irate(prometheus.http_requests_total, '5m'),
      expected: 'irate(prometheus_http_requests_total[5m])',
    },
    {
      name: 'ln',
      input:: p.ln(prometheus.http_requests_total),
      expected: 'ln(prometheus_http_requests_total)',
    },
    {
      name: 'log2',
      input:: p.log2(prometheus.http_requests_total),
      expected: 'log2(prometheus_http_requests_total)',
    },
    {
      name: 'log10',
      input:: p.log10(prometheus.http_requests_total),
      expected: 'log10(prometheus_http_requests_total)',
    },
    {
      name: 'minute',
      input:: p.minute(prometheus.http_requests_total),
      expected: 'minute(prometheus_http_requests_total)',
    },
    {
      name: 'month',
      input:: p.month(prometheus.http_requests_total),
      expected: 'month(prometheus_http_requests_total)',
    },
    {
      name: 'predict_linear',
      input:: p.predict_linear(prometheus.http_requests_total, '5m', 300),
      expected: 'predict_linear(prometheus_http_requests_total[5m], 300)',
    },
    {
      name: 'rate',
      input:: p.rate(prometheus.http_requests_total, '5m'),
      expected: 'rate(prometheus_http_requests_total[5m])',
    },
    {
      name: 'resets',
      input:: p.resets(prometheus.http_requests_total, '5m'),
      expected: 'resets(prometheus_http_requests_total[5m])',
    },
    {
      name: 'round',
      input:: p.round(prometheus.http_requests_total, 5),
      expected: 'round(prometheus_http_requests_total, 5)',
    },
    {
      name: 'round optional',
      input:: p.round(prometheus.http_requests_total),
      expected: 'round(prometheus_http_requests_total, 1)',
    },
    {
      name: 'scalar',
      input:: p.scalar(prometheus.http_requests_total),
      expected: 'scalar(prometheus_http_requests_total)',
    },
    {
      name: 'sgn',
      input:: p.sgn(prometheus.http_requests_total),
      expected: 'sgn(prometheus_http_requests_total)',
    },
    {
      name: 'sort',
      input:: p.sort(prometheus.http_requests_total),
      expected: 'sort(prometheus_http_requests_total)',
    },
    {
      name: 'sort_desc',
      input:: p.sort_desc(prometheus.http_requests_total),
      expected: 'sort_desc(prometheus_http_requests_total)',
    },
    {
      name: 'sqrt',
      input:: p.sqrt(prometheus.http_requests_total),
      expected: 'sqrt(prometheus_http_requests_total)',
    },
    {
      name: 'time',
      input:: p.time(),
      expected: 'time()',
    },
    {
      name: 'timestamp',
      input:: p.timestamp(prometheus.http_requests_total),
      expected: 'timestamp(prometheus_http_requests_total)',
    },
    {
      name: 'vector',
      input:: p.vector(5),
      expected: 'vector(5)',
    },
    {
      name: 'year',
      input:: p.year(prometheus.http_requests_total),
      expected: 'year(prometheus_http_requests_total)',
    },
    {
      name: 'avg_over_time',
      input:: p.avg_over_time(prometheus.http_requests_total, '5m'),
      expected: 'avg_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'min_over_time',
      input:: p.min_over_time(prometheus.http_requests_total, '5m'),
      expected: 'min_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'max_over_time',
      input:: p.max_over_time(prometheus.http_requests_total, '5m'),
      expected: 'max_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'sum_over_time',
      input:: p.sum_over_time(prometheus.http_requests_total, '5m'),
      expected: 'sum_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'count_over_time',
      input:: p.count_over_time(prometheus.http_requests_total, '5m'),
      expected: 'count_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'quantile_over_time',
      input:: p.quantile_over_time(0.9, prometheus.http_requests_total, '5m'),
      expected: 'quantile_over_time(0.90000000000000002, prometheus_http_requests_total[5m])',
    },
    {
      name: 'stddev_over_time',
      input:: p.stddev_over_time(prometheus.http_requests_total, '5m'),
      expected: 'stddev_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'stdvar_over_time',
      input:: p.stdvar_over_time(prometheus.http_requests_total, '5m'),
      expected: 'stdvar_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'last_over_time',
      input:: p.last_over_time(prometheus.http_requests_total, '5m'),
      expected: 'last_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'present_over_time',
      input:: p.present_over_time(prometheus.http_requests_total, '5m'),
      expected: 'present_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'mad_over_time',
      input:: p.mad_over_time(prometheus.http_requests_total, '5m'),
      expected: 'mad_over_time(prometheus_http_requests_total[5m])',
    },
    {
      name: 'acos',
      input:: p.acos(prometheus.http_requests_total),
      expected: 'acos(prometheus_http_requests_total)',
    },
    {
      name: 'acosh',
      input:: p.acosh(prometheus.http_requests_total),
      expected: 'acosh(prometheus_http_requests_total)',
    },
    {
      name: 'asin',
      input:: p.asin(prometheus.http_requests_total),
      expected: 'asin(prometheus_http_requests_total)',
    },
    {
      name: 'asinh',
      input:: p.asinh(prometheus.http_requests_total),
      expected: 'asinh(prometheus_http_requests_total)',
    },
    {
      name: 'atan',
      input:: p.atan(prometheus.http_requests_total),
      expected: 'atan(prometheus_http_requests_total)',
    },
    {
      name: 'atanh',
      input:: p.atanh(prometheus.http_requests_total),
      expected: 'atanh(prometheus_http_requests_total)',
    },
    {
      name: 'cos',
      input:: p.cos(prometheus.http_requests_total),
      expected: 'cos(prometheus_http_requests_total)',
    },
    {
      name: 'cosh',
      input:: p.cosh(prometheus.http_requests_total),
      expected: 'cosh(prometheus_http_requests_total)',
    },
    {
      name: 'sin',
      input:: p.sin(prometheus.http_requests_total),
      expected: 'sin(prometheus_http_requests_total)',
    },
    {
      name: 'sinh',
      input:: p.sinh(prometheus.http_requests_total),
      expected: 'sinh(prometheus_http_requests_total)',
    },
    {
      name: 'tan',
      input:: p.tan(prometheus.http_requests_total),
      expected: 'tan(prometheus_http_requests_total)',
    },
    {
      name: 'tanh',
      input:: p.tanh(prometheus.http_requests_total),
      expected: 'tanh(prometheus_http_requests_total)',
    },
    {
      name: 'deg',
      input:: p.deg(prometheus.http_requests_total),
      expected: 'deg(prometheus_http_requests_total)',
    },
    {
      name: 'pi',
      input:: p.pi(),
      expected: 'pi()',
    },
    {
      name: 'rad',
      input:: p.rad(prometheus.http_requests_total),
      expected: 'rad(prometheus_http_requests_total)',
    },
  ],
};

local testGroups = [
  metricTests,
  matcherTests,
  arithmeticOperatorTests,
  comparisonOperatorTests,
  aggregationOperatorTests,
  funcTests,
];

std.flattenArrays([
  [
    {
      name: '%s/%s' % [group.name, test.name],
      actual: test.input.output,
      expected: test.expected,
    }
    for test in group.tests
  ]
  for group in testGroups
])
