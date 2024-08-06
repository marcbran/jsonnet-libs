local j = import 'jsonnet.libsonnet';

local terraformProvider(provider, source, schema) =
  local block(key, attributes, type) =
    j.field(
      j.functionSignature(std.substr(key, std.length(provider) + 1, std.length(key)), ['name']),
      j.object(
        [
          j.variable(type, j.ref('self')),
        ] +
        std.map(
          function(key)
            local attribute = attributes[key];
            j.field(
              key,
              if (std.get(attribute, 'required', false))
              then j.err('%s is required' % key)
              else j.ref('null'),
              visibility='::'
            ),
          std.objectFields(attributes)
        ) +
        [
          j.field('__required_provider__', j.object([
            j.field(j.string(provider), j.object([
              j.field('source', j.string(source)),
            ])),
          ])),
          j.field('__block__', j.object([
            j.field(type, j.object([
              j.field(j.string(key), j.object([
                j.field(j.fieldNameExpression(j.ref('name')), j.object(
                  std.map(
                    function(key)
                      local attribute = attributes[key];
                      j.field(
                        key,
                        j.ref([type, key]),
                      ),
                    std.objectFields(attributes)
                  )
                )),
              ])),
            ])),
          ])),
        ]
      )
    );
  local providerSchema = schema.provider_schemas['registry.terraform.io/%s' % source];
  local resourceSchemas = std.get(providerSchema, 'resource_schemas', {});
  local resources = j.object(std.map(
    function(key) block(key, resourceSchemas[key].block.attributes, 'resource'),
    std.objectFields(resourceSchemas),
  ));
  local dataSourceSchemas = std.get(providerSchema, 'data_source_schemas', {});
  local dataSources = j.object(std.map(
    function(key) block(key, dataSourceSchemas[key].block.attributes, 'data'),
    std.objectFields(dataSourceSchemas),
  ));
  j.object([
    j.field('resource', resources),
    j.field('data', dataSources),
  ]);

terraformProvider
