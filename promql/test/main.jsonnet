local p = import '../main.libsonnet';

local instance = {
  memory_limit_bytes: p.metric('instance_memory_limit_bytes'),
};

local node = {
  cpu_seconds_total: p.metric('node_cpu_seconds_total'),
};

local metricTests = {
  name: 'metric',
  tests: [
    {
      name: 'simple metric',
      input:: instance.memory_limit_bytes,
      expected: 'instance_memory_limit_bytes',
    },
  ],
};

local matcherTests = {
  name: 'matchers',
  tests: [
    {
      name: 'default',
      input:: instance.memory_limit_bytes { pod: '$pod' },
      expected: 'instance_memory_limit_bytes{pod="$pod"}',
    },
    {
      name: 'eq',
      input:: instance.memory_limit_bytes { pod: p.eq('$pod') },
      expected: 'instance_memory_limit_bytes{pod="$pod"}',
    },
    {
      name: 'regex',
      input:: instance.memory_limit_bytes { pod: p.regex('$pod') },
      expected: 'instance_memory_limit_bytes{pod=~"$pod"}',
    },
    {
      name: 'regexNot',
      input:: instance.memory_limit_bytes { pod: p.regexNot('$pod') },
      expected: 'instance_memory_limit_bytes{pod!~"$pod"}',
    },
    {
      name: 'multiple',
      input:: instance.memory_limit_bytes { pod: '$pod', namespace: '$namespace' },
      expected: 'instance_memory_limit_bytes{namespace="$namespace", pod="$pod"}',
    },
  ],
};

local arithmeticOperatorTests = {
  name: 'arithmeticOperators',
  tests: [
    {
      name: 'add',
      input:: p.add(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes + instance_memory_limit_bytes',
    },
    {
      name: 'sub',
      input:: p.sub(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes - instance_memory_limit_bytes',
    },
    {
      name: 'mul',
      input:: p.mul(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes * instance_memory_limit_bytes',
    },
    {
      name: 'div',
      input:: p.div(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes / instance_memory_limit_bytes',
    },
    {
      name: 'mod',
      input:: p.mod(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes % instance_memory_limit_bytes',
    },
    {
      name: 'pow',
      input:: p.pow(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes ^ instance_memory_limit_bytes',
    },
  ],
};

local comparisonOperatorTests = {
  name: 'comparisonOperators',
  tests: [
    {
      name: 'equal',
      input:: p.equal(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes == instance_memory_limit_bytes',
    },
    {
      name: 'notEqual',
      input:: p.notEqual(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes != instance_memory_limit_bytes',
    },
    {
      name: 'greaterThan',
      input:: p.greaterThan(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes > instance_memory_limit_bytes',
    },
    {
      name: 'lessThan',
      input:: p.lessThan(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes < instance_memory_limit_bytes',
    },
    {
      name: 'greaterOrEqual',
      input:: p.greaterOrEqual(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes >= instance_memory_limit_bytes',
    },
    {
      name: 'lessOrEqual',
      input:: p.lessOrEqual(instance.memory_limit_bytes, instance.memory_limit_bytes),
      expected: 'instance_memory_limit_bytes <= instance_memory_limit_bytes',
    },
  ],
};

local aggregationOperatorTests = {
  name: 'aggregationOperators',
  tests: [
    {
      name: 'sum',
      input:: p.sum(instance.memory_limit_bytes, by=['instance']),
      expected: 'sum by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'min',
      input:: p.min(instance.memory_limit_bytes, by=['instance']),
      expected: 'min by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'max',
      input:: p.max(instance.memory_limit_bytes, by=['instance']),
      expected: 'max by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'avg',
      input:: p.avg(instance.memory_limit_bytes, by=['instance']),
      expected: 'avg by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'count',
      input:: p.group(instance.memory_limit_bytes, by=['instance']),
      expected: 'group by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'stddev',
      input:: p.stddev(instance.memory_limit_bytes, by=['instance']),
      expected: 'stddev by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'stdvar',
      input:: p.stdvar(instance.memory_limit_bytes, by=['instance']),
      expected: 'stdvar by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'count',
      input:: p.count(instance.memory_limit_bytes, by=['instance']),
      expected: 'count by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'count_values',
      input:: p.count_values(instance.memory_limit_bytes, by=['instance']),
      expected: 'count_values by(instance) (instance_memory_limit_bytes)',
    },
    {
      name: 'bottomk',
      input:: p.bottomk(10, instance.memory_limit_bytes, by=['instance']),
      expected: 'bottomk by(instance) (10, instance_memory_limit_bytes)',
    },
    {
      name: 'topk',
      input:: p.topk(10, instance.memory_limit_bytes, by=['instance']),
      expected: 'topk by(instance) (10, instance_memory_limit_bytes)',
    },
    {
      name: 'quantile',
      input:: p.quantile(0.9, instance.memory_limit_bytes, by=['instance']),
      expected: 'quantile by(instance) (0.90000000000000002, instance_memory_limit_bytes)',
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

[
  [
    {
      name: '%s/%s' % [group.name, test.name],
      actual: test.input.output,
      expected: test.expected,
    }
    for test in group.tests
    if test.input.output != test.expected
  ]
  for group in testGroups
]
