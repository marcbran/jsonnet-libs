local tf = import '../../../terraform-stack/main.libsonnet';
local l = import './local/main.libsonnet';

tf([
  l.resource.file('test') {
    filename: 'actual.txt',
    content: 'Hello World!',
  },
])
