local printNewline(newline) = if (newline) then '\n' else ' ';

local printNewlines(newlines) = std.join('', std.map(function(index) '\n', std.range(1, newlines)));

local joinExpr(sep, exprs) = std.join(sep, [expr.output for expr in exprs]);

{
  Null: {
    output: 'null',
  },
  True: {
    output: 'true',
  },
  False: {
    output: 'false',
  },
  Self: {
    output: 'self',
  },
  Outer: {
    output: '$',
  },
  Super: {
    output: 'super',
  },
  String(val, format=[]): {
    output:
      if std.length(format) == 0
      then "'%s'" % [val]
      else "'%s' %% [%s]" % [val, joinExpr(', ', format)],
  },
  Number(val, format='%d'): {
    output: format % [val],
  },
  Id(id): {
    output: '%s' % [id],
  },
  Member(expr, id): {
    output: '%s.%s' % [expr.output, id],
  },
  Index(expr, index): {
    output: '%s[%s]' % [expr.output, index.output],
  },
  Func(params, expr): {
    output: 'function(%s) %s' % [joinExpr(', ', params), expr.output],
  },
  DefaultParam(id, expr): {
    output: '%s=%s' % [id, expr.output],
  },
  Call(expr, params): {
    output: '%s(%s)' % [expr.output, joinExpr(', ', params)],
  },
  NamedParam(id, expr): {
    output: '%s=%s' % [id, expr.output],
  },
  Object(members, newlines=0): {
    output: '{%s%s}' % [printNewlines(newlines), std.join(
      '',
      std.mapWithIndex(
        function(i, member)
          if (i < std.length(members) - 1)
          then '%s%s' % [member.output, std.get(member, 'sep', ', ')]
          else member.output,
        members
      )
    )],
  },
  Field(name, expr, override='', hidden=':', newline=false): {
    output: '%s%s%s%s%s' % [name.output, override, hidden, printNewline(newline), expr.output],
  },
  FieldFunc(name, params, expr, hidden=':', newline=false): {
    output: '%s(%s)%s%s%s' % [name.output, joinExpr(', ', params), hidden, printNewline(newline), expr.output],
  },
  FieldNameExpr(expr): {
    output: '[%s]' % [expr.output],
  },
  ObjectComp(exprs): {
    local objectCompExprs = exprs,
    local forSpec(id, expr) = {
      output: 'for %s in %s' % [id, expr.output],
    },
    local ifSpec(expr) = {
      output: 'if %s' % [expr.output],
    },
    local compspec(comps) = {
      output: '{%s %s}' % [joinExpr(', ', objectCompExprs), joinExpr(' ', comps)],
      For(id, expr): compspec(comps + [forSpec(id, expr)]),
      If(expr): compspec(comps + [ifSpec(expr)]),
    },
    For(id, expr): compspec([forSpec(id, expr)]),
  },
  KeyValue(key, value): {
    output: '[%s]: %s' % [key.output, value.output],
  },
  Array(exprs, newlines=0): {
    output: '[%s%s]' % [printNewlines(newlines), std.join(
      '',
      std.mapWithIndex(
        function(i, expr)
          if (i < std.length(exprs) - 1)
          then '%s%s' % [expr.output, std.get(expr, 'arraySep', std.get(expr, 'sep', ', '))]
          else expr.output,
        exprs
      )
    )],
  },
  ArrayComp(expr): {
    local arrayCompExpr = expr,
    local forSpec(id, expr) = {
      output: 'for %s in %s' % [id, expr.output],
    },
    local ifSpec(expr) = {
      output: 'if %s' % [expr.output],
    },
    local compspec(comps) = {
      output: '[%s %s]' % [arrayCompExpr.output, joinExpr(' ', comps)],
      For(id, expr): compspec(comps + [forSpec(id, expr)]),
      If(expr): compspec(comps + [ifSpec(expr)]),
    },
    For(id, expr): compspec([forSpec(id, expr)]),
  },
  Local(id, expr, newline=false): {
    output: 'local %s =%s%s' % [id, printNewline(newline), expr.output],
    arraySep: '; ',
  },
  LocalFunc(id, params, expr, newline=false): {
    output: 'local %s(%s) =%s%s' % [id, joinExpr(', ', params), printNewline(newline), expr.output],
    arraySep: '; ',
  },
  If(expr, newlineAfter=false): {
    local ifExpr = expr,
    local ifNewlineAfter = printNewline(newlineAfter),
    Then(expr, newlineBefore=false, newlineAfter=false): {
      local thenExpr = expr,
      local thenNewlineBefore = printNewline(newlineBefore),
      local thenNewlineAfter = printNewline(newlineAfter),
      output: std.join('', ['if', ifNewlineAfter, ifExpr.output, thenNewlineBefore, 'then', thenNewlineAfter, thenExpr.output]),
      Else(expr, newlineBefore=false, newlineAfter=false): {
        local elseExpr = expr,
        local elseNewlineBefore = printNewline(newlineBefore),
        local elseNewlineAfter = printNewline(newlineAfter),
        output: std.join('', ['if', ifNewlineAfter, ifExpr.output, thenNewlineBefore, 'then', thenNewlineAfter, thenExpr.output, elseNewlineBefore, 'else', elseNewlineAfter, elseExpr.output]),
      },
    },
  },
  Error(expr): {
    output: 'error %s' % [expr.output],
  },
  Assert(expr, msg): {
    output: 'assert %s: %s' % [expr.output, msg.output],
  },
  SuperCheck(expr): {
    output: '%s in super' % [expr.output],
  },
  Import(string): {
    output: "import '%s'" % [string],
  },
  ImportStr(string): {
    output: "importstr '%s'" % [string],
  },
  ImportBin(string): {
    output: "importbin '%s'" % [string],
  },
  Comment(string): {
    output: '// %s' % [string],
    sep: '\n',
  },
  Newline: {
    output: '',
    sep: '\n',
  },
  Exprs(exprs, newlines=0, prefixNewlines=0): {
    local newlinesString = if newlines == 0 then '' else std.join('', ['\n' for _ in std.range(1, newlines)]),
    local prefixNewlinesString = if prefixNewlines == 0 then '' else std.join('', ['\n' for _ in std.range(1, prefixNewlines)]),
    output: prefixNewlinesString + std.join(
      '',
      std.mapWithIndex(
        function(i, expr)
          if (i < std.length(exprs) - 1)
          then '%s%s%s' % [expr.output, std.get(expr, 'sep', ';'), newlinesString]
          else expr.output,
        exprs
      )
    ),
  },
  BinaryOp(a, op, b): {
    output: '%s %s %s' % [a.output, op, b.output],
  },
  Mul(a, b): self.BinaryOp(a, '*', b),
  Div(a, b): self.BinaryOp(a, '/', b),
  Mod(a, b): self.BinaryOp(a, '%', b),
  Add(a, b): self.BinaryOp(a, '+', b),
  Sub(a, b): self.BinaryOp(a, '-', b),
  LShift(a, b): self.BinaryOp(a, '<<', b),
  RShift(a, b): self.BinaryOp(a, '>>', b),
  Lt(a, b): self.BinaryOp(a, '<', b),
  Lte(a, b): self.BinaryOp(a, '<=', b),
  Gt(a, b): self.BinaryOp(a, '>', b),
  Gte(a, b): self.BinaryOp(a, '>=', b),
  Eq(a, b): self.BinaryOp(a, '==', b),
  Neq(a, b): self.BinaryOp(a, '!=', b),
  In(a, b): self.BinaryOp(a, 'in', b),
  BitAnd(a, b): self.BinaryOp(a, '&', b),
  BitXor(a, b): self.BinaryOp(a, '^', b),
  BitOr(a, b): self.BinaryOp(a, '|', b),
  LogicalAnd(a, b): self.BinaryOp(a, '&&', b),
  LogicalOr(a, b): self.BinaryOp(a, '||', b),
  UnaryOp(a, op): {
    output: '%s%s' % [op, a.output],
  },
  Neg(a): self.UnaryOp(a, '-'),
  Pos(a): self.UnaryOp(a, '+'),
  Not(a): self.UnaryOp(a, '!'),
  BitNot(a): self.UnaryOp(a, '~'),

  Std: {
    // External Variables
    extVar(x): $.Call($.Member($.Id('std'), 'extVar'), [x]),

    // Types and Reflection
    thisFile: $.Member($.Id('std'), 'thisFile'),
    type(val): $.Call($.Member($.Id('std'), 'type'), [val]),
    length(x): $.Call($.Member($.Id('std'), 'length'), [x]),
    prune(a): $.Call($.Member($.Id('std'), 'prune'), [a]),

    // Mathematical Utilities
    abs(n): $.Call($.Member($.Id('std'), 'abs'), [n]),
    sign(n): $.Call($.Member($.Id('std'), 'sign'), [n]),
    max(a, b): $.Call($.Member($.Id('std'), 'max'), [a, b]),
    min(a, b): $.Call($.Member($.Id('std'), 'min'), [a, b]),
    pow(x, n): $.Call($.Member($.Id('std'), 'pow'), [x, n]),
    exp(x): $.Call($.Member($.Id('std'), 'exp'), [x]),
    log(x): $.Call($.Member($.Id('std'), 'log'), [x]),
    exponent(x): $.Call($.Member($.Id('std'), 'exponent'), [x]),
    mantissa(x): $.Call($.Member($.Id('std'), 'mantissa'), [x]),
    floor(x): $.Call($.Member($.Id('std'), 'floor'), [x]),
    ceil(x): $.Call($.Member($.Id('std'), 'ceil'), [x]),
    sqrt(x): $.Call($.Member($.Id('std'), 'sqrt'), [x]),
    sin(x): $.Call($.Member($.Id('std'), 'sin'), [x]),
    cos(x): $.Call($.Member($.Id('std'), 'cos'), [x]),
    tan(x): $.Call($.Member($.Id('std'), 'tan'), [x]),
    asin(x): $.Call($.Member($.Id('std'), 'asin'), [x]),
    acos(x): $.Call($.Member($.Id('std'), 'acos'), [x]),
    atan(x): $.Call($.Member($.Id('std'), 'atan'), [x]),
    round(x): $.Call($.Member($.Id('std'), 'round'), [x]),
    isEven(x): $.Call($.Member($.Id('std'), 'isEven'), [x]),
    isOdd(x): $.Call($.Member($.Id('std'), 'isOdd'), [x]),
    isInteger(x): $.Call($.Member($.Id('std'), 'isInteger'), [x]),
    isDecimal(x): $.Call($.Member($.Id('std'), 'isDecimal'), [x]),
    clamp(x, minVal, maxVal): $.Call($.Member($.Id('std'), 'clamp'), [x, minVal, maxVal]),

    // Assertions and Debugging
    assertEqual(a, b): $.Call($.Member($.Id('std'), 'assertEqual'), [a, b]),

    // String Manipulation
    toString(a): $.Call($.Member($.Id('std'), 'toString'), [a]),
    codepoint(str): $.Call($.Member($.Id('std'), 'codepoint'), [str]),
    char(n): $.Call($.Member($.Id('std'), 'char'), [n]),
    substr(str, from, len): $.Call($.Member($.Id('std'), 'substr'), [str, from, len]),
    findSubstr(pat, str): $.Call($.Member($.Id('std'), 'findSubstr'), [pat, str]),
    startsWith(a, b): $.Call($.Member($.Id('std'), 'startsWith'), [a, b]),
    endsWith(a, b): $.Call($.Member($.Id('std'), 'endsWith'), [a, b]),
    stripChars(str, chars): $.Call($.Member($.Id('std'), 'stripChars'), [str, chars]),
    lstripChars(str, chars): $.Call($.Member($.Id('std'), 'lstripChars'), [str, chars]),
    rstripChars(str, chars): $.Call($.Member($.Id('std'), 'rstripChars'), [str, chars]),
    split(str, c): $.Call($.Member($.Id('std'), 'split'), [str, c]),
    splitLimit(str, c, maxsplits): $.Call($.Member($.Id('std'), 'splitLimit'), [str, c, maxsplits]),
    splitLimitR(str, c, maxsplits): $.Call($.Member($.Id('std'), 'splitLimitR'), [str, c, maxsplits]),
    strReplace(str, from, to): $.Call($.Member($.Id('std'), 'strReplace'), [str, from, to]),
    isEmpty(str): $.Call($.Member($.Id('std'), 'isEmpty'), [str]),
    trim(str): $.Call($.Member($.Id('std'), 'trim'), [str]),
    equalsIgnoreCase(str1, str2): $.Call($.Member($.Id('std'), 'equalsIgnoreCase'), [str1, str2]),
    asciiUpper(str): $.Call($.Member($.Id('std'), 'asciiUpper'), [str]),
    asciiLower(str): $.Call($.Member($.Id('std'), 'asciiLower'), [str]),
    stringChars(str): $.Call($.Member($.Id('std'), 'stringChars'), [str]),
    format(str, vals): $.Call($.Member($.Id('std'), 'format'), [str, vals]),
    escapeStringBash(str): $.Call($.Member($.Id('std'), 'escapeStringBash'), [str]),
    escapeStringDollars(str): $.Call($.Member($.Id('std'), 'escapeStringDollars'), [str]),
    escapeStringJson(str): $.Call($.Member($.Id('std'), 'escapeStringJson'), [str]),
    escapeStringPython(str): $.Call($.Member($.Id('std'), 'escapeStringPython'), [str]),
    escapeStringXml(str): $.Call($.Member($.Id('std'), 'escapeStringXml'), [str]),

    // Parsing
    parseInt(str): $.Call($.Member($.Id('std'), 'parseInt'), [str]),
    parseOctal(str): $.Call($.Member($.Id('std'), 'parseOctal'), [str]),
    parseHex(str): $.Call($.Member($.Id('std'), 'parseHex'), [str]),
    parseJson(str): $.Call($.Member($.Id('std'), 'parseJson'), [str]),
    parseYaml(str): $.Call($.Member($.Id('std'), 'parseYaml'), [str]),
    encodeUTF8(str): $.Call($.Member($.Id('std'), 'encodeUTF8'), [str]),
    decodeUTF8(arr): $.Call($.Member($.Id('std'), 'decodeUTF8'), [arr]),

    // Manifestation
    manifestIni(ini): $.Call($.Member($.Id('std'), 'manifestIni'), [ini]),
    manifestPython(v): $.Call($.Member($.Id('std'), 'manifestPython'), [v]),
    manifestPythonVars(conf): $.Call($.Member($.Id('std'), 'manifestPythonVars'), [conf]),
    manifestJsonEx(value, indent, newline, key_val_sep): $.Call($.Member($.Id('std'), 'manifestJsonEx'), [value, indent, newline, key_val_sep]),
    manifestJsonMinified(value): $.Call($.Member($.Id('std'), 'manifestJsonMinified'), [value]),
    manifestYamlDoc(value, indent_array_in_object=$.False, quote_keys=$.True): $.Call($.Member($.Id('std'), 'manifestYamlDoc'), [value, indent_array_in_object, quote_keys]),
    manifestYamlStream(value, indent_array_in_object=$.False, c_document_end=$.False, quote_keys=$.True): $.Call($.Member($.Id('std'), 'manifestYamlStream'), [value, indent_array_in_object, c_document_end, quote_keys]),
    manifestXmlJsonml(value): $.Call($.Member($.Id('std'), 'manifestXmlJsonml'), [value]),
    manifestTomlEx(toml, indent): $.Call($.Member($.Id('std'), 'manifestTomlEx'), [toml, indent]),

    // Arrays
    makeArray(sz, func): $.Call($.Member($.Id('std'), 'makeArray'), [sz, func]),
    member(arr, x): $.Call($.Member($.Id('std'), 'member'), [arr, x]),
    count(arr, x): $.Call($.Member($.Id('std'), 'count'), [arr, x]),
    find(value, arr): $.Call($.Member($.Id('std'), 'find'), [value, arr]),
    map(func, arr): $.Call($.Member($.Id('std'), 'map'), [func, arr]),
    mapWithIndex(func, arr): $.Call($.Member($.Id('std'), 'mapWithIndex'), [func, arr]),
    filterMap(filter_func, map_func, arr): $.Call($.Member($.Id('std'), 'filterMap'), [filter_func, map_func, arr]),
    flatMap(func, arr): $.Call($.Member($.Id('std'), 'flatMap'), [func, arr]),
    filter(func, arr): $.Call($.Member($.Id('std'), 'filter'), [func, arr]),
    foldl(func, arr, init): $.Call($.Member($.Id('std'), 'foldl'), [func, arr, init]),
    foldr(func, arr, init): $.Call($.Member($.Id('std'), 'foldr'), [func, arr, init]),
    range(from, to): $.Call($.Member($.Id('std'), 'range'), [from, to]),
    repeat(what, count): $.Call($.Member($.Id('std'), 'repeat'), [what, count]),
    slice(indexable, index, end, step): $.Call($.Member($.Id('std'), 'slice'), [indexable, index, end, step]),
    join(sep, arr): $.Call($.Member($.Id('std'), 'join'), [sep, arr]),
    lines(arr): $.Call($.Member($.Id('std'), 'lines'), [arr]),
    flattenArrays(arr): $.Call($.Member($.Id('std'), 'flattenArrays'), [arr]),
    flattenDeepArray(value): $.Call($.Member($.Id('std'), 'flattenDeepArray'), [value]),
    reverse(arrs): $.Call($.Member($.Id('std'), 'reverse'), [arrs]),
    sort(arr, keyF): $.Call($.Member($.Id('std'), 'sort'), [arr, keyF]),
    uniq(arr, keyF): $.Call($.Member($.Id('std'), 'uniq'), [arr, keyF]),
    all(arr): $.Call($.Member($.Id('std'), 'all'), [arr]),
    any(arr): $.Call($.Member($.Id('std'), 'any'), [arr]),
    sum(arr): $.Call($.Member($.Id('std'), 'sum'), [arr]),
    minArray(arr, keyF, onEmpty): $.Call($.Member($.Id('std'), 'minArray'), [arr, keyF, onEmpty]),
    maxArray(arr, keyF, onEmpty): $.Call($.Member($.Id('std'), 'maxArray'), [arr, keyF, onEmpty]),
    contains(arr, elem): $.Call($.Member($.Id('std'), 'contains'), [arr, elem]),
    avg(arr): $.Call($.Member($.Id('std'), 'avg'), [arr]),
    remove(arr, elem): $.Call($.Member($.Id('std'), 'remove'), [arr, elem]),
    removeAt(arr, idx): $.Call($.Member($.Id('std'), 'removeAt'), [arr, idx]),

    // Sets
    set(arr, keyF): $.Call($.Member($.Id('std'), 'set'), [arr, keyF]),
    setInter(a, b, keyF): $.Call($.Member($.Id('std'), 'setInter'), [a, b, keyF]),
    setUnion(a, b, keyF): $.Call($.Member($.Id('std'), 'setUnion'), [a, b, keyF]),
    setDiff(a, b, keyF): $.Call($.Member($.Id('std'), 'setDiff'), [a, b, keyF]),
    setMember(x, arr, keyF): $.Call($.Member($.Id('std'), 'setMember'), [x, arr, keyF]),

    // Objects
    get(o, f): $.Call($.Member($.Id('std'), 'get'), [o, f]) + {
      default(default): $.Call($.Member($.Id('std'), 'get'), [o, f, default]) + {
        inc_hidden(inc_hidden): $.Call($.Member($.Id('std'), 'get'), [o, f, default, inc_hidden]),
      },
    },
    objectHas(o, f): $.Call($.Member($.Id('std'), 'objectHas'), [o, f]),
    objectFields(o): $.Call($.Member($.Id('std'), 'objectFields'), [o]),
    objectValues(o): $.Call($.Member($.Id('std'), 'objectValues'), [o]),
    objectKeysValues(o): $.Call($.Member($.Id('std'), 'objectKeysValues'), [o]),
    objectHasAll(o, f): $.Call($.Member($.Id('std'), 'objectHasAll'), [o, f]),
    objectFieldsAll(o): $.Call($.Member($.Id('std'), 'objectFieldsAll'), [o]),
    objectValuesAll(o): $.Call($.Member($.Id('std'), 'objectValuesAll'), [o]),
    objectKeysValuesAll(o): $.Call($.Member($.Id('std'), 'objectKeysValuesAll'), [o]),
    objectRemoveKey(obj, key): $.Call($.Member($.Id('std'), 'objectRemoveKey'), [obj, key]),
    mapWithKey(func, obj): $.Call($.Member($.Id('std'), 'mapWithKey'), [func, obj]),

    // Encoding
    base64(input): $.Call($.Member($.Id('std'), 'base64'), [input]),
    base64DecodeBytes(str): $.Call($.Member($.Id('std'), 'base64DecodeBytes'), [str]),
    base64Decode(str): $.Call($.Member($.Id('std'), 'base64Decode'), [str]),
    md5(s): $.Call($.Member($.Id('std'), 'md5'), [s]),
    sha1(s): $.Call($.Member($.Id('std'), 'sha1'), [s]),
    sha256(s): $.Call($.Member($.Id('std'), 'sha256'), [s]),
    sha512(s): $.Call($.Member($.Id('std'), 'sha512'), [s]),
    sha3(s): $.Call($.Member($.Id('std'), 'sha3'), [s]),

    // Booleans
    xor(x, y): $.Call($.Member($.Id('std'), 'xor'), [x, y]),
    xnor(x, y): $.Call($.Member($.Id('std'), 'xnor'), [x, y]),

    // JSON Merge Patch
    mergePatch(target, patch): $.Call($.Member($.Id('std'), 'mergePatch'), [target, patch]),

    // Debugging
    trace(str, rest): $.Call($.Member($.Id('std'), 'trace'), [str, rest]),
  },
}
