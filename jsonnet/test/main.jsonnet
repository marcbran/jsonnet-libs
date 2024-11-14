local j = import '../main.libsonnet';

local nullTests = {
  name: 'null',
  tests: [
    {
      name: 'simple',
      input:: j.Null,
      expected: 'null',
    },
  ],
};

local trueTests = {
  name: 'true',
  tests: [
    {
      name: 'simple',
      input:: j.True,
      expected: 'true',
    },
  ],
};

local falseTests = {
  name: 'false',
  tests: [
    {
      name: 'simple',
      input:: j.False,
      expected: 'false',
    },
  ],
};

local selfTests = {
  name: 'self',
  tests: [
    {
      name: 'simple',
      input:: j.Object([
        j.Field(j.String('a'), j.String('foo')),
        j.Field(j.String('b'), j.Member(j.Self, 'a')),
      ]),
      expected: "{'a': 'foo', 'b': self.a}",
    },
  ],
};

local outerTests = {
  name: 'outer',
  tests: [
    {
      name: '',
      input:: j.Object([
        j.Field(j.String('a'), j.String('foo')),
        j.Field(j.String('b'), j.Object([
          j.Field(j.String('c'), j.Member(j.Outer, 'a')),
        ])),
      ]),
      expected: "{'a': 'foo', 'b': {'c': $.a}}",
    },
  ],
};

local superTests = {
  name: 'super',
  tests: [
    {
      name: '',
      input:: j.Add(
        j.Object([
          j.Field(j.String('a'), j.String('foo')),
        ]),
        j.Object([
          j.Field(j.String('b'), j.Member(j.Super, 'a')),
        ])
      ),
      expected: "{'a': 'foo'} + {'b': super.a}",
    },
  ],
};

local stringTests = {
  name: 'string',
  tests: [
    {
      name: 'single quote',
      input:: j.String('foobar'),
      expected: "'foobar'",
    },
    {
      name: 'format',
      input:: j.String('foobar %s', [j.String('baz')]),
      expected: "'foobar %s' % ['baz']",
    },
  ],
};

local numberTests = {
  name: 'number',
  tests: [
    {
      name: 'single digit',
      input:: j.Number(3),
      expected: '3',
    },
    {
      name: 'decimal',
      input:: j.Number(3.123, format='%.3f'),
      expected: '3.123',
    },
  ],
};

local idTests = {
  name: 'id',
  tests: [
    {
      name: 'simple id',
      input:: j.Exprs([
        j.Local('a', j.Number(1)),
        j.Id('a'),
      ]),
      expected: 'local a = 1;a',
    },
  ],
};

local memberTests = {
  name: 'member',
  tests: [
    {
      name: 'id member',
      input:: j.Exprs([
        j.Local('a', j.Object([
          j.Field(j.String('b'), j.Number(1)),
        ])),
        j.Member(j.Id('a'), 'b'),
      ]),
      expected: "local a = {'b': 1};a.b",
    },
    {
      name: 'id nested member',
      input:: j.Exprs([
        j.Local('a', j.Object([
          j.Field(j.String('b'), j.Object([
            j.Field(j.String('c'), j.Number(1)),
          ])),
        ])),
        j.Member(j.Member(j.Id('a'), 'b'), 'c'),
      ]),
      expected: "local a = {'b': {'c': 1}};a.b.c",
    },
  ],
};

local indexTests = {
  name: 'index',
  tests: [
    {
      name: 'id index',
      input:: j.Exprs([
        j.Local('a', j.Object([
          j.Field(j.String('foo-bar'), j.Number(1)),
        ])),
        j.Index(j.Id('a'), j.String('foo-bar')),
      ]),
      expected: "local a = {'foo-bar': 1};a['foo-bar']",
    },
    {
      name: 'id nested index',
      input:: j.Exprs([
        j.Local('a', j.Object([
          j.Field(j.String('foo-bar'), j.Object([
            j.Field(j.String('bar-foo'), j.Number(1)),
          ])),
        ])),
        j.Index(j.Index(j.Id('a'), j.String('foo-bar')), j.String('bar-foo')),
      ]),
      expected: "local a = {'foo-bar': {'bar-foo': 1}};a['foo-bar']['bar-foo']",
    },
  ],
};

local funcTests = {
  name: 'func',
  tests: [
    {
      name: 'one param',
      input:: j.Call(j.Member(j.Id('std'), 'map'), [
        j.Func([j.Id('a')], j.Id('a')),
        j.Array([j.Number(1), j.Number(2), j.Number(3)]),
      ]),
      expected: 'std.map(function(a) a, [1, 2, 3])',
    },
    {
      name: 'one default param',
      input:: j.Call(j.Member(j.Id('std'), 'map'), [
        j.Func([j.DefaultParam('a', j.Number(2))], j.Id('a')),
        j.Array([j.Number(1), j.Number(2), j.Number(3)]),
      ]),
      expected: 'std.map(function(a=2) a, [1, 2, 3])',
    },
  ],
};

local callTests = {
  name: 'call',
  tests: [
    {
      name: 'no params',
      input:: j.Exprs([
        j.LocalFunc('foo', [], j.Number(1)),
        j.Call(j.Id('foo'), []),
      ]),
      expected: 'local foo() = 1;foo()',
    },
    {
      name: 'one params',
      input:: j.Exprs([
        j.Local('a', j.Number(1)),
        j.LocalFunc('foo', [j.Id('a')], j.Id('a')),
        j.Call(j.Id('foo'), [j.Id('a')]),
      ]),
      expected: 'local a = 1;local foo(a) = a;foo(a)',
    },
    {
      name: 'one named params',
      input:: j.Exprs([
        j.Local('a', j.Number(1)),
        j.LocalFunc('foo', [j.Id('a')], j.Id('a')),
        j.Call(j.Id('foo'), [j.NamedParam('a', j.Number(2))]),
      ]),
      expected: 'local a = 1;local foo(a) = a;foo(a=2)',
    },
    {
      name: 'two params',
      input:: j.Exprs([
        j.Local('a', j.Number(1)),
        j.LocalFunc('foo', [j.Id('a'), j.Id('b')], j.Add(j.Id('a'), j.Id('b'))),
        j.Call(j.Id('foo'), [j.Id('a'), j.Number(1)]),
      ]),
      expected: 'local a = 1;local foo(a, b) = a + b;foo(a, 1)',
    },
    {
      name: 'two params, one named param',
      input:: j.Exprs([
        j.Local('a', j.Number(1)),
        j.LocalFunc('foo', [j.Id('a'), j.Id('b')], j.Add(j.Id('a'), j.Id('b'))),
        j.Call(j.Id('foo'), [j.Id('a'), j.NamedParam('b', j.Number(1))]),
      ]),
      expected: 'local a = 1;local foo(a, b) = a + b;foo(a, b=1)',
    },
  ],
};

local objectTests = {
  name: 'object',
  tests: [
    {
      name: 'empty',
      input:: j.Object([]),
      expected: '{}',
    },
    {
      name: 'field',
      input:: j.Object([
        j.Field(j.String('a'), j.Number(1)),
      ]),
      expected: "{'a': 1}",
    },
    {
      name: 'local',
      input:: j.Object([
        j.Local('a', j.Number(1)),
        j.Field(j.String('b'), j.Id('a')),
      ]),
      expected: "{local a = 1, 'b': a}",
    },
    {
      name: 'assert',
      input:: j.Object([
        j.Local('a', j.Number(1)),
        j.Assert(j.Eq(j.Id('a'), j.Number(1)), j.String('a must be 1')),
        j.Field(j.String('b'), j.Id('a')),
      ]),
      expected: "{local a = 1, assert a == 1: 'a must be 1', 'b': a}",
    },
  ],
};

local objectCompTests = {
  name: 'objectComp',
  tests: [
    {
      name: 'single',
      input:: j.ObjectComp([
        j.KeyValue(j.Id('number'), j.Add(j.Id('number'), j.Number(1))),
      ]).
        For('number', j.Array([j.String('1'), j.String('2'), j.String('3')])),
      expected: "{[number]: number + 1 for number in ['1', '2', '3']}",
    },
    {
      name: 'double',
      input::
        j.ObjectComp([
          j.KeyValue(j.Add(j.Id('a'), j.Id('b')), j.Add(j.Id('a'), j.Id('b'))),
        ]).
          For('a', j.Array([j.String('1'), j.String('2'), j.String('3')])).
          For('b', j.Array([j.String('4'), j.String('5'), j.String('6')])),
      expected: "{[a + b]: a + b for a in ['1', '2', '3'] for b in ['4', '5', '6']}",
    },
    {
      name: 'for if',
      input::
        j.ObjectComp([
          j.KeyValue(j.Id('a'), j.Add(j.Id('a'), j.Number(1))),
        ]).
          For('a', j.Array([j.String('1'), j.String('2'), j.String('3')])).
          If(j.Eq(j.Id('a'), j.String('2'))),
      expected: "{[a]: a + 1 for a in ['1', '2', '3'] if a == '2'}",
    },
  ],
};

local arrayTests = {
  name: 'array',
  tests: [
    {
      name: 'empty',
      input:: j.Array([]),
      expected: '[]',
    },
    {
      name: 'single',
      input:: j.Array([
        j.String('a'),
      ]),
      expected: "['a']",
    },
    {
      name: 'local',
      input:: j.Array([
        j.Local('a', j.Number(1)),
        j.Id('a'),
      ]),
      expected: '[local a = 1; a]',
    },
  ],
};

local arrayCompTests = {
  name: 'arrayComp',
  tests: [
    {
      name: 'single',
      input:: j.ArrayComp(j.Id('number')).For('number', j.Array([j.Number(1), j.Number(2), j.Number(3)])),
      expected: '[number for number in [1, 2, 3]]',
    },
    {
      name: 'double',
      input::
        j.ArrayComp(j.Add(j.Id('a'), j.Id('b'))).
          For('a', j.Array([j.Number(1), j.Number(2), j.Number(3)])).
          For('b', j.Array([j.Number(4), j.Number(5), j.Number(6)])),
      expected: '[a + b for a in [1, 2, 3] for b in [4, 5, 6]]',
    },
    {
      name: 'for if',
      input::
        j.ArrayComp(j.Add(j.Id('a'), j.Number(1))).
          For('a', j.Array([j.Number(1), j.Number(2), j.Number(3)])).
          If(j.Gt(j.Id('a'), j.Number(2))),
      expected: '[a + 1 for a in [1, 2, 3] if a > 2]',
    },
  ],
};

local ifTests = {
  name: 'if',
  tests: [
    {
      name: 'if',
      input:: j.If(j.Gt(j.Number(1), j.Number(0))).Then(j.Number(1)),
      expected: 'if 1 > 0 then 1',
    },
    {
      name: 'if-else',
      input:: j.If(j.Gt(j.Number(1), j.Number(0))).Then(j.Number(1)).Else(j.Number(0)),
      expected: 'if 1 > 0 then 1 else 0',
    },
  ],
};

local commentTests = {
  name: 'comment',
  tests: [
    {
      name: 'simple',
      input:: j.Exprs([
        j.Comment('Output the number one'),
        j.Number(1),
      ]),
      expected: '// Output the number one\n1',
    },
    {
      name: 'in object',
      input:: j.Object([
        j.Field(j.Id('a'), j.Number(1)),
        j.Comment('b is equal to two'),
        j.Field(j.Id('b'), j.Number(2)),
      ]),
      expected: '{a: 1, // b is equal to two\nb: 2}',
    },
    {
      name: 'in array',
      input:: j.Array([
        j.Number(1),
        j.Comment('add two to array'),
        j.Number(2),
      ]),
      expected: '[1, // add two to array\n2]',
    },
  ],
};

local testGroups = [
  nullTests,
  trueTests,
  falseTests,
  selfTests,
  outerTests,
  superTests,
  stringTests,
  numberTests,
  idTests,
  memberTests,
  indexTests,
  funcTests,
  callTests,
  objectTests,
  objectCompTests,
  arrayTests,
  arrayCompTests,
  ifTests,
  commentTests,
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
