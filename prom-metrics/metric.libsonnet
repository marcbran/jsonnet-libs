local metric(name) = {
  local eq(value) = {
    output(field): '%s%s"%s"' % [field, '=', value],
  },
  local labels = [[field, self[field]] for field in std.sort(std.objectFields(self)) if field != 'output'],
  local comparisons = [[label[0], if std.type(label[1]) == 'string' then eq(label[1]) else label[1]] for label in labels],
  local filters = [comparison[1].output(comparison[0]) for comparison in comparisons],
  local filterString = std.join(', ', filters),
  output: if (std.length(filterString) > 0) then '%s{%s}' % [name, filterString] else name,
};

metric
