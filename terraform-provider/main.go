package main

import (
	_ "embed"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/google/go-jsonnet"
	"github.com/google/go-jsonnet/formatter"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

//go:embed tmpl/main.libsonnet
var tmpl string

//go:embed tmpl/jsonnet.libsonnet
var j string

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
	b, err := json.Marshal(data)
	if err != nil {
		return "", err
	}

	vm := jsonnet.MakeVM()
	vm.Importer(&jsonnet.MemoryImporter{
		Data: map[string]jsonnet.Contents{
			"main.libsonnet":    jsonnet.MakeContents(tmpl),
			"jsonnet.libsonnet": jsonnet.MakeContents(j),
		},
	})
	snippet := fmt.Sprintf(`{
		provider: import 'main.libsonnet',
        output: self.provider('%s', '%s', %s).output
	}.output`, provider, source, string(b))
	jsonStr, err := vm.EvaluateAnonymousSnippet("main.jsonnet", snippet)
	if err != nil {
		return "", err
	}
	jsonStr = jsonStr[1 : len(jsonStr)-2]
	jsonStr = strings.ReplaceAll(jsonStr, "\\n", "\n")
	format, err := formatter.Format("main.jsonnet", jsonStr, formatter.DefaultOptions())
	if err != nil {
		return "", err
	}
	return format, nil
}

func writeJsonnet(prefix string, output string, jsonnet string) error {
	dir := filepath.Join(output, fmt.Sprintf("terraform-provider-%s", prefix))
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
