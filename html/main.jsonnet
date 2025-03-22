local elements = import './build/elements.json';
local htmlManifest = import './template/main.libsonnet';
htmlManifest(elements)
