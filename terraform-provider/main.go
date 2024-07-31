package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"html/template"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	provider := flag.String("provider", "", "The name of the provider")
	source := flag.String("source", "", "The full source of the provider")
	output := flag.String("output", "./", "The output directory for the file")

	flag.Parse()

	err := run(*provider, *source, *output)
	if err != nil {
		panic(err)
	}
}

func run(provider, source, output string) error {
	providerSchema, err := readProviderSchema(provider, source)
	if err != nil {
		return err
	}

	providerJsonnet, err := formatJsonnet(provider, source, providerSchema)
	if err != nil {
		return err
	}

	err = writeJsonnet(provider, output, providerJsonnet)
	if err != nil {
		return err
	}

	return nil
}

func readProviderSchema(provider string, source string) (any, error) {
	dir, err := os.MkdirTemp("/tmp", "provider")
	if err != nil {
		return nil, err
	}
	config := fmt.Sprintf(`
terraform {
  required_providers {
    %s = {
      source = "%s"
    }
  }
}`, provider, source)
	mainFile := filepath.Join(dir, "main.tf")
	err = os.WriteFile(mainFile, []byte(config), 0644)
	if err != nil {
		return nil, err
	}

	cmd := exec.Command("terraform", fmt.Sprintf("-chdir=%s", dir), "init")
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		return nil, err
	}

	var builder strings.Builder
	cmd = exec.Command("terraform", fmt.Sprintf("-chdir=%s", dir), "providers", "schema", "-json")
	cmd.Stdout = &builder
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		return nil, err
	}
	providerSchema := builder.String()

	var data any
	err = json.Unmarshal([]byte(providerSchema), &data)
	if err != nil {
		return nil, err
	}
	return data, nil
}

func formatJsonnet(provider string, source string, data any) (string, error) {
	var builder strings.Builder
	tmpl, err := template.New("main").
		Funcs(template.FuncMap{
			"trimProvider": func(s string) string {
				return strings.TrimPrefix(s, provider+"_")
			},
			"provider": func() string {
				return provider
			},
			"source": func() string {
				return source
			},
		}).
		Parse(`
{
{{- range .provider_schemas }}
  resource: {
{{- range $key, $value := .resource_schemas }}
    {{ $key | trimProvider }}(name): {
      local resource = self,
{{- range $key, $value := $value.block.attributes }}
      {{ $key }}:: {{ if $value.required }}error '{{ $key }} is required'{{ else }}null{{ end }},
{{- end }}
      __required_provider__: {
        '{{ provider }}': {
          source: "{{ source }}"
        }
      },
      __block__: {
        resource: {
          {{ $key }}: {
            [name]: {
{{- range $key, $value := $value.block.attributes }}
              {{ $key }}: resource.{{ $key }},
{{- end }}
            }
          }
        }
      },
    },
{{- end }}
  },
{{- end }}
}
`)
	if err != nil {
		return "", err
	}
	err = tmpl.Execute(&builder, data)
	if err != nil {
		return "", err
	}
	return builder.String(), nil
}

func writeJsonnet(prefix string, output string, jsonnet string) error {
	dir := filepath.Join(output, prefix)
	err := os.MkdirAll(dir, 0755)
	if err != nil {
		return err
	}
	file, err := os.Create(filepath.Join(dir, "main.libsonnet"))
	if err != nil {
		return err
	}
	defer file.Close()
	_, err = file.WriteString(jsonnet)
	if err != nil {
		return err
	}
	return nil
}
