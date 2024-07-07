package main

import (
	_ "embed"
	"flag"
	"fmt"
	"github.com/prometheus/client_model/go"
	"net/http"
	"os"
	"sort"
	"strings"

	"github.com/prometheus/common/expfmt"
)

//go:embed metric.libsonnet
var metric string

func main() {
	prefix := flag.String("prefix", "prometheus", "The metric prefix to filter on")
	url := flag.String("url", "http://localhost:9090/metrics", "The URL to fetch metrics from")
	output := flag.String("output", "./", "The output directory for the file")

	flag.Parse()

	err := run(*prefix, *url, *output)
	if err != nil {
		panic(err)
	}
}

func run(prefix, url, output string) error {
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	parser := expfmt.TextParser{}
	familyMap, err := parser.TextToMetricFamilies(resp.Body)
	if err != nil {
		return err
	}
	var families []*io_prometheus_client.MetricFamily
	for _, family := range familyMap {
		families = append(families, family)
	}
	sort.Slice(families, func(i, j int) bool {
		return families[i].GetName() < families[j].GetName()
	})

	var builder strings.Builder
	builder.WriteString(removeExport(metric))
	builder.WriteString(fmt.Sprintf("\n"))

	first := true
	builder.WriteString(fmt.Sprintf("local %s = {\n", prefix))
	for _, family := range families {
		name := family.GetName()
		if !strings.HasPrefix(name, prefix) {
			continue
		}
		field := strings.TrimPrefix(name, prefix+"_")
		if !first {
			builder.WriteString(fmt.Sprintf("\n"))
		}
		builder.WriteString(fmt.Sprintf("  // HELP %s\n", family.GetHelp()))
		builder.WriteString(fmt.Sprintf("  // TYPE %s\n", strings.ToLower(family.GetType().String())))
		builder.WriteString(fmt.Sprintf("  %s: metric('%s'),\n", field, name))
		first = false
	}
	builder.WriteString(fmt.Sprintf("};\n"))
	builder.WriteString(fmt.Sprintf("\n"))

	builder.WriteString(fmt.Sprintf("%s\n", prefix))

	file, err := os.Create(fmt.Sprintf("%s/%s.libsonnet", output, prefix))
	if err != nil {
		return err
	}
	defer file.Close()
	_, err = file.WriteString(builder.String())
	if err != nil {
		return err
	}
	return nil
}

func removeExport(jsonnet string) string {
	lines := strings.Split(jsonnet, "\n")
	if len(lines) <= 2 {
		return ""
	}
	lines = lines[:len(lines)-2]
	return strings.Join(lines, "\n")
}
