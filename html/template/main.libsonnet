local jsonnetManifest = import 'jsonnet-manifest/main.libsonnet';
local j = import 'jsonnet/main.libsonnet';

local html(elements) = j.Exprs([
  j.LocalFunc('elem', [
    j.Id('name'),
    j.DefaultParam('attrOrChildren', j.Array([])),
    j.DefaultParam('childrenOrNull', j.Null),
  ], j.Exprs([
    j.Local('actualAttr', j.If(j.Neq(j.Id('childrenOrNull'), j.Null)).Then(j.Id('attrOrChildren')).Else(j.Null)),
    j.Local('actualChildren', j.If(j.Neq(j.Id('childrenOrNull'), j.Null)).Then(j.Id('childrenOrNull')).Else(j.Id('attrOrChildren'))),
    j.Local('arrayChildren', j.If(j.Eq(j.Std.type(j.Id('actualChildren')), j.String('array'))).Then(j.Id('actualChildren')).Else(j.Array([j.Id('actualChildren')]))),
    j.Std.prune(j.Add(j.Array([j.Id('name'), j.Id('actualAttr')]), j.Id('arrayChildren'))),
  ], newlines=1, prefixNewlines=1)),

  j.Local('elements', j.Object([
    j.FieldFunc(j.String(element), [
      j.DefaultParam('attrOrChildren', j.Array([])),
      j.DefaultParam('childrenOrNull', j.Null),
    ], j.Call(j.Id('elem'), [j.String(element), j.Id('attrOrChildren'), j.Id('childrenOrNull')]))
    for element in elements
  ], newlines=1)),

  j.Local('manifest', j.Object([
    j.FieldFunc(j.String('manifestElement'), [
      j.Id('elem'),
    ], j.Std.manifestXmlJsonml(j.Id('elem'))),
    j.FieldFunc(j.String('manifestPage'), [
      j.Id('elem'),
    ], j.Add(j.String('<!doctype html>'), j.Std.manifestXmlJsonml(j.Id('elem')))),
  ], newlines=1)),

  j.Add(j.Id('elements'), j.Id('manifest')),
], newlines=2).output;

local htmlManifest(elements) = {
  directory: {
    gen: {
      'main.libsonnet': html(elements),
    },
  },
  manifestations: {
    '.libsonnet'(data): jsonnetManifest.formatJsonnet(data),
  },
};

htmlManifest
