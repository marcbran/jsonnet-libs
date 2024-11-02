local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then val._.ref else '"%s"' % [val._.str] else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [val] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then '${%s}' % [val._.ref] else val._.str else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  requiredProvider(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.requiredProvider else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), val), {}) else {},
};

local requiredProvider = {
  _: {
    requiredProvider: {
      jsonnet: {
        source: 'registry.terraform.io/marcbran/jsonnet',
        version: '0.0.1',
      },
    },
  },
};

local path(segments) = {
  child(segment): path(segments + [segment]),
  out: requiredProvider { _+: { ref: std.join('.', segments) } },
};

local func(name, parameters=[]) =
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]);
  requiredProvider { _+: { ref: '%s(%s)' % [name, parameterString] } };

local provider = {
  local name = 'jsonnet',
  provider(block): {
    _: {
      block: {
        provider: {
          [name]: std.prune({
            alias: std.get(block, 'alias', null, true),
          }),
        },
      },
    },
  },
  func: {
    evaluate(jsonnet): func('provider::jsonnet::evaluate', [jsonnet]),
  },
};

provider
