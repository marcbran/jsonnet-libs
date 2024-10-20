local tf = import '../../../terraform/main.libsonnet';
local l = import './registry.terraform.io/hashicorp/local/2.5.2/terraform-provider-local/main.libsonnet';

tf.Cfg([
  l.resource.file('test', {
    filename: 'actual.txt',
    content: 'Hello World!',
  }),
])
