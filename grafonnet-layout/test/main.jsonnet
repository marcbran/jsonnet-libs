local lt = import '../main.libsonnet';

local random(title) = {
  title: title,
  type: 'timeseries',
};

local rowTests = {
  name: 'row',
  tests: [
    {
      name: 'single',
      input:: lt.row(5, [
        lt.panel(1, random('a')),
      ]),
      expected: [{
        gridPos: { h: 5, w: 1, x: 0, y: 0 },
        title: 'a',
        type: 'timeseries',
      }],
    },
    {
      name: 'multiple',
      input:: lt.row(5, [
        lt.panel(1, random('a')),
        lt.panel(2, random('b')),
        lt.panel(4, random('c')),
      ]),
      expected: [
        {
          gridPos: { h: 5, w: 1, x: 0, y: 0 },
          title: 'a',
          type: 'timeseries',
        },
        {
          gridPos: { h: 5, w: 2, x: 1, y: 0 },
          title: 'b',
          type: 'timeseries',
        },
        {
          gridPos: { h: 5, w: 4, x: 3, y: 0 },
          title: 'c',
          type: 'timeseries',
        },
      ],
    },
    {
      name: 'nested',
      input:: lt.row(6, [
        lt.panel(1, random('a')),
        lt.column(6, [
          lt.panel(2, random('b')),
          lt.panel(2, random('c')),
          lt.panel(2, random('d')),
        ]),
        lt.panel(4, random('e')),
      ]),
      expected: [
        {
          gridPos: { h: 6, w: 1, x: 0, y: 0 },
          title: 'a',
          type: 'timeseries',
        },
        {
          gridPos: { h: 2, w: 6, x: 1, y: 0 },
          title: 'b',
          type: 'timeseries',
        },
        {
          gridPos: { h: 2, w: 6, x: 1, y: 2 },
          title: 'c',
          type: 'timeseries',
        },
        {
          gridPos: { h: 2, w: 6, x: 1, y: 4 },
          title: 'd',
          type: 'timeseries',
        },
        {
          gridPos: { h: 6, w: 4, x: 7, y: 0 },
          title: 'e',
          type: 'timeseries',
        },
      ],
    },
  ],
};

local columnTests = {
  name: 'column',
  tests: [
    {
      name: 'single',
      input:: lt.column(5, [
        lt.panel(1, random('a')),
      ]),
      expected: [{
        gridPos: { h: 1, w: 5, x: 0, y: 0 },
        title: 'a',
        type: 'timeseries',
      }],
    },
    {
      name: 'multiple',
      input:: lt.column(5, [
        lt.panel(1, random('a')),
        lt.panel(2, random('b')),
        lt.panel(4, random('c')),
      ]),
      expected: [
        {
          gridPos: { h: 1, w: 5, x: 0, y: 0 },
          title: 'a',
          type: 'timeseries',
        },
        {
          gridPos: { h: 2, w: 5, x: 0, y: 1 },
          title: 'b',
          type: 'timeseries',
        },
        {
          gridPos: { h: 4, w: 5, x: 0, y: 3 },
          title: 'c',
          type: 'timeseries',
        },
      ],
    },
    {
      name: 'nested',
      input:: lt.column(6, [
        lt.panel(1, random('a')),
        lt.row(6, [
          lt.panel(2, random('b')),
          lt.panel(2, random('c')),
          lt.panel(2, random('d')),
        ]),
        lt.panel(4, random('e')),
      ]),
      expected: [
        {
          gridPos: { h: 1, w: 6, x: 0, y: 0 },
          title: 'a',
          type: 'timeseries',
        },
        {
          gridPos: { h: 6, w: 2, x: 0, y: 1 },
          title: 'b',
          type: 'timeseries',
        },
        {
          gridPos: { h: 6, w: 2, x: 2, y: 1 },
          title: 'c',
          type: 'timeseries',
        },
        {
          gridPos: { h: 6, w: 2, x: 4, y: 1 },
          title: 'd',
          type: 'timeseries',
        },
        {
          gridPos: { h: 4, w: 6, x: 0, y: 7 },
          title: 'e',
          type: 'timeseries',
        },
      ],
    },
  ],
};

local panelTests = {
  name: 'panel',
  tests: [
    {
      name: 'simple',
      input:: lt.panel(1, random('a')),
      expected: [{
        gridPos: { h: 1, w: 1, x: 0, y: 0 },
        title: 'a',
        type: 'timeseries',
      }],
    },
  ],
};

local spaceTests = {
  name: 'space',
  tests: [
    {
      name: 'simple',
      input:: lt.space(1),
      expected: [],
    },
  ],
};

local testGroups = [
  rowTests,
  columnTests,
  panelTests,
  spaceTests,
];

std.flattenArrays([
  [
    {
      name: '%s/%s' % [group.name, test.name],
      actual: lt.layout(test.input),
      expected: test.expected,
    }
    for test in group.tests
  ]
  for group in testGroups
])
