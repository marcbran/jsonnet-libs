package main

import (
	"testing"
)

func TestFormatJsonnet(t *testing.T) {
	tests := []struct {
		name     string
		provider string
		source   string
		data     any
		expected string
	}{
		{
			name:     "Single Resource and Data Source",
			provider: "local",
			source:   "hashicorp/local",
			data:     localProviderSchema(),
			expected: `{
  resource: {
    file(name): {
      local resource = self,
      content:: null,
      __required_provider__: {
        'local': {
          source: 'hashicorp/local',
        },
      },
      __block__: {
        resource: {
          local_file: {
            [name]: {
              content: resource.content,
            },
          },
        },
      },
    },
  },
  data: {
    file(name): {
      local data = self,
      content:: null,
      __required_provider__: {
        'local': {
          source: 'hashicorp/local',
        },
      },
      __block__: {
        data: {
          local_file: {
            [name]: {
              content: data.content,
            },
          },
        },
      },
    },
  },
}
`,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actual, err := formatJsonnet(tt.provider, tt.source, tt.data)
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
