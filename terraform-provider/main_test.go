package main

import (
	"testing"
)

func TestFormatJsonnet(t *testing.T) {
	tests := []struct {
		name     string
		provider Provider
		expected string
	}{
		{
			name: "Single Resource and Data Source",
			provider: Provider{
				name:    "local",
				source:  "hashicorp/local",
				version: "0.0.1",
				schema:  localProviderSchema(),
			},
			expected: `local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.ref else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [val] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then '${%s}' % [val._.ref] else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
};

local path(segments) = {
  ref: { _: { ref: std.join('.', segments) } },
  child(segment): path(segments + [segment]),
};

local func(name, parameters=[]) = {
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
  _: { ref: '%s(%s)' % [name, parameterString] },
};

local provider = {
  local name = 'local',
  provider(block): {
    _: {
      block: {
        provider: {
          [name]: std.prune({
            alias: std.get(block, 'alias', null, true),
          }),
        },
      },
    },
  },
  resource: {
    file(name, block): {
      local p = path(['local_file', name]),
      _: p.ref._ {
        block: {
          resource: {
            local_file: {
              [name]: std.prune({
                content: build.template(std.get(block, 'content', null, true)),
              }),
            },
          },
        },
      },
      content: p.child('content').ref,
    },
  },
  data: {
    file(name, block): {
      local p = path(['data', 'local_file', name]),
      _: p.ref._ {
        block: {
          data: {
            local_file: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      content: p.child('content').ref,
    },
  },
};

provider
`,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actual, err := formatJsonnet(tt.provider)
			if err != nil {
				t.Errorf("formatJsonnet() encounterd an erorr: %v", err)
			}
			expected := tt.expected
			if actual != expected {
				t.Errorf("formatJsonnet() \n   actual: %v \n expected: %v", actual, expected)
			}
		})
	}
}

func localProviderSchema() map[string]interface{} {
	return map[string]interface{}{
		"format_version": "1.0",
		"provider_schemas": map[string]interface{}{
			"registry.terraform.io/hashicorp/local": map[string]interface{}{
				"provider": map[string]interface{}{
					"version": 0,
					"block": map[string]interface{}{
						"description_kind": "plain",
					},
				},
				"resource_schemas": map[string]interface{}{
					"local_file": map[string]interface{}{
						"version": 0,
						"block": map[string]interface{}{
							"attributes": map[string]interface{}{
								"content": map[string]interface{}{
									"type":             "string",
									"description":      "Content to store in the file, expected to be a UTF-8 encoded string.\n Conflicts with `sensitive_content`, `content_base64` and `source`.\n Exactly one of these four arguments must be specified.",
									"description_kind": "plain",
									"optional":         true,
								},
							},
							"description":      "Generates a local file with the given content.",
							"description_kind": "plain",
						},
					},
				},
				"data_source_schemas": map[string]interface{}{
					"local_file": map[string]interface{}{
						"version": 0,
						"block": map[string]interface{}{
							"attributes": map[string]interface{}{
								"content": map[string]interface{}{
									"type":             "string",
									"description":      "Raw content of the file that was read, as UTF-8 encoded string. Files that do not contain UTF-8 text will have invalid UTF-8 sequences in `content`\n  replaced with the Unicode replacement character.",
									"description_kind": "plain",
									"computed":         true,
								},
							},
							"description":      "Reads a file from the local filesystem.",
							"description_kind": "plain",
						},
					},
				},
			},
		},
	}
}
