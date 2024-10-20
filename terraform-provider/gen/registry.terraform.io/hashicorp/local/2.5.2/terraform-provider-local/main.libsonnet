local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.ref else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [val] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then '${%s}' % [val._.ref] else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
};

local path(segments) = {
  ref: { _: { ref: std.join('.', segments) } },
  child(segment): path(segments + [segment]),
};

local func(name, parameters=[]) = {
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
  _: { ref: '%s(%s)' % [name, parameterString] },
};

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
      _: p.ref._ {
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
      content: p.child('content').ref,
      content_base64: p.child('content_base64').ref,
      content_base64sha256: p.child('content_base64sha256').ref,
      content_base64sha512: p.child('content_base64sha512').ref,
      content_md5: p.child('content_md5').ref,
      content_sha1: p.child('content_sha1').ref,
      content_sha256: p.child('content_sha256').ref,
      content_sha512: p.child('content_sha512').ref,
      directory_permission: p.child('directory_permission').ref,
      file_permission: p.child('file_permission').ref,
      filename: p.child('filename').ref,
      id: p.child('id').ref,
      sensitive_content: p.child('sensitive_content').ref,
      source: p.child('source').ref,
    },
    sensitive_file(name, block): {
      local p = path(['local_sensitive_file', name]),
      _: p.ref._ {
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
      content: p.child('content').ref,
      content_base64: p.child('content_base64').ref,
      content_base64sha256: p.child('content_base64sha256').ref,
      content_base64sha512: p.child('content_base64sha512').ref,
      content_md5: p.child('content_md5').ref,
      content_sha1: p.child('content_sha1').ref,
      content_sha256: p.child('content_sha256').ref,
      content_sha512: p.child('content_sha512').ref,
      directory_permission: p.child('directory_permission').ref,
      file_permission: p.child('file_permission').ref,
      filename: p.child('filename').ref,
      id: p.child('id').ref,
      source: p.child('source').ref,
    },
  },
  data: {
    file(name, block): {
      local p = path(['data', 'local_file', name]),
      _: p.ref._ {
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
      content: p.child('content').ref,
      content_base64: p.child('content_base64').ref,
      content_base64sha256: p.child('content_base64sha256').ref,
      content_base64sha512: p.child('content_base64sha512').ref,
      content_md5: p.child('content_md5').ref,
      content_sha1: p.child('content_sha1').ref,
      content_sha256: p.child('content_sha256').ref,
      content_sha512: p.child('content_sha512').ref,
      filename: p.child('filename').ref,
      id: p.child('id').ref,
    },
    sensitive_file(name, block): {
      local p = path(['data', 'local_sensitive_file', name]),
      _: p.ref._ {
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
      content: p.child('content').ref,
      content_base64: p.child('content_base64').ref,
      content_base64sha256: p.child('content_base64sha256').ref,
      content_base64sha512: p.child('content_base64sha512').ref,
      content_md5: p.child('content_md5').ref,
      content_sha1: p.child('content_sha1').ref,
      content_sha256: p.child('content_sha256').ref,
      content_sha512: p.child('content_sha512').ref,
      filename: p.child('filename').ref,
      id: p.child('id').ref,
    },
  },
  func: {
    direxists(path): func('provider::local::direxists', [path]),
  },
};

provider
