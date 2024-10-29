local tf = import '../main.libsonnet';
local Local = import './terraform-provider-local/main.libsonnet';

local cfg(blocks) = [
  {
    terraform: {
      required_providers: {},
    },
  },
] + blocks;

local variableTests = {
  name: 'variable',
  tests: [
    {
      name: 'default',
      input:: [
        tf.Variable('example', {
          default: 'hello',
        }),
      ],
      expected: cfg([
        {
          variable: {
            example: {
              default: 'hello',
            },
          },
        },
      ]),
    },
    {
      name: 'default',
      input:: [
        tf.Variable('example', {
          default: 'hello',
          type: 'string',
        }),
      ],
      expected: cfg([
        {
          variable: {
            example: {
              default: 'hello',
              type: 'string',
            },
          },
        },
      ]),
    },
  ],
};

local outputTests = {
  name: 'output',
  tests: [
    {
      name: 'string',
      input:: [
        tf.Output('example', {
          value: 'hello',
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: 'hello',
            },
          },
        },
      ]),
    },
    {
      name: 'reference',
      input::
        local example = tf.Variable('example', {
          default: 'hello',
        });
        [
          example,
          tf.Output('example2', {
            value: example,
          }),
        ],
      expected: cfg([
        {
          variable: {
            example: {
              default: 'hello',
            },
          },
        },
        {
          output: {
            example2: {
              value: '${var.example}',
            },
          },
        },
      ]),
    },
  ],
};

local localTests = {
  name: 'local',
  tests: [
    {
      name: 'string',
      input:: [
        tf.Local('example', 'hello'),
      ],
      expected: cfg([
        {
          locals: {
            example: 'hello',
          },
        },
      ]),
    },
    {
      name: 'reference',
      input::
        local example = tf.Local('example', 'hello');
        [
          example,
          tf.Local('example2', example),
        ],
      expected: cfg([
        {
          locals: {
            example: 'hello',
          },
        },
        {
          locals: {
            example2: '${local.example}',
          },
        },
      ]),
    },
  ],
};

local moduleTests = {
  name: 'output',
  tests: [
    {
      name: 'string',
      input:: [
        tf.Module('example', {
          source: './example',
        }),
      ],
      expected: cfg([
        {
          module: {
            example: {
              source: './example',
            },
          },
        },
      ]),
    },
  ],
};

local functionTests = {
  name: 'function',
  tests: [
    {
      name: 'string',
      input:: [
        tf.Output('example', {
          value: tf.trimprefix('helloworld', 'hello'),
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: '${trimprefix("helloworld", "hello")}',
            },
          },
        },
      ]),
    },
    {
      name: 'array',
      input:: [
        tf.Output('example', {
          value: tf.jsonencode([{ foo: 'bar' }]),
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: '${jsonencode([{"foo":"bar"}])}',
            },
          },
        },
      ]),
    },
    {
      name: 'object',
      input:: [
        tf.Output('example', {
          value: tf.jsonencode({ foo: 'bar' }),
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: '${jsonencode({"foo":"bar"})}',
            },
          },
        },
      ]),
    },
    {
      name: 'nested',
      input:: [
        tf.Output('example', {
          value: tf.trimprefix(tf.trimsuffix('helloworld', 'world'), 'hello'),
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: '${trimprefix(trimsuffix("helloworld", "world"), "hello")}',
            },
          },
        },
      ]),
    },
    {
      name: 'provider',
      input:: [
        tf.Output('example', {
          value: Local.func.direxists('/opt/terraform'),
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: '${provider::local::direxists("/opt/terraform")}',
            },
          },
        },
      ]),
    },
  ],
};

local formatTests = {
  name: 'format',
  tests: [
    {
      name: 'string',
      input:: [
        tf.Output('example', {
          value: tf.Format('Hello %s!', ['World']),
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: 'Hello World!',
            },
          },
        },
      ]),
    },
    {
      name: 'function',
      input:: [
        tf.Output('example', {
          value: tf.Format('Hel1lo %s!', [tf.jsonencode({ foo: 'bar' })]),
        }),
      ],
      expected: cfg([
        {
          output: {
            example: {
              value: 'Hello ${jsonencode({"foo":"bar"})}!',
            },
          },
        },
      ]),
    },
  ],
};

local resourceTests = {
  name: 'resource',
  tests: [
    {
      name: 'reference',
      input::
        local example = Local.resource.file('example_txt', {
          filename: 'example.txt',
          content: 'hello',
        });
        [
          example,
          tf.Output('example', {
            value: example,
          }),
        ],
      expected: cfg([
        {
          resource: {
            local_file: {
              example_txt: {
                content: 'hello',
                filename: 'example.txt',
              },
            },
          },
        },
        {
          output: {
            example: {
              value: '${local_file.example_txt}',
            },
          },
        },
      ]),
    },
    {
      name: 'field reference',
      input::
        local example = Local.resource.file('example_txt', {
          filename: 'example.txt',
          content: 'hello',
        });
        [
          example,
          tf.Output('example', {
            value: example.content,
          }),
        ],
      expected: cfg([
        {
          resource: {
            local_file: {
              example_txt: {
                content: 'hello',
                filename: 'example.txt',
              },
            },
          },
        },
        {
          output: {
            example: {
              value: '${local_file.example_txt.content}',
            },
          },
        },
      ]),
    },
    {
      name: 'function call',
      input::
        local example = Local.resource.file('example_txt', {
          filename: 'example.txt',
          content: 'hello',
        });
        [
          example,
          tf.Output('example', {
            value: tf.jsonencode(example),
          }),
        ],
      expected: cfg([
        {
          resource: {
            local_file: {
              example_txt: {
                content: 'hello',
                filename: 'example.txt',
              },
            },
          },
        },
        {
          output: {
            example: {
              value: '${jsonencode(local_file.example_txt)}',
            },
          },
        },
      ]),
    },
    {
      name: 'inbound reference',
      input::
        local example = Local.resource.file('example_txt', {
          filename: 'example.txt',
          content: 'hello',
        });
        [
          example,
          Local.resource.file('example_2_txt', {
            filename: 'example2.txt',
            content: example.content,
          }),
        ],
      expected: cfg([
        {
          resource: {
            local_file: {
              example_txt: {
                content: 'hello',
                filename: 'example.txt',
              },
            },
          },
        },
        {
          resource: {
            local_file: {
              example_2_txt: {
                content: '${local_file.example_txt.content}',
                filename: 'example2.txt',
              },
            },
          },
        },
      ]),
    },
  ],
};

local dataTests = {
  name: 'data',
  tests: [
    {
      name: 'reference',
      input::
        local example = Local.data.file('example_txt', {
          filename: 'example.txt',
        });
        [
          example,
          tf.Output('example', {
            value: example,
          }),
        ],
      expected: cfg([
        {
          data: {
            local_file: {
              example_txt: {
                filename: 'example.txt',
              },
            },
          },
        },
        {
          output: {
            example: {
              value: '${data.local_file.example_txt}',
            },
          },
        },
      ]),
    },
    {
      name: 'field reference',
      input::
        local example = Local.data.file('example_txt', {
          filename: 'example.txt',
        });
        [
          example,
          tf.Output('example', {
            value: example.content,
          }),
        ],
      expected: cfg([
        {
          data: {
            local_file: {
              example_txt: {
                filename: 'example.txt',
              },
            },
          },
        },
        {
          output: {
            example: {
              value: '${data.local_file.example_txt.content}',
            },
          },
        },
      ]),
    },
    {
      name: 'function call',
      input::
        local example = Local.data.file('example_txt', {
          filename: 'example.txt',
        });
        [
          example,
          tf.Output('example', {
            value: tf.jsonencode(example),
          }),
        ],
      expected: cfg([
        {
          data: {
            local_file: {
              example_txt: {
                filename: 'example.txt',
              },
            },
          },
        },
        {
          output: {
            example: {
              value: '${jsonencode(data.local_file.example_txt)}',
            },
          },
        },
      ]),
    },
    {
      name: 'inbound reference',
      input::
        local example = Local.data.file('example_txt', {
          filename: 'example.txt',
        });
        [
          example,
          Local.data.file('example_2_txt', {
            filename: example.filename,
          }),
        ],
      expected: cfg([
        {
          data: {
            local_file: {
              example_txt: {
                filename: 'example.txt',
              },
            },
          },
        },
        {
          data: {
            local_file: {
              example_2_txt: {
                filename: '${data.local_file.example_txt.filename}',
              },
            },
          },
        },
      ]),
    },
  ],
};

local testGroups = [
  variableTests,
  outputTests,
  localTests,
  moduleTests,
  functionTests,
  formatTests,
  resourceTests,
  dataTests,
];

std.flattenArrays([
  [
    {
      name: '%s/%s' % [group.name, test.name],
      actual: tf.Cfg(test.input),
      expected: test.expected,
    }
    for test in group.tests
  ]
  for group in testGroups
])
