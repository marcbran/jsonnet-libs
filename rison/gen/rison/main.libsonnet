local specialChars = [':', ' ', '(', ')', '@', '*', "'"];

local rison(val) =
  if std.type(val) == 'object' then
    '(%s)' % std.join(',', ['%s:%s' % [rison(key), rison(val[key])] for key in std.objectFields(val)])
  else if std.type(val) == 'array' then
    '!(%s)' % std.join(',', ['%s' % [rison(elem)] for elem in val])
  else if std.type(val) == 'string' then
    if std.foldl(function(arr, char) arr || std.length(std.findSubstr(char, val)) > 0, specialChars, false) then
      "'%s'" % std.strReplace(val, "'", "!'")
    else if val == '' then
      "''"
    else
      val
  else if std.type(val) == 'number' then
    val
  else if val == true then
    '!t'
  else if val == false then
    '!f'
  else '!n';

rison
