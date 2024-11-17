local j = import 'jsonnet.libsonnet';

local build = j.Local('build', j.Object([
  j.FieldFunc(
    j.String('expression'),
    [j.Id('val')],
    j.If(j.Eq(j.Std.type(j.Id('val')), j.String('object')))
    .Then(
      j.If(j.Std.objectHas(j.Id('val'), j.String('_')))
      .Then(
        j.If(j.Std.objectHas(j.Member(j.Id('val'), '_'), j.String('ref')))
        .Then(j.Member(j.Member(j.Id('val'), '_'), 'ref'))
        .Else(j.String('"%s"', [j.Std.strReplace(j.Member(j.Member(j.Id('val'), '_'), 'str'), j.String('\n'), j.String('\\\n'))]))
      )
      .Else(j.Std.mapWithKey(j.Func([j.Id('key'), j.Id('value')], j.Call(j.Member(j.Self, 'expression'), [j.Id('value')])), j.Id('val')))
    )
    .Else(
      j.If(j.Eq(j.Std.type(j.Id('val')), j.String('array')))
      .Then(j.Std.map(j.Func([j.Id('element')], j.Call(j.Member(j.Self, 'expression'), [j.Id('element')])), j.Id('val')))
      .Else(
        j.If(j.Eq(j.Std.type(j.Id('val')), j.String('string')))
        .Then(j.String('"%s"', [j.Std.strReplace(j.Id('val'), j.String('\n'), j.String('\\\n'))]))
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
      .Then(
        j.If(j.Std.objectHas(j.Member(j.Id('val'), '_'), j.String('ref')))
        .Then(j.String('${%s}', [j.Member(j.Member(j.Id('val'), '_'), 'ref')]))
        .Else(j.Member(j.Member(j.Id('val'), '_'), 'str'))
      )
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
  j.FieldFunc(
    j.String('providerRequirements'),
    [j.Id('val')],
    j.If(j.Eq(j.Std.type(j.Id('val')), j.String('object')))
    .Then(
      j.If(j.Std.objectHas(j.Id('val'), j.String('_')))
      .Then(j.Member(j.Member(j.Id('val'), '_'), 'providerRequirements'))
      .Else(j.Std.foldl(
        j.Func([j.Id('acc'), j.Id('val')], j.Std.mergePatch(j.Id('acc'), j.Id('val'))),
        j.Std.map(
          j.Func([j.Id('key')], j.Call(j.Member(j.Id('build'), 'providerRequirements'), [j.Index(j.Id('val'), j.Id('key'))])),
          j.Std.objectFields(j.Id('val'))
        ),
        j.Object([])
      ))
    )
    .Else(
      j.If(j.Eq(j.Std.type(j.Id('val')), j.String('array')))
      .Then(j.Std.foldl(
        j.Func([j.Id('acc'), j.Id('val')], j.Std.mergePatch(j.Id('acc'), j.Id('val'))),
        j.Std.map(
          j.Func([j.Id('key')], j.Call(j.Member(j.Id('build'), 'providerRequirements'), [j.Index(j.Id('val'), j.Id('key'))])),
          j.Id('val')
        ),
        j.Object([])
      ))
      .Else(j.Object([]))
    )
  ),
], newlines=1));

local providerTemplate = j.LocalFunc('providerTemplate', [j.Id('provider'), j.Id('requirements'), j.Id('configuration')], j.Object([
  j.Local('providerRequirements', j.Object([j.Field(j.FieldNameExpr(j.Id('provider')), j.Id('requirements'))])),
  j.Local(
    'providerAlias',
    j.If(j.Eq(j.Id('configuration'), j.Null)).
      Then(j.Null).
      Else(j.Member(j.Id('configuration'), 'alias'))
  ),
  j.Local(
    'providerWithAlias',
    j.If(j.Eq(j.Id('configuration'), j.Null)).
      Then(j.Null).
      Else(j.String('%s.%s', [j.Id('provider'), j.Id('providerAlias')]))
  ),
  j.Local(
    'providerConfiguration',
    j.If(j.Eq(j.Id('configuration'), j.Null)).
      Then(j.Object([])).
      Else(j.Object([
      j.Field(j.FieldNameExpr(j.Id('providerWithAlias')), j.Object([
        j.Field(j.Id('provider'), j.Object([
          j.Field(j.FieldNameExpr(j.Id('provider')), j.Id('configuration')),
        ])),
      ])),
    ]))
  ),
  j.Local(
    'providerReference',
    j.If(j.Eq(j.Id('configuration'), j.Null)).
      Then(j.Object([])).
      Else(j.Object([
      j.Field(j.Id('provider'), j.Id('providerWithAlias')),
    ]))
  ),
  j.FieldFunc(j.Id('blockType'), [j.Id('blockType')], j.Object([
    j.Local(
      'blockTypePath',
      j.If(j.Eq(j.Id('blockType'), j.String('resource'))).Then(j.Array([])).Else(j.Array([j.String('data')]))
    ),
    j.FieldFunc(j.Id('resource'), [j.Id('type'), j.Id('name')], j.Object([
      j.Local('resourceType', j.Std.substr(j.Id('type'), j.Add(j.Std.length(j.Id('provider')), j.Number(1)), j.Std.length(j.Id('type')))),
      j.Local('resourcePath', j.Add(j.Id('blockTypePath'), j.Array([j.Id('type'), j.Id('name')]))),
      j.FieldFunc(j.Id('_'), [j.Id('rawBlock'), j.Id('block')], j.Object([
        j.Local('metaBlock', j.Object([
          j.Field(
            j.String(attributeName),
            j.Call(j.Member(j.Id('build'), 'template'), [
              j.Std.get(j.Id('rawBlock'), j.String(attributeName)).default(j.Null),
            ])
          )
          for attributeName in ['depends_on', 'count', 'for_each']
        ], newlines=1)),
        j.Field(j.Id('providerRequirements'), j.Id('providerRequirements')),
        j.Field(j.Id('providerConfiguration'), j.Id('providerConfiguration')),
        j.Field(j.Id('provider'), j.Id('provider')),
        j.Field(j.Id('providerAlias'), j.Id('providerAlias')),
        j.Field(j.Id('resourceType'), j.Id('resourceType')),
        j.Field(j.Id('name'), j.Id('name')),
        j.Field(j.Id('ref'), j.Std.join(j.String('.'), j.Id('resourcePath'))),
        j.Field(j.Id('block'), j.Object([
          j.Field(j.FieldNameExpr(j.Id('blockType')), j.Object([
            j.Field(j.FieldNameExpr(j.Id('type')), j.Object([
              j.Field(j.FieldNameExpr(j.Id('name')), j.Std.prune(j.Add(j.Add(j.Id('metaBlock'), j.Id('block')), j.Id('providerReference')))),
            ], newlines=1)),
          ], newlines=1)),
        ], newlines=1)),
      ], newlines=1)),
      j.FieldFunc(j.Id('field'), [j.Id('fieldName')], j.Object([
        j.Local('fieldPath', j.Add(j.Id('resourcePath'), j.Array([j.Id('fieldName')]))),
        j.Field(j.Id('_'), j.Object([
          j.Field(j.Id('ref'), j.Std.join(j.String('.'), j.Id('fieldPath'))),
        ], newlines=1)),
      ], newlines=1)),
    ], newlines=1)),
  ], newlines=1)),
  j.FieldFunc(j.Id('func'), [j.Id('name'), j.DefaultParam('parameters', j.Array([]))], j.Object([
    j.Local('parameterString', j.Std.join(
      j.String(', '),
      j.ArrayComp(j.Call(j.Member(j.Id('build'), 'expression'), [j.Id('parameter')]))
      .For('parameter', j.Id('parameters'))
    )),
    j.Field(j.String('_'), j.Object([
      j.Field(j.Id('providerRequirements'), j.Id('providerRequirements')),
      j.Field(j.Id('providerConfiguration'), j.Id('providerConfiguration')),
      j.Field(j.Id('ref'), j.String('provider::%s::%s(%s)', [j.Id('provider'), j.Id('name'), j.Id('parameterString')])),
    ], newlines=1)),
  ], newlines=1)),
], newlines=1));

local resourceBlock(provider, type, name, resource) =
  j.FieldFunc(
    j.String(std.substr(name, std.length(provider) + 1, std.length(name))),
    [j.Id('name'), j.Id('block')],
    j.Object([
      j.Local('resource', j.Call(j.Member(j.Id('blockType'), 'resource'), [j.String(name), j.Id('name')])),
      j.Field(j.String('_'), j.Call(j.Member(j.Id('resource'), '_'), [
        j.Id('block'),
        j.Object(std.flattenArrays([
          local attribute = resource.block.attributes[attributeName];
          if std.get(attribute, 'computed', false) then [] else
            [
              j.Field(
                j.String(attributeName),
                j.Call(j.Member(j.Id('build'), 'template'), [
                  if std.get(attribute, 'required', false)
                  then j.Member(j.Id('block'), attributeName)
                  else j.Std.get(j.Id('block'), j.String(attributeName)).default(j.Null),
                ])
              ),
              j.Newline,
            ]
          for attributeName in std.objectFields(resource.block.attributes)
        ]), newlines=1),
      ])),
    ] + [
      j.Field(j.String(attributeName), j.Call(j.Member(j.Id('resource'), 'field'), [j.String(attributeName)]))
      for attributeName in std.objectFields(resource.block.attributes)
    ], newlines=1)
  );

local resourceBlocks(provider, type, resourceSchemas) = if std.length(std.objectFields(resourceSchemas)) == 0 then [] else [
  j.Field(j.String(type), j.Object([
    j.Local('blockType', j.Call(j.Member(j.Id('provider'), 'blockType'), [j.String(type)])),
  ] + [
    resourceBlock(provider, type, name, resourceSchemas[name])
    for name in std.objectFields(resourceSchemas)
  ], newlines=1)),
];

local functionBlock(name, func) =
  j.FieldFunc(
    j.String(name),
    [j.Id(parameter.name) for parameter in func.parameters],
    j.Call(j.Member(j.Id('provider'), 'func'), [j.String(name), j.Array([j.Id(parameter.name) for parameter in func.parameters])]),
  );

local functionBlocks(functions) = if std.length(std.objectFields(functions)) == 0 then [] else [
  j.Field(j.String('func'), j.Object([
    functionBlock(name, functions[name])
    for name in std.objectFields(functions)
  ], newlines=1)),
];

local providerRequirements(source, version) = j.Local('requirements', j.Object([
  j.Field(j.String('source'), j.String(source)),
  j.Field(j.String('version'), j.String(version)),
], newlines=1));

local providerConfiguration(provider) =
  local attributes = std.get(provider.block, 'attributes', {});
  j.FieldFunc(
    j.Id('withConfiguration'),
    [j.Id('alias'), j.Id('block')],
    j.Call(j.Id('provider'), [j.Std.prune(
      j.Object(std.flattenArrays([[
        j.Field(j.Id('alias'), j.Id('alias')),
      ]] + [
        local attribute = attributes[attributeName];
        if std.get(attribute, 'computed', false) then [] else
          [
            j.Field(
              j.String(attributeName),
              j.Call(j.Member(j.Id('build'), 'template'), [
                if std.get(attribute, 'required', false)
                then j.Member(j.Id('block'), attributeName)
                else j.Std.get(j.Id('block'), j.String(attributeName)).default(j.Null),
              ])
            ),
            j.Newline,
          ]
        for attributeName in std.objectFields(attributes)
      ]), newlines=1),
    )])
  );

local terraformProvider(provider, source, version, schema) =
  local providerSchema = schema.provider_schemas[std.objectFields(schema.provider_schemas)[0]];
  j.Exprs([
    build,
    providerTemplate,
    j.LocalFunc('provider', [j.Id('configuration')], j.Object(
      [
        providerRequirements(source, version),
        j.Local('provider', j.Call(j.Id('providerTemplate'), [j.String(provider), j.Id('requirements'), j.Id('configuration')])),
      ]
      + resourceBlocks(provider, 'resource', std.get(providerSchema, 'resource_schemas', {}))
      + resourceBlocks(provider, 'data', std.get(providerSchema, 'data_source_schemas', {}))
      + functionBlocks(std.get(providerSchema, 'functions', {})),
      newlines=1
    )),
    j.Local('providerWithConfiguration', j.Add(j.Call(j.Id('provider'), [j.Null]), j.Object([
      providerConfiguration(providerSchema.provider),
    ], newlines=1))),
    j.Id('providerWithConfiguration'),
  ], newlines=2).output;

terraformProvider
