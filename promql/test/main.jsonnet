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

local testGroups = [
  metricTests,
  matcherTests,
  arithmeticOperatorTests,
  comparisonOperatorTests,
  aggregationOperatorTests,
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
