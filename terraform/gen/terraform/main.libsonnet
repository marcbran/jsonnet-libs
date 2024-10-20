local build = {
  expression(val):
    if std.type(val) == 'object' then
      if std.objectHas(val, '_')
      then val._.ref
      else std.mapWithKey(function(key, value) self.expression(value), val)
    else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val)
    else if std.type(val) == 'string' then '"%s"' % val
    else val,

  template(val):
    if std.type(val) == 'object' then
      if std.objectHas(val, '_')
      then '${%s}' % val._.ref
      else std.mapWithKey(function(key, value) self.template(value), val)
    else if std.type(val) == 'array' then std.map(function(element) self.template(element), val)
    else if std.type(val) == 'string' then '%s' % val
    else val,
};

local func(name, parameters=[]) = {
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
  _: {
    ref: '%s(%s)' % [name, parameterString],
  },
};

local functions = {
  jsonencode(parameter): func('jsonencode', [parameter]),
  trimprefix(string, prefix): func('trimprefix', [string, prefix]),
  trimsuffix(string, prefix): func('trimsuffix', [string, prefix]),
};

local Variable(name, block) = {
  _: {
    ref: 'var.%s' % [name],
    block: {
      variable: {
        [name]: std.prune({
          default: std.get(block, 'default', null),
          // TODO type constraints
          type: std.get(block, 'type', null),
          description: std.get(block, 'description', null),
          // TODO validation
          sensitive: std.get(block, 'sensitive', null),
          nullable: std.get(block, 'nullable', null),
        }),
      },
    },
  },
};

local Output(name, block) = {
  _: {
    block: {
      output: {
        [name]: std.prune({
          value: build.template(std.get(block, 'value', null)),
          description: std.get(block, 'description', null),
          // TODO precondition
          sensitive: std.get(block, 'sensitive', null),
          nullable: std.get(block, 'nullable', null),
          depends_on: std.get(block, 'depends_on', null),
        }),
      },
    },
  },
};

local Local(name, value) = {
  _: {
    ref: 'local.%s' % [name],
    block: {
      locals: {
        [name]: build.template(value),
      },
    },
  },
};

local Module(name, block) = {
  _: {
    block: {
      module: {
        [name]: block,
      },
    },
  },
};

local extractRequiredProvider(obj) =
  if (std.type(obj) == 'object')
  then
    if (std.objectHas(obj, '_'))
    then std.get(obj._, 'requiredProvider', {})
    else std.foldl(
      function(acc, obj) std.mergePatch(acc, obj),
      std.map(function(key) extractRequiredProvider(obj[key]), std.objectFields(obj)),
      {}
    )
  else if (std.type(obj) == 'array')
  then std.foldl(
    function(acc, obj) std.mergePatch(acc, obj),
    std.map(function(element) extractRequiredProvider(element), obj),
    {}
  )
  else {};

local extractBlocks(obj) =
  if (std.type(obj) == 'object')
  then
    if (std.objectHas(obj, '_'))
    then [std.get(obj._, 'block', {})]
    else std.foldl(
      function(acc, obj) acc + obj,
      std.map(function(key) extractBlocks(obj[key]), std.objectFields(obj)),
      []
    )
  else if (std.type(obj) == 'array')
  then std.foldl(
    function(acc, obj) acc + obj,
    std.map(function(element) extractBlocks(element), obj),
    []
  )
  else [];

local Cfg(resources) =
  local preamble = {
    terraform: {
      required_providers: extractRequiredProvider(resources),
    },
  };
  [preamble] + extractBlocks(resources);

local terraform = functions {
  Variable: Variable,
  Local: Local,
  Output: Output,
  Module: Module,
  Cfg: Cfg,
};

terraform
