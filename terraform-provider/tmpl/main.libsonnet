local j = import 'jsonnet.libsonnet';

local build = j.Local('build', j.Object([
  j.FieldFunc(
    j.String('expression'),
    [j.Id('val')],
    j.If(j.Eq(j.Std.type(j.Id('val')), j.String('object')))
    .Then(
      j.If(j.Std.objectHas(j.Id('val'), j.String('_')))
      .Then(j.Member(j.Member(j.Id('val'), '_'), 'ref'))
      .Else(j.Std.mapWithKey(j.Func([j.Id('key'), j.Id('value')], j.Call(j.Member(j.Self, 'expression'), [j.Id('value')])), j.Id('val')))
    )
    .Else(
      j.If(j.Eq(j.Std.type(j.Id('val')), j.String('array')))
      .Then(j.Std.map(j.Func([j.Id('element')], j.Call(j.Member(j.Self, 'expression'), [j.Id('element')])), j.Id('val')))
      .Else(
        j.If(j.Eq(j.Std.type(j.Id('val')), j.String('string')))
        .Then(j.String('"%s"', [j.Id('val')]))
        .Else(j.Id('val'))
      )
    )
  ),
  j.FieldFunc(
    j.String('template'),
    [j.Id('val')],
    j.If(j.Eq(j.Std.type(j.Id('val')), j.String('object')))
    .Then(
      j.If(j.Std.objectHas(j.Id('val'), j.String('_')))
      .Then(j.String('${%s}', [j.Member(j.Member(j.Id('val'), '_'), 'ref')]))
      .Else(j.Std.mapWithKey(j.Func([j.Id('key'), j.Id('value')], j.Call(j.Member(j.Self, 'template'), [j.Id('value')])), j.Id('val')))
    )
    .Else(
      j.If(j.Eq(j.Std.type(j.Id('val')), j.String('array')))
      .Then(j.Std.map(j.Func([j.Id('element')], j.Call(j.Member(j.Self, 'template'), [j.Id('element')])), j.Id('val')))
      .Else(
        j.If(j.Eq(j.Std.type(j.Id('val')), j.String('string')))
        .Then(j.Id('val'))
        .Else(j.Id('val'))
      )
    )
  ),
], newlines=1));

local path = j.LocalFunc('path', [j.Id('segments')], j.Object([
  j.Field(j.String('ref'), j.Object([
    j.Field(j.String('_'), j.Object([
      j.Field(j.String('ref'), j.Std.join(j.String('.'), j.Id('segments'))),
    ])),
  ])),
  j.FieldFunc(j.String('child'), [j.Id('segment')], j.Call(j.Id('path'), [j.Add(j.Id('segments'), j.Array([j.Id('segment')]))])),
], newlines=1));

local func = j.LocalFunc('func', [j.Id('name'), j.DefaultParam('parameters', j.Array([]))], j.Object([
  j.Local('parameterString', j.Std.join(
    j.String(', '),
    j.ArrayComp(j.Call(j.Member(j.Id('build'), 'expression'), [j.Id('parameter')]))
    .For('parameter', j.Id('parameters'))
  )),
  j.Field(j.String('_'), j.Object([
    j.Field(j.String('ref'), j.String('%s(%s)', [j.Id('name'), j.Id('parameterString')])),
  ])),
], newlines=1));

local providerBlock(schema) = [
  j.FieldFunc(j.String('provider'), [j.Id('block')], j.Object([
    j.Field(j.String('_'), j.Object([
      j.Field(j.String('block'), j.Object([
        j.Field(j.String('provider'), j.Object([
          j.Field(j.FieldNameExpr(j.Id('name')), j.Std.prune(j.Object([
            j.Field(j.String('alias'), j.Std.get(j.Id('block'), j.String('alias'), j.Null)),
          ], newlines=1))),
        ], newlines=1)),
      ], newlines=1)),
    ], newlines=1)),
  ], newlines=1)),
];

local resourceBlock(provider, type, name, pathPrefix, resource) =
  j.FieldFunc(
    j.String(std.substr(name, std.length(provider) + 1, std.length(name))),
    [j.Id('name'), j.Id('block')],
    j.Object([
      j.Local('p', j.Call(j.Id('path'), [j.Array(pathPrefix + [j.String(name), j.Id('name')])])),
      j.Field(j.String('_'), j.Add(
        j.Member(j.Member(j.Id('p'), 'ref'), '_'),
        j.Object([
          j.Field(j.String('block'), j.Object([
            j.Field(j.String(type), j.Object([
              j.Field(j.String(name), j.Object([
                j.Field(
                  j.FieldNameExpr(j.Id('name')),
                  j.Std.prune(j.Object(std.flattenArrays([
                    local attribute = resource.block.attributes[attributeName];
                    if std.get(attribute, 'computed', false) then [] else
                      [
                        j.Field(
                          j.String(attributeName),
                          j.Call(j.Member(j.Id('build'), 'template'), [
                            if std.get(attribute, 'required', false)
                            then j.Member(j.Id('block'), attributeName)
                            else j.Std.get(j.Id('block'), j.String(attributeName), j.Null),
                          ])
                        ),
                        j.Newline,
                      ]
                    for attributeName in std.objectFields(resource.block.attributes)
                  ]), newlines=1)),
                ),
              ], newlines=1)),
            ], newlines=1)),
          ], newlines=1)),
        ], newlines=1)
      )),
    ] + [
      j.Field(j.String(attributeName), j.Member(j.Call(j.Member(j.Id('p'), 'child'), [j.String(attributeName)]), 'ref'))
      for attributeName in std.objectFields(resource.block.attributes)
    ], newlines=1)
  );

local resourceBlocks(provider, type, pathPrefix, resourceSchemas) = if std.length(std.objectFields(resourceSchemas)) == 0 then [] else [
  j.Field(j.String(type), j.Object([
    resourceBlock(provider, type, name, pathPrefix, resourceSchemas[name])
    for name in std.objectFields(resourceSchemas)
  ], newlines=1)),
];

local functionBlock(provider, name, func) =
  j.FieldFunc(
    j.String(name),
    [j.Id(parameter.name) for parameter in func.parameters],
    j.Call(j.Id('func'), [j.String('provider::%s::%s' % [provider, name]), j.Array([j.Id(parameter.name) for parameter in func.parameters])]),
  );

local functionBlocks(provider, functions) = if std.length(std.objectFields(functions)) == 0 then [] else [
  j.Field(j.String('func'), j.Object([
    functionBlock(provider, name, functions[name])
    for name in std.objectFields(functions)
  ], newlines=1)),
];

local terraformProvider(provider, source, schema) =
  local providerSchema = schema.provider_schemas[std.objectFields(schema.provider_schemas)[0]];
  j.Exprs([
    build,
    path,
    func,
    j.Local('provider', j.Object(
      [j.Local('name', j.String(provider))]
      + providerBlock(providerSchema.provider)
      + resourceBlocks(provider, 'resource', [], std.get(providerSchema, 'resource_schemas', {}))
      + resourceBlocks(provider, 'data', [j.String('data')], std.get(providerSchema, 'data_source_schemas', {}))
      + functionBlocks(provider, std.get(providerSchema, 'functions', {})),
      newlines=1
    )),
    j.Id('provider'),
  ], newlines=2).output;

terraformProvider
