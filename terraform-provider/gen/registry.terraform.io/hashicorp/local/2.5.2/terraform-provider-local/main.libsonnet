local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then val._.ref else '"%s"' % [val._.str] else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [val] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then '${%s}' % [val._.ref] else val._.str else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  requiredProvider(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.requiredProvider else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), val), {}) else {},
};

local requiredProvider = {
  _: {
    requiredProvider: {
      'local': {
        source: 'registry.terraform.io/hashicorp/local',
        version: '2.5.2',
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
  local name = 'local',
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
  resource: {
    file(name, block): {
      local p = path(['local_file', name]),
      _: p.out._ {
        block: {
          resource: {
            local_file: {
              [name]: std.prune({
                content: build.template(std.get(block, 'content', null, true)),
                content_base64: build.template(std.get(block, 'content_base64', null, true)),
                filename: build.template(block.filename),
                sensitive_content: build.template(std.get(block, 'sensitive_content', null, true)),
                source: build.template(std.get(block, 'source', null, true)),
              }),
            },
          },
        },
      },
      content: p.child('content').out,
      content_base64: p.child('content_base64').out,
      content_base64sha256: p.child('content_base64sha256').out,
      content_base64sha512: p.child('content_base64sha512').out,
      content_md5: p.child('content_md5').out,
      content_sha1: p.child('content_sha1').out,
      content_sha256: p.child('content_sha256').out,
      content_sha512: p.child('content_sha512').out,
      directory_permission: p.child('directory_permission').out,
      file_permission: p.child('file_permission').out,
      filename: p.child('filename').out,
      id: p.child('id').out,
      sensitive_content: p.child('sensitive_content').out,
      source: p.child('source').out,
    },
    sensitive_file(name, block): {
      local p = path(['local_sensitive_file', name]),
      _: p.out._ {
        block: {
          resource: {
            local_sensitive_file: {
              [name]: std.prune({
                content: build.template(std.get(block, 'content', null, true)),
                content_base64: build.template(std.get(block, 'content_base64', null, true)),
                filename: build.template(block.filename),
                source: build.template(std.get(block, 'source', null, true)),
              }),
            },
          },
        },
      },
      content: p.child('content').out,
      content_base64: p.child('content_base64').out,
      content_base64sha256: p.child('content_base64sha256').out,
      content_base64sha512: p.child('content_base64sha512').out,
      content_md5: p.child('content_md5').out,
      content_sha1: p.child('content_sha1').out,
      content_sha256: p.child('content_sha256').out,
      content_sha512: p.child('content_sha512').out,
      directory_permission: p.child('directory_permission').out,
      file_permission: p.child('file_permission').out,
      filename: p.child('filename').out,
      id: p.child('id').out,
      source: p.child('source').out,
    },
  },
  data: {
    file(name, block): {
      local p = path(['data', 'local_file', name]),
      _: p.out._ {
        block: {
          data: {
            local_file: {
              [name]: std.prune({
                filename: build.template(block.filename),
              }),
            },
          },
        },
      },
      content: p.child('content').out,
      content_base64: p.child('content_base64').out,
      content_base64sha256: p.child('content_base64sha256').out,
      content_base64sha512: p.child('content_base64sha512').out,
      content_md5: p.child('content_md5').out,
      content_sha1: p.child('content_sha1').out,
      content_sha256: p.child('content_sha256').out,
      content_sha512: p.child('content_sha512').out,
      filename: p.child('filename').out,
      id: p.child('id').out,
    },
    sensitive_file(name, block): {
      local p = path(['data', 'local_sensitive_file', name]),
      _: p.out._ {
        block: {
          data: {
            local_sensitive_file: {
              [name]: std.prune({
                filename: build.template(block.filename),
              }),
            },
          },
        },
      },
      content: p.child('content').out,
      content_base64: p.child('content_base64').out,
      content_base64sha256: p.child('content_base64sha256').out,
      content_base64sha512: p.child('content_base64sha512').out,
      content_md5: p.child('content_md5').out,
      content_sha1: p.child('content_sha1').out,
      content_sha256: p.child('content_sha256').out,
      content_sha512: p.child('content_sha512').out,
      filename: p.child('filename').out,
      id: p.child('id').out,
    },
  },
  func: {
    direxists(path): func('provider::local::direxists', [path]),
  },
};

provider
