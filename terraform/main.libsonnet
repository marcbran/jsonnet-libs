local build = {
  expression(val):
    if std.type(val) == 'object' then
      if std.objectHas(val, '_')
      then
        if std.objectHas(val._, 'ref')
        then val._.ref
        else '"%s"' % val._.str
      else '{%s}' % std.join(',', std.map(function(key) '%s:%s' % [self.expression(key), self.expression(val[key])], std.objectFields(val)))
    else if std.type(val) == 'array' then '[%s]' % std.join(',', std.map(function(element) self.expression(element), val))
    else if std.type(val) == 'string' then '"%s"' % val
    else '%s' % val,

  template(val):
    if std.type(val) == 'object' then
      if std.objectHas(val, '_')
      then
        if std.objectHas(val._, 'ref')
        then std.strReplace(self.string(val), '\n', '\\n')
        else val._.str
      else std.mapWithKey(function(key, value) self.template(value), val)
    else if std.type(val) == 'array' then std.map(function(element) self.template(element), val)
    else if std.type(val) == 'string' then std.strReplace(self.string(val), '\n', '\\n')
    else val,

  string(val):
    if std.type(val) == 'object' then
      if std.objectHas(val, '_')
      then
        if std.objectHas(val._, 'ref')
        then '${%s}' % val._.ref
        else val._.str
      else '${%s}' % self.expression(val)
    else if std.type(val) == 'array' then '${%s}' % self.expression(val)
    else if std.type(val) == 'string' then val
    else val,

  providerRequirements(val):
    if (std.type(val) == 'object')
    then
      if (std.objectHas(val, '_'))
      then std.get(val._, 'providerRequirements', {})
      else std.foldl(
        function(acc, val) std.mergePatch(acc, val),
        std.map(function(key) build.providerRequirements(val[key]), std.objectFields(val)),
        {}
      )
    else if (std.type(val) == 'array')
    then std.foldl(
      function(acc, val) std.mergePatch(acc, val),
      std.map(function(element) build.providerRequirements(element), val),
      {}
    )
    else {},

  providerConfiguration(val):
    if (std.type(val) == 'object')
    then
      if (std.objectHas(val, '_'))
      then std.get(val._, 'providerConfiguration', {})
      else std.foldl(
        function(acc, val) std.mergePatch(acc, val),
        std.map(function(key) build.providerConfiguration(val[key]), std.objectFields(val)),
        {}
      )
    else if (std.type(val) == 'array')
    then std.foldl(
      function(acc, val) std.mergePatch(acc, val),
      std.map(function(element) build.providerConfiguration(element), val),
      {}
    )
    else {},
};

local Format(string, values) = {
  _: {
    providerRequirements: build.providerRequirements(values),
    str: string % [build.template(value) for value in values],
  },
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
    providerRequirements: build.providerRequirements(block),
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
    providerRequirements: build.providerRequirements(value),
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

local Each = {
  key: {
    _: {
      ref: 'each.key',
    },
  },
  value: {
    _: {
      ref: 'each.value',
    },
  },
};

local operators = {
  local binaryOp(a, op, b) = {
    _: {
      ref: '%s %s %s' % [build.expression(a), op, build.expression(b)],
    },
  },
  mul(a, b): binaryOp(a, '*', b),
  div(a, b): binaryOp(a, '/', b),
  mod(a, b): binaryOp(a, '%', b),
  add(a, b): binaryOp(a, '+', b),
  sub(a, b): binaryOp(a, '-', b),
  lt(a, b): binaryOp(a, '<', b),
  lte(a, b): binaryOp(a, '<=', b),
  gt(a, b): binaryOp(a, '>', b),
  gte(a, b): binaryOp(a, '>=', b),
  eq(a, b): binaryOp(a, '==', b),
  neq(a, b): binaryOp(a, '!=', b),
  logicalAnd(a, b): binaryOp(a, '&&', b),
  logicalOr(a, b): binaryOp(a, '||', b),
  local unaryOp(a, op) = {
    _: {
      ref: '%s%s' % [op, build.expression(a)],
    },
  },
  neg(a): unaryOp(a, '-'),
};

local If(condition) = {
  local conditionString = build.expression(condition),
  Then(trueVal): {
    local trueValString = build.expression(trueVal),
    Else(falseVal): {
      local falseValString = build.expression(falseVal),
      _: {
        ref: '%s ? %s : %s' % [conditionString, trueValString, falseValString],
      },
    },
  },
};

local For(keyIdVal, val=null) = {
  local parameters = [{ _: { ref: parameter } } for parameter in std.prune([keyIdVal, val])],
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
  In(collection): {
    local collectionString = build.expression(collection),
    List(valueProvider): {
      local value =
        if std.length(parameters) == 1
        then valueProvider(parameters[0])
        else valueProvider(parameters[0], parameters[1]),
      local valueString = build.expression(value),
      _: {
        ref: '[for %s in %s: %s]' % [parameterString, collectionString, valueString],
      },
    },
    Map(keyValueProvider): {
      local keyValue =
        if std.length(parameters) == 1
        then keyValueProvider(parameters[0])
        else keyValueProvider(parameters[0], parameters[1]),
      local keyValueString = '%s => %s' % [build.expression(keyValue[0]), build.expression(keyValue[1])],
      _: {
        ref: '{for %s in %s: %s }' % [parameterString, collectionString, keyValueString],
      },
    },
  },
};

local func(name, parameters=[]) = {
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
  _: {
    providerRequirements: build.providerRequirements(parameters),
    ref: '%s(%s)' % [name, parameterString],
  },
};

local functions = {
  // Numeric Functions
  abs(number): func('abs', [number]),
  ceil(number): func('ceil', [number]),
  floor(number): func('floor', [number]),
  log(number, base): func('log', [number, base]),
  max(values): func('max', values),
  min(values): func('min', values),
  parseint(string, base): func('parseint', [string, base]),
  pow(base, exponent): func('pow', [base, exponent]),
  signum(number): func('signum', [number]),

  // String Functions
  chomp(string): func('chomp', [string]),
  endswith(string, suffix): func('endswith', [string, suffix]),
  format(spec, values): func('format', [spec] + values),
  formatlist(spec, values): func('formatlist', [spec] + values),
  indent(num_spaces, string): func('indent', [num_spaces, string]),
  join(separator, list): func('join', [separator, list]),
  lower(string): func('lower', [string]),
  regex(pattern, string): func('regex', [pattern, string]),
  regexall(pattern, string): func('regexall', [pattern, string]),
  replace(string, substring, replacement): func('replace', [string, substring, replacement]),
  split(separator, string): func('split', [separator, string]),
  startswith(string, prefix): func('startswith', [string, prefix]),
  strcontains(string, substr): func('strcontains', [string, substr]),
  strrev(string): func('strrev', [string]),
  substr(string, offset, length): func('substr', [string, offset, length]),
  templatestring(ref, vars): func('templatestring', [ref, vars]),
  title(string): func('title', [string]),
  trim(string, str_character_set): func('trim', [string, str_character_set]),
  trimprefix(string, prefix): func('trimprefix', [string, prefix]),
  trimsuffix(string, prefix): func('trimsuffix', [string, prefix]),
  trimspace(string): func('trimspace', [string]),
  upper(string): func('upper', [string]),

  // Collection Functions
  alltrue(list): func('alltrue', [list]),
  anytrue(list): func('anytrue', [list]),
  chunklist(list, chunk_size): func('chunklist', [list, chunk_size]),
  coalesce(values): func('coalesce', values),
  coalescelist(values): func('coalescelist', values),
  compact(list): func('compact', [list]),
  concat(lists): func('concat', lists),
  contains(list, value): func('contains', [list, value]),
  distinct(list): func('distinct', [list]),
  element(list, index): func('element', [list, index]),
  flatten(list): func('flatten', [list]),
  index(list, value): func('index', [list, value]),
  keys(map): func('keys', [map]),
  length(list): func('length', [list]),
  lookup(map, key, default): func('lookup', [map, key, default]),
  matchkeys(valueslist, keyslist, searchset): func('matchkeys', [valueslist, keyslist, searchset]),
  merge(maps): func('merge', maps),
  one(val): func('one', [val]),
  // TODO range
  reverse(list): func('reverse', [list]),
  setintersection(sets): func('setintersection', sets),
  setproduct(sets): func('setproduct', sets),
  setsubtract(a, b): func('setsubtract', [a, b]),
  setunion(sets): func('setunion', sets),
  slice(list, startindex, endindex): func('slice', [list, startindex, endindex]),
  sort(list): func('sort', [list]),
  sum(list): func('sum', [list]),
  transpose(map): func('transpose', [map]),
  values(map): func('values', [map]),
  zipmap(keyslist, valueslist): func('zipmap', [keyslist, valueslist]),

  // Encoding Functions
  base64decode(string): func('base64decode', [string]),
  base64encode(string): func('base64encode', [string]),
  base64gzip(val): func('base64gzip', [val]),
  csvdecode(string): func('csvdecode', [string]),
  jsondecode(string): func('jsondecode', [string]),
  jsonencode(val): func('jsonencode', [val]),
  textdecodebase64(string, encoding_name): func('textdecodebase64', [string, encoding_name]),
  textencodebase64(string, encoding_name): func('textencodebase64', [string, encoding_name]),
  urlencode(string): func('urlencode', [string]),
  yamldecode(string): func('yamldecode', [string]),
  yamlencode(val): func('yamlencode', [val]),

  // Filesytem Functions
  abspath(path): func('abspath', [path]),
  dirname(path): func('dirname', [path]),
  pathexpand(path): func('pathexpand', [path]),
  basename(path): func('basename', [path]),
  file(path): func('file', [path]),
  fileexists(path): func('fileexists', [path]),
  fileset(path, pattern): func('fileset', [path, pattern]),
  filebase64(path): func('filebase64', [path]),
  templatefile(path, vars): func('templatefile', [path, vars]),

  // Date and Time Functions
  formatdate(spec, timestamp): func('formatdate', [spec, timestamp]),
  plantimestamp(): func('plantimestamp', []),
  timeadd(timestamp, duration): func('timeadd', [timestamp, duration]),
  timecmp(timestamp_a, timestamp_b): func('timecmp', [timestamp_a, timestamp_b]),
  timestamp(): func('timestamp', []),

  // Hash and Crypto Functions
  base64sha256(string): func('base64sha256', [string]),
  base64sha512(string): func('base64sha512', [string]),
  bcrypt(string, cost): func('bcrypt', [string, cost]),
  filebase64sha256(path): func('filebase64sha256', [path]),
  filebase64sha512(path): func('filebase64sha512', [path]),
  filemd5(path): func('filemd5', [path]),
  filesha1(path): func('filesha1', [path]),
  filesha256(path): func('filesha256', [path]),
  filesha512(path): func('filesha512', [path]),
  md5(string): func('md5', [string]),
  rsadecrypt(ciphertext, privatekey): func('rsadecrypt', [ciphertext, privatekey]),
  sha1(string): func('sha1', [string]),
  sha256(string): func('sha256', [string]),
  sha512(string): func('sha512', [string]),
  uuid(): func('uuid', []),
  uuidv5(namespace, name): func('uuidv5', [namespace, name]),

  // IP Network Functions
  cidrhost(prefix, hostnum): func('cidrhost', [prefix, hostnum]),
  cidrnetmask(prefix): func('cidrnetmask', [prefix]),
  cidrsubnet(prefix, newbits, netnum): func('cidrsubnet', [prefix, newbits, netnum]),
  cidrsubnets(prefix, newbits): func('cidrsubnets', [prefix] + newbits),

  // Type Conversion Functions
  can(val): func('can', [val]),
  issensitive(val): func('issensitive', [val]),
  nonsensitive(val): func('nonsensitive', [val]),
  sensitive(val): func('sensitive', [val]),
  tobool(val): func('tobool', [val]),
  tolist(val): func('tolist', [val]),
  tomap(val): func('tomap', [val]),
  tonumber(val): func('tonumber', [val]),
  toset(val): func('toset', [val]),
  tostring(val): func('tostring', [val]),
  try(val, fallback): func('try', [val, fallback]),
  type(val): func('type', [val]),
};

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
  local preamble = [{
    terraform: {
      required_providers: build.providerRequirements(resources),
    },
  }] + std.objectValues(build.providerConfiguration(resources));
  preamble + extractBlocks(resources);

local terraform = functions + operators + {
  build: build,
  Format: Format,
  Variable: Variable,
  Local: Local,
  Output: Output,
  Module: Module,
  Cfg: Cfg,
  Each: Each,
  If: If,
  For: For,
};

terraform
