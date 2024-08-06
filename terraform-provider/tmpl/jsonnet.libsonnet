{
  bool(val): {
    output: '%s' % [val],
  },
  number(val): {
    output: '%d' % [val],
  },
  string(val): {
    output: "'%s'" % [val],
  },
  err(val): {
    output: "error '%s'" % [val],
  },
  ref(parts): {
    output: if (std.type(parts) == 'string') then parts else std.join('.', parts),
  },
  list(vals): {
    output: '[%s]' % [std.join(
      ' ',
      std.mapWithIndex(
        function(i, val)
          if (i < std.length(vals) - 1)
          then '%s%s' % [val.output, std.get(val, 'end', ',')]
          else val.output,
        vals
      )
    )],
  },
  object(vals): {
    output: '{\n%s}' % [std.join(', ', [val.output for val in vals])],
  },
  field(key, val, visibility=':'): {
    output: '%s%s %s' % [if (std.type(key) == 'string') then key else key.output, visibility, val.output],
  },
  functionSignature(name, parameters): {
    output: '%s(%s)' % [name, std.join(', ', parameters)],
  },
  fieldNameExpression(expr): {
    output: '[%s]' % [expr.output],
  },
  variable(name, val): {
    end: ';',
    output: 'local %s = %s' % [name, val.output],
  },
}
