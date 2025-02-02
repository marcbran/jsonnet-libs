local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then val._.ref else '"%s"' % [std.strReplace(val._.str, '\n', '\\n')] else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [std.strReplace(val, '\n', '\\n')] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then '${%s}' % [val._.ref] else val._.str else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  providerRequirements(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then std.get(val._, 'providerRequirements', {}) else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.providerRequirements(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(element) build.providerRequirements(element), val), {}) else {},
};

local providerTemplate(provider, requirements, configuration) = {
  local providerRequirements = { [provider]: requirements },
  local providerAlias = if configuration == null then null else configuration.alias,
  local providerWithAlias = if configuration == null then null else '%s.%s' % [provider, providerAlias],
  local providerConfiguration = if configuration == null then {} else { [providerWithAlias]: { provider: { [provider]: configuration } } },
  local providerReference = if configuration == null then {} else { provider: providerWithAlias },
  blockType(blockType): {
    local blockTypePath = if blockType == 'resource' then [] else ['data'],
    resource(type, name): {
      local resourceType = std.substr(type, std.length(provider) + 1, std.length(type)),
      local resourcePath = blockTypePath + [type, name],
      _(rawBlock, block): {
        local metaBlock = {
          depends_on: build.template(std.get(rawBlock, 'depends_on', null)),
          count: build.template(std.get(rawBlock, 'count', null)),
          for_each: build.template(std.get(rawBlock, 'for_each', null)),
        },
        type: if std.objectHas(rawBlock, 'for_each') then 'map' else if std.objectHas(rawBlock, 'count') then 'list' else 'object',
        providerRequirements: build.providerRequirements(rawBlock) + providerRequirements,
        providerConfiguration: providerConfiguration,
        provider: provider,
        providerAlias: providerAlias,
        resourceType: resourceType,
        name: name,
        ref: std.join('.', resourcePath),
        block: {
          [blockType]: {
            [type]: {
              [name]: std.prune(metaBlock + block + providerReference),
            },
          },
        },
      },
      field(fieldName): {
        local fieldPath = resourcePath + [fieldName],
        _: {
          ref: std.join('.', fieldPath),
        },
      },
    },
  },
  func(name, parameters=[]): {
    local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
    _: {
      providerRequirements: build.providerRequirements(parameters) + providerRequirements,
      providerConfiguration: providerConfiguration,
      ref: 'provider::%s::%s(%s)' % [provider, name, parameterString],
    },
  },
};

local provider(configuration) = {
  local requirements = {
    source: 'registry.terraform.io/marcbran/jsonnet',
    version: '0.1.0',
  },
  local provider = providerTemplate('jsonnet', requirements, configuration),
  func: {
    evaluate(jsonnet): provider.func('evaluate', [jsonnet]),
  },
};

local providerWithConfiguration = provider(null) + {
  withConfiguration(alias, block): provider(std.prune({
    alias: alias,
  })),
};

providerWithConfiguration
