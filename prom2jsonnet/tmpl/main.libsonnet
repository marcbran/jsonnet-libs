local j = import 'jsonnet.libsonnet';

local metric = j.LocalFunc('metric', [j.Id('name'), j.Id('type'), j.Id('help')], j.Object([
  j.Local('metric', j.Self),
  j.LocalFunc(
    'eq',
    [j.Id('value')],
    j.Object([
      j.FieldFunc(j.Id('expr'), [j.Id('field')], j.String('%s%s"%s"', [j.Id('field'), j.String('='), j.Id('value')])),
    ])
  ),
  j.Field(
    j.Id('_'),
    j.Object([
      j.Field(j.Id('kind'), j.String('metric')),
      j.Field(j.Id('metric'), j.Id('name')),
      j.Field(j.Id('type'), j.Id('type')),
      j.Field(j.Id('help'), j.Id('help')),
      j.Field(
        j.Id('rawMatchers'),
        j.ObjectComp([j.KeyValue(j.Id('field'), j.Index(j.Id('metric'), j.Id('field')))]).
          For('field', j.Std.objectFields(j.Id('metric'))).
          If(j.Neq(j.Id('field'), j.String('_')))
      ),
      j.FieldFunc(
        j.Id('match'),
        [j.Id('matchers')],
        j.Add(j.Id('metric'), j.Object([
          j.Field(j.Id('_'), j.Object([
            j.Field(j.Id('rawMatchers'), j.Id('matchers'), override='+'),
          ]), override='+'),
        ])),
      ),
      j.Field(
        j.Id('expr'),
        j.Exprs([
          j.Local(
            'labels',
            j.ArrayComp(j.Array([j.Id('field'), j.Index(j.Member(j.Self, 'rawMatchers'), j.Id('field'))])).
              For('field', j.Call(j.Member(j.Id('std'), 'sort'), [
              j.Call(j.Member(j.Id('std'), 'objectFields'), [j.Member(j.Self, 'rawMatchers')]),
            ]))
          ),
          j.Local(
            'operators',
            j.ArrayComp(j.Array([
              j.Index(j.Id('label'), j.Number(0)),
              j.If(j.Eq(j.Call(j.Member(j.Id('std'), 'type'), [j.Index(j.Id('label'), j.Number(1))]), j.String('object'))).
                Then(j.Index(j.Id('label'), j.Number(1))).
                Else(j.Call(j.Id('eq'), [j.Index(j.Id('label'), j.Number(1))])),
            ])).
              For('label', j.Id('labels'))
          ),
          j.Local(
            'matchers',
            j.ArrayComp(
              j.Call(j.Member(j.Index(j.Id('operator'), j.Number(1)), 'expr'), [j.Index(j.Id('operator'), j.Number(0))]),
            ).
              For('operator', j.Id('operators'))
          ),
          j.Local(
            'matcherString',
            j.Call(j.Member(j.Id('std'), 'join'), [j.String(', '), j.Id('matchers')])
          ),
          j.If(j.Gt(j.Call(j.Member(j.Id('std'), 'length'), [j.Id('matcherString')]), j.Number(0))).
            Then(j.String('%s{%s}', [j.Id('name'), j.Id('matcherString')])).
            Else(j.Id('name')),
        ], newlines=1, prefixNewlines=1),
      ),
    ], newlines=1),
  ),
], newlines=1));

local prom2jsonnet(metrics, prefix) =
  j.Exprs([
    metric,
    j.Local(prefix, j.Object(std.flattenArrays([
      [
        j.Comment('TYPE %s' % std.asciiLower(metric.type)),
        j.Comment('HELP %s' % metric.help),
        j.Field(
          j.String(std.substr(metric.name, std.length(prefix) + 1, std.length(metric.name))),
          j.Call(j.Id('metric'), [
            j.String(metric.name),
            j.String(metric.type),
            j.String(std.strReplace(metric.help, "'", '')),
          ])
        ),
        j.Newline,
        j.Newline,
      ]
      for metric in metrics
      if std.startsWith(metric.name, prefix)
    ]), newlines=1)),
    j.Id(prefix),
  ], newlines=2).output;

prom2jsonnet
