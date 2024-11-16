local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then val._.ref else '"%s"' % [std.strReplace(val._.str, '\n', '\\n')] else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [std.strReplace(val, '\n', '\\n')] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then '${%s}' % [val._.ref] else val._.str else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  providerRequirements(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.providerRequirements else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.providerRequirements(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.providerRequirements(val[key]), val), {}) else {},
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
      _(block): {
        providerRequirements: providerRequirements,
        providerConfiguration: providerConfiguration,
        provider: provider,
        providerAlias: providerAlias,
        resourceType: resourceType,
        name: name,
        ref: std.join('.', resourcePath),
        block: {
          [blockType]: {
            [type]: {
              [name]: std.prune(block + providerReference),
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
      providerRequirements: providerRequirements,
      providerConfiguration: providerConfiguration,
      ref: 'provider::%s::%s(%s)' % [provider, name, parameterString],
    },
  },
};

local provider(configuration) = {
  local requirements = {
    source: 'registry.terraform.io/hashicorp/local',
    version: '2.5.2',
  },
  local provider = providerTemplate('local', requirements, configuration),
  resource: {
    local blockType = provider.blockType('resource'),
    file(name, block): {
      local resource = blockType.resource('local_file', name),
      _: resource._({
        content: build.template(std.get(block, 'content', null)),
        content_base64: build.template(std.get(block, 'content_base64', null)),
        filename: build.template(block.filename),
        sensitive_content: build.template(std.get(block, 'sensitive_content', null)),
        source: build.template(std.get(block, 'source', null)),
      }),
      content: resource.field('content'),
      content_base64: resource.field('content_base64'),
      content_base64sha256: resource.field('content_base64sha256'),
      content_base64sha512: resource.field('content_base64sha512'),
      content_md5: resource.field('content_md5'),
      content_sha1: resource.field('content_sha1'),
      content_sha256: resource.field('content_sha256'),
      content_sha512: resource.field('content_sha512'),
      directory_permission: resource.field('directory_permission'),
      file_permission: resource.field('file_permission'),
      filename: resource.field('filename'),
      id: resource.field('id'),
      sensitive_content: resource.field('sensitive_content'),
      source: resource.field('source'),
    },
    sensitive_file(name, block): {
      local resource = blockType.resource('local_sensitive_file', name),
      _: resource._({
        content: build.template(std.get(block, 'content', null)),
        content_base64: build.template(std.get(block, 'content_base64', null)),
        filename: build.template(block.filename),
        source: build.template(std.get(block, 'source', null)),
      }),
      content: resource.field('content'),
      content_base64: resource.field('content_base64'),
      content_base64sha256: resource.field('content_base64sha256'),
      content_base64sha512: resource.field('content_base64sha512'),
      content_md5: resource.field('content_md5'),
      content_sha1: resource.field('content_sha1'),
      content_sha256: resource.field('content_sha256'),
      content_sha512: resource.field('content_sha512'),
      directory_permission: resource.field('directory_permission'),
      file_permission: resource.field('file_permission'),
      filename: resource.field('filename'),
      id: resource.field('id'),
      source: resource.field('source'),
    },
  },
  data: {
    local blockType = provider.blockType('data'),
    file(name, block): {
      local resource = blockType.resource('local_file', name),
      _: resource._({
        filename: build.template(block.filename),
      }),
      content: resource.field('content'),
      content_base64: resource.field('content_base64'),
      content_base64sha256: resource.field('content_base64sha256'),
      content_base64sha512: resource.field('content_base64sha512'),
      content_md5: resource.field('content_md5'),
      content_sha1: resource.field('content_sha1'),
      content_sha256: resource.field('content_sha256'),
      content_sha512: resource.field('content_sha512'),
      filename: resource.field('filename'),
      id: resource.field('id'),
    },
    sensitive_file(name, block): {
      local resource = blockType.resource('local_sensitive_file', name),
      _: resource._({
        filename: build.template(block.filename),
      }),
      content: resource.field('content'),
      content_base64: resource.field('content_base64'),
      content_base64sha256: resource.field('content_base64sha256'),
      content_base64sha512: resource.field('content_base64sha512'),
      content_md5: resource.field('content_md5'),
      content_sha1: resource.field('content_sha1'),
      content_sha256: resource.field('content_sha256'),
      content_sha512: resource.field('content_sha512'),
      filename: resource.field('filename'),
      id: resource.field('id'),
    },
  },
  func: {
    direxists(path): provider.func('direxists', [path]),
  },
};

local providerWithConfiguration = provider(null) + {
  withConfiguration(alias, block): provider(std.prune({
    alias: alias,
  })),
};

providerWithConfiguration
