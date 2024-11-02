package main

import (
	_ "embed"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/google/go-jsonnet"
	"github.com/google/go-jsonnet/formatter"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclparse"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

//go:embed tmpl/main.libsonnet
var mainLibsonnet string

//go:embed tmpl/jsonnet.libsonnet
var jsonnetLibsonnet string

func main() {
	provider := flag.String("provider", "", "The name of the provider")
	source := flag.String("source", "", "The full source of the provider")
	version := flag.String("version", "", "The provider version for which the scheme should be read")
	output := flag.String("output", "./", "The output directory for the file")

	flag.Parse()

	err := run(*provider, *source, *version, *output)
	if err != nil {
		panic(err)
	}
}

type Provider struct {
	name    string
	source  string
	version string
	schema  any
}

func run(name, source, version, output string) error {
	provider := Provider{
		name:    name,
		source:  source,
		version: version,
	}

	filledProvider, err := fillProvider(provider)
	if err != nil {
		return err
	}
	provider = *filledProvider

	jnet, err := formatJsonnet(provider)
	if err != nil {
		return err
	}

	err = writeJson(provider, output)
	if err != nil {
		return err
	}

	err = writeJsonnet(provider, jnet, output)
	if err != nil {
		return err
	}

	return nil
}

func fillProvider(provider Provider) (*Provider, error) {
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
}`, provider.name, provider.source)
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

	source, err := readSource(dir)
	if err != nil {
		return nil, err
	}

	version, err := readVersion(dir)
	if err != nil {
		return nil, err
	}

	schema, err := readSchema(dir)
	if err != nil {
		return nil, err
	}

	provider = Provider{
		name:    provider.name,
		source:  source,
		version: version,
		schema:  schema,
	}
	return &provider, nil
}

func readSource(dir string) (string, error) {
	parser := hclparse.NewParser()
	file, diags := parser.ParseHCLFile(filepath.Join(dir, ".terraform.lock.hcl"))
	if diags.HasErrors() {
		return "", fmt.Errorf("error parsing .terraform.locl.hcl: %s", diags.Error())
	}

	content, diags := file.Body.Content(&hcl.BodySchema{
		Blocks: []hcl.BlockHeaderSchema{
			{
				Type:       "provider",
				LabelNames: []string{"name"},
			},
		},
	})
	if diags.HasErrors() {
		return "", fmt.Errorf("error decoding .terraform.locl.hcl: %s", diags.Error())
	}
	source := content.Blocks[0].Labels[0]
	return source, nil
}

func readVersion(dir string) (string, error) {
	parser := hclparse.NewParser()
	file, diags := parser.ParseHCLFile(filepath.Join(dir, ".terraform.lock.hcl"))
	if diags.HasErrors() {
		return "", fmt.Errorf("error parsing .terraform.locl.hcl: %s", diags.Error())
	}

	content, diags := file.Body.Content(&hcl.BodySchema{
		Blocks: []hcl.BlockHeaderSchema{
			{
				Type:       "provider",
				LabelNames: []string{"name"},
			},
		},
	})
	if diags.HasErrors() {
		return "", fmt.Errorf("error decoding .terraform.locl.hcl: %s", diags.Error())
	}
	partialContent, _, diags := content.Blocks[0].Body.PartialContent(&hcl.BodySchema{
		Attributes: []hcl.AttributeSchema{
			{
				Name: "version",
			},
		},
	})
	if diags.HasErrors() {
		return "", fmt.Errorf("error getting attributes from .terraform.locl.hcl: %s", diags.Error())
	}
	value, diags := partialContent.Attributes["version"].Expr.Value(nil)
	version := value.AsString()
	return version, nil
}

func readSchema(dir string) (any, error) {
	var builder strings.Builder
	cmd := exec.Command("terraform", fmt.Sprintf("-chdir=%s", dir), "providers", "schema", "-json")
	cmd.Stdout = &builder
	cmd.Stderr = os.Stderr
	err := cmd.Run()
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

func formatJsonnet(provider Provider) (string, error) {
	b, err := json.Marshal(provider.schema)
	if err != nil {
		return "", err
	}

	vm := jsonnet.MakeVM()
	vm.MaxStack = 1000000
	vm.Importer(&jsonnet.MemoryImporter{
		Data: map[string]jsonnet.Contents{
			"main.libsonnet":    jsonnet.MakeContents(mainLibsonnet),
			"jsonnet.libsonnet": jsonnet.MakeContents(jsonnetLibsonnet),
			"provider.json":     jsonnet.MakeContentsRaw(b),
		},
	})
	snippet := fmt.Sprintf(`{
		template: import 'main.libsonnet',
        provider: import 'provider.json',
        output: self.template('%s', '%s', '%s', self.provider)
	}.output`, provider.name, provider.source, provider.version)
	jsonStr, err := vm.EvaluateAnonymousSnippet("main.jsonnet", snippet)
	if err != nil {
		return "", err
	}
	jsonStr = jsonStr[1 : len(jsonStr)-2]
	jsonStr = strings.ReplaceAll(jsonStr, "\\\\n", "\n")
	format, err := formatter.Format("main.jsonnet", jsonStr, formatter.DefaultOptions())
	if err != nil {
		return "", err
	}
	return format, nil
}

func writeJsonnet(provider Provider, jsonnet string, output string) error {
	dir := filepath.Join(output, provider.source, provider.version, fmt.Sprintf("terraform-provider-%s", provider.name))
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

func writeJson(provider Provider, output string) error {
	dir := filepath.Join(output, provider.source, provider.version, fmt.Sprintf("terraform-provider-%s", provider.name))
	err := os.MkdirAll(dir, 0755)
	if err != nil {
		return err
	}
	file, err := os.Create(filepath.Join(dir, "schema.json"))
	if err != nil {
		return err
	}
	defer file.Close()
	b, err := json.MarshalIndent(provider.schema, "", "  ")
	if err != nil {
		return err
	}
	_, err = file.Write(b)
	if err != nil {
		return err
	}
	return nil
}
