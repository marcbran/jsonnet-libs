package main

import (
	_ "embed"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/google/go-jsonnet"
	"github.com/google/go-jsonnet/formatter"
	"github.com/prometheus/client_model/go"
	"github.com/prometheus/common/expfmt"
	"github.com/prometheus/prom2json"
	"net/http"
	"os"
	"sort"
	"strings"
)

//go:embed tmpl/main.libsonnet
var mainLibsonnet string

//go:embed tmpl/jsonnet.libsonnet
var jsonnetLibsonnet string

func main() {
	url := flag.String("url", "http://localhost:8080/metrics", "The URL to fetch metrics from")
	output := flag.String("output", "./", "The output directory for the files")

	flag.Parse()

	prefixes := flag.Args()

	err := run(prefixes, *url, *output)
	if err != nil {
		panic(err)
	}
}

func run(prefixes []string, url, output string) error {
	families, err := readMetricFamilies(url)
	if err != nil {
		return err
	}

	for _, prefix := range prefixes {
		jnet, err := formatJsonnet(prefix, families)
		if err != nil {
			return err
		}
		err = writeJsonnet(prefix, output, jnet)
		if err != nil {
			return err
		}
	}
	return nil
}

func readMetricFamilies(url string) ([]*prom2json.Family, error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	parser := expfmt.TextParser{}
	familyMap, err := parser.TextToMetricFamilies(resp.Body)
	if err != nil {
		return nil, err
	}
	var families []*io_prometheus_client.MetricFamily
	for _, family := range familyMap {
		families = append(families, family)
	}
	sort.Slice(families, func(i, j int) bool {
		return families[i].GetName() < families[j].GetName()
	})
	var metrics []*prom2json.Family
	for _, family := range families {
		metrics = append(metrics, prom2json.NewFamily(family))
	}
	return metrics, nil
}

func formatJsonnet(prefix string, data []*prom2json.Family) (string, error) {
	b, err := json.Marshal(data)
	if err != nil {
		return "", err
	}

	vm := jsonnet.MakeVM()
	vm.Importer(&jsonnet.MemoryImporter{
		Data: map[string]jsonnet.Contents{
			"main.libsonnet":    jsonnet.MakeContents(mainLibsonnet),
			"jsonnet.libsonnet": jsonnet.MakeContents(jsonnetLibsonnet),
			"metrics.json":      jsonnet.MakeContentsRaw(b),
			"prefix.json":       jsonnet.MakeContents(fmt.Sprintf("\"%s\"", prefix)),
		},
	})
	snippet := fmt.Sprintf(`{
		template: import 'main.libsonnet',
        metrics: import 'metrics.json',
        prefix: import 'prefix.json',
        output: self.template(self.metrics, self.prefix)
	}.output`)
	jsonStr, err := vm.EvaluateAnonymousSnippet("main.jsonnet", snippet)
	if err != nil {
		return "", err
	}
	jsonStr = jsonStr[1 : len(jsonStr)-2]
	jsonStr = strings.ReplaceAll(jsonStr, "\\n", "\n")
	jsonStr, err = formatter.Format("main.jsonnet", jsonStr, formatter.DefaultOptions())
	if err != nil {
		return "", err
	}
	return jsonStr, nil
}

func writeJsonnet(prefix string, output string, jsonnet string) error {
	err := os.MkdirAll(output, 0755)
	if err != nil {
		return err
	}
	file, err := os.Create(fmt.Sprintf("%s/%s.libsonnet", output, prefix))
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
