local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then val._.ref else '"%s"' % [std.strReplace(val._.str, '\n', '\\n')] else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [std.strReplace(val, '\n', '\\n')] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then '${%s}' % [val._.ref] else val._.str else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  requiredProvider(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.requiredProvider else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), val), {}) else {},
};

local requiredProvider = {
  _: {
    requiredProvider: {
      dolt: {
        source: 'registry.terraform.io/marcbran/dolt',
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
  local name = 'dolt',
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
    repository(name, block): {
      local p = path(['dolt_repository', name]),
      _: p.out._ {
        block: {
          resource: {
            dolt_repository: {
              [name]: std.prune({
                email: build.template(block.email),
                name: build.template(block.name),
                path: build.template(block.path),
              }),
            },
          },
        },
      },
      email: p.child('email').out,
      name: p.child('name').out,
      path: p.child('path').out,
    },
    rowset(name, block): {
      local p = path(['dolt_rowset', name]),
      _: p.out._ {
        block: {
          resource: {
            dolt_rowset: {
              [name]: std.prune({
                author_email: build.template(block.author_email),
                author_name: build.template(block.author_name),
                columns: build.template(block.columns),
                repository_path: build.template(block.repository_path),
                table_name: build.template(block.table_name),
                unique_column: build.template(block.unique_column),
                values: build.template(block.values),
              }),
            },
          },
        },
      },
      author_email: p.child('author_email').out,
      author_name: p.child('author_name').out,
      columns: p.child('columns').out,
      repository_path: p.child('repository_path').out,
      table_name: p.child('table_name').out,
      unique_column: p.child('unique_column').out,
      values: p.child('values').out,
    },
    table(name, block): {
      local p = path(['dolt_table', name]),
      _: p.out._ {
        block: {
          resource: {
            dolt_table: {
              [name]: std.prune({
                author_email: build.template(block.author_email),
                author_name: build.template(block.author_name),
                name: build.template(block.name),
                query: build.template(block.query),
                repository_path: build.template(block.repository_path),
              }),
            },
          },
        },
      },
      author_email: p.child('author_email').out,
      author_name: p.child('author_name').out,
      name: p.child('name').out,
      query: p.child('query').out,
      repository_path: p.child('repository_path').out,
    },
  },
};

provider
