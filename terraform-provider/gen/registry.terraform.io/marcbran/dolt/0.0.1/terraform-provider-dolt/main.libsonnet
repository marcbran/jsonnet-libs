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
      _: p.ref._ {
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
      email: p.child('email').ref,
      name: p.child('name').ref,
      path: p.child('path').ref,
    },
    rowset(name, block): {
      local p = path(['dolt_rowset', name]),
      _: p.ref._ {
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
      author_email: p.child('author_email').ref,
      author_name: p.child('author_name').ref,
      columns: p.child('columns').ref,
      repository_path: p.child('repository_path').ref,
      table_name: p.child('table_name').ref,
      unique_column: p.child('unique_column').ref,
      values: p.child('values').ref,
    },
    table(name, block): {
      local p = path(['dolt_table', name]),
      _: p.ref._ {
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
      author_email: p.child('author_email').ref,
      author_name: p.child('author_name').ref,
      name: p.child('name').ref,
      query: p.child('query').ref,
      repository_path: p.child('repository_path').ref,
    },
  },
};

provider
