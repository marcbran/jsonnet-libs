local lt = import './main.libsonnet';

local randomPanel(title) = {
  title: title,
  type: 'timeseries',
};

local random = {
  title: error 'title required',
  panel: {
    title: $.title,
    type: 'timeseries',
  },
};

local mixin = {
  datasource: {
    default: true,
    type: 'prometheus',
  },
};

local randomRow = {
  layout: lt.row(8, [
    lt.panel(8, randomPanel('layout')),
  ]),
};

local rowTests = {
  name: 'row',
  tests: [
    {
      name: 'single',
      input:: lt.row(5, [
        lt.panel(1, randomPanel('a')),
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
        lt.panel(1, randomPanel('a')),
        lt.panel(2, randomPanel('b')),
        lt.panel(4, randomPanel('c')),
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
        lt.panel(1, randomPanel('a')),
        lt.column(6, [
          lt.panel(2, randomPanel('b')),
          lt.panel(2, randomPanel('c')),
          lt.panel(2, randomPanel('d')),
        ]),
        lt.panel(4, randomPanel('e')),
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
    {
      name: 'provider',
      input:: lt.row(8, [randomRow]),
      expected: [{
        gridPos: { h: 8, w: 8, x: 0, y: 0 },
        title: 'layout',
        type: 'timeseries',
      }],
    },
  ],
};

local columnTests = {
  name: 'column',
  tests: [
    {
      name: 'single',
      input:: lt.column(5, [
        lt.panel(1, randomPanel('a')),
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
        lt.panel(1, randomPanel('a')),
        lt.panel(2, randomPanel('b')),
        lt.panel(4, randomPanel('c')),
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
        lt.panel(1, randomPanel('a')),
        lt.row(6, [
          lt.panel(2, randomPanel('b')),
          lt.panel(2, randomPanel('c')),
          lt.panel(2, randomPanel('d')),
        ]),
        lt.panel(4, randomPanel('e')),
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
    {
      name: 'provider',
      input:: lt.column(8, [randomRow]),
      expected: [{
        gridPos: { h: 8, w: 8, x: 0, y: 0 },
        title: 'layout',
        type: 'timeseries',
      }],
    },
  ],
};

local panelTests = {
  name: 'panel',
  tests: [
    {
      name: 'simple',
      input:: lt.panel(1, randomPanel('a')),
      expected: [{
        gridPos: { h: 1, w: 1, x: 0, y: 0 },
        title: 'a',
        type: 'timeseries',
      }],
    },
    {
      name: 'provider',
      input:: lt.panel(1, random { title: 'a' }),
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

local mixinTests = {
  name: 'mixin',
  tests: [
    {
      name: 'single',
      input:: lt.mixin(
        mixin, lt.panel(1, randomPanel('a')),
      ),
      expected: [{
        datasource: { default: true, type: 'prometheus' },
        gridPos: { h: 1, w: 1, x: 0, y: 0 },
        title: 'a',
        type: 'timeseries',
      }],
    },
    {
      name: 'multiple',
      input:: lt.mixin(
        mixin,
        lt.row(6, [
          lt.panel(2, randomPanel('a')),
          lt.panel(2, randomPanel('b')),
          lt.panel(2, randomPanel('c')),
        ])
      ),
      expected: [
        {
          datasource: { default: true, type: 'prometheus' },
          gridPos: { h: 6, w: 2, x: 0, y: 0 },
          title: 'a',
          type: 'timeseries',
        },
        {
          datasource: { default: true, type: 'prometheus' },
          gridPos: { h: 6, w: 2, x: 2, y: 0 },
          title: 'b',
          type: 'timeseries',
        },
        {
          datasource: { default: true, type: 'prometheus' },
          gridPos: { h: 6, w: 2, x: 4, y: 0 },
          title: 'c',
          type: 'timeseries',
        },
      ],
    },
    {
      name: 'nested',
      input:: lt.column(6, [
        lt.panel(1, randomPanel('a')),
        lt.mixin(
          mixin,
          lt.row(6, [
            lt.panel(2, randomPanel('b')),
            lt.panel(2, randomPanel('c')),
            lt.panel(2, randomPanel('d')),
          ])
        ),
        lt.panel(4, randomPanel('e')),
      ]),
      expected: [
        {
          gridPos: { h: 1, w: 6, x: 0, y: 0 },
          title: 'a',
          type: 'timeseries',
        },
        {
          datasource: { default: true, type: 'prometheus' },
          gridPos: { h: 6, w: 2, x: 0, y: 1 },
          title: 'b',
          type: 'timeseries',
        },
        {
          datasource: { default: true, type: 'prometheus' },
          gridPos: { h: 6, w: 2, x: 2, y: 1 },
          title: 'c',
          type: 'timeseries',
        },
        {
          datasource: { default: true, type: 'prometheus' },
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
    {
      name: 'provider',
      input:: lt.mixin(mixin, randomRow),
      expected: [{
        datasource: { default: true, type: 'prometheus' },
        gridPos: { h: 8, w: 8, x: 0, y: 0 },
        title: 'layout',
        type: 'timeseries',
      }],
    },
  ],
};

{
  output(input): lt.layout(input),
  tests: [
    rowTests,
    columnTests,
    panelTests,
    spaceTests,
    mixinTests,
  ],
}
