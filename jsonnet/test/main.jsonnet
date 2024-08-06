local j = import '../main.libsonnet';

local literalTests = {
  name: 'literal',
  tests: [
    {
      name: 'true',
      input:: j.bool(true),
      expected: 'true',
    },
    {
      name: 'false',
      input:: j.bool(false),
      expected: 'false',
    },
    {
      name: 'number',
      input:: j.number(1),
      expected: '1',
    },
    {
      name: 'string',
      input:: j.string('string'),
      expected: '"string"',
    },
  ],
};

local listTests = {
  name: 'list',
  tests: [
    {
      name: 'single',
      input:: j.list([
        j.string('string'),
      ]),
      expected: '["string"]',
    },
    {
      name: 'multiple',
      input:: j.list([
        j.string('foo'),
        j.string('bar'),
      ]),
      expected: '["foo", "bar"]',
    },
    {
      name: 'variable',
      input:: j.list([
        j.variable('foo', j.string('val')),
        j.string('bar'),
      ]),
      expected: '[local foo = "val"; "bar"]',
    },
  ],
};

local objectTests = {
  name: 'object',
  tests: [
    {
      name: 'single',
      input:: j.object([
        j.field('foo', j.string('bar')),
      ]),
      expected: '{foo: "bar"}',
    },
    {
      name: 'hidden',
      input:: j.object([
        j.field('foo', j.string('bar'), visibility='::'),
      ]),
      expected: '{foo:: "bar"}',
    },
    {
      name: 'nested',
      input:: j.object([
        j.field('foo', j.object([
          j.field('bar', j.string('baz')),
        ])),
      ]),
      expected: '{foo: {bar: "baz"}}',
    },
    {
      name: 'multiple',
      input:: j.object([
        j.field('foo', j.string('bar')),
        j.field('baz', j.string('val')),
      ]),
      expected: '{foo: "bar", baz: "val"}',
    },
    {
      name: 'variable',
      input:: j.object([
        j.variable('foo', j.string('val')),
        j.field('foo', j.string('bar')),
      ]),
      expected: '{local foo = "val", foo: "bar"}',
    },
    {
      name: 'function signature',
      input:: j.object([
        j.field(j.functionSignature('foo', ['name']), j.string('bar'), visibility='::'),
        j.field('baz', j.string('val')),
      ]),
      expected: '{foo(name):: "bar", baz: "val"}',
    },
  ],
};

local testGroups = [
  literalTests,
  listTests,
  objectTests,
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
