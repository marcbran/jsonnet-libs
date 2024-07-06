local p = import '../main.libsonnet';

local instance = {
  memory_limit_bytes: p.metric('instance_memory_limit_bytes'),
};

local node = {
  cpu_seconds_total: p.metric('node_cpu_seconds_total'),
};

local tests = [
  {
    input:: instance.memory_limit_bytes,
    expected: 'instance_memory_limit_bytes',
  },
  {
    input:: instance.memory_limit_bytes { pod: '$pod' },
    expected: 'instance_memory_limit_bytes{pod="$pod"}',
  },
  {
    input:: instance.memory_limit_bytes { pod: '$pod', namespace: '$namespace' },
    expected: 'instance_memory_limit_bytes{namespace="$namespace", pod="$pod"}',
  },
  {
    input:: p.sub(instance.memory_limit_bytes, instance.memory_limit_bytes),
    expected: 'instance_memory_limit_bytes - instance_memory_limit_bytes',
  },
  {
    input:: p.sub(
      instance.memory_limit_bytes,
      instance.memory_limit_bytes,
      by=['pod']
    ),
    expected: 'instance_memory_limit_bytes - by(pod) instance_memory_limit_bytes',
  },
  {
    input:: p.sub(
      instance.memory_limit_bytes,
      instance.memory_limit_bytes,
      ignoring=['pod']
    ),
    expected: 'instance_memory_limit_bytes - ignoring(pod) instance_memory_limit_bytes',
  },
  {
    input:: p.sub(
      instance.memory_limit_bytes,
      instance.memory_limit_bytes,
      ignoring=['pod'],
      group_left=['namespace']
    ),
    expected: 'instance_memory_limit_bytes - ignoring(pod) group_left(namespace) instance_memory_limit_bytes',
  },
  {
    input:: node.cpu_seconds_total { mode: p.not('idle') },
    expected: 'node_cpu_seconds_total{mode!="idle"}',
  },
  {
    input:: node.cpu_seconds_total { mode: p.not('idle'), instance: '192.168.0.10' },
    expected: 'node_cpu_seconds_total{instance="192.168.0.10", mode!="idle"}',
  },
  {
    input:: p.rate(node.cpu_seconds_total { mode: p.not('idle') }, '5m'),
    expected: 'rate(node_cpu_seconds_total{mode!="idle"}[5m])',
  },
  {
    input:: p.rate(node.cpu_seconds_total { mode: p.not('idle') }, range='5m'),
    expected: 'rate(node_cpu_seconds_total{mode!="idle"}[5m])',
  },
  {
    input:: p.avg(p.rate(node.cpu_seconds_total { mode: p.not('idle') }, range='5m'), by=['instance']),
    expected: 'avg by(instance) (rate(node_cpu_seconds_total{mode!="idle"}[5m]))',
  },
  {
    input:: p.topk(10, p.rate(node.cpu_seconds_total { mode: p.not('idle') }, range='5m'), by=['instance']),
    expected: 'topk by(instance) (10, rate(node_cpu_seconds_total{mode!="idle"}[5m]))',
  },
];

[test for test in tests if test.input.output != test.expected]
