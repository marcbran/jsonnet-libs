package main

import (
	"crypto/tls"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/fsnotify/fsnotify"
	"github.com/go-openapi/strfmt"
	"github.com/google/go-jsonnet"
	goapi "github.com/grafana/grafana-openapi-client-go/client"
	"github.com/grafana/grafana-openapi-client-go/models"
	"os"
)

func main() {
	flag.Parse()

	filenames := flag.Args()

	err := run(filenames[0])
	if err != nil {
		panic(err)
	}
}

func run(filename string) error {
	client := newGrafanaClient()

	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		return err
	}
	defer watcher.Close()

	go func() {
		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					return
				}
				if !event.Has(fsnotify.Write) {
					continue
				}
				vm := newJsonnetVm()
				jsonStr, err := vm.EvaluateFile(filename)
				if err != nil {
					fmt.Println(err)
					continue
				}
				var dashboard any
				err = json.Unmarshal([]byte(jsonStr), &dashboard)
				if err != nil {
					fmt.Println(err)
					continue
				}
				_, err = client.Dashboards.PostDashboard(&models.SaveDashboardCommand{
					Dashboard: dashboard,
					Overwrite: true,
				})
				if err != nil {
					fmt.Println(err)
					continue
				}
				fmt.Println("Dashboard updated")
			case err, ok := <-watcher.Errors:
				if !ok {
					fmt.Println(err)
					continue
				}
			}
		}
	}()

	err = watcher.Add(".")
	if err != nil {
		return err
	}

	fmt.Println("Watching for changes")

	<-make(chan struct{})

	return nil
}

func newJsonnetVm() *jsonnet.VM {
	vm := jsonnet.MakeVM()
	vm.Importer(&jsonnet.FileImporter{
		JPaths: []string{
			"vendor",
		},
	})
	return vm
}

func newGrafanaClient() *goapi.GrafanaHTTPAPI {
	cfg := &goapi.TransportConfig{
		Host:             os.Getenv("GRAFANA_HOST"),
		BasePath:         "/api",
		Schemes:          []string{os.Getenv("GRAFANA_SCHEME")},
		APIKey:           os.Getenv("GRAFANA_API_ACCESS_TOKEN"),
		TLSConfig:        &tls.Config{},
		NumRetries:       3,
		RetryTimeout:     0,
		RetryStatusCodes: []string{"420", "5xx"},
		HTTPHeaders:      map[string]string{},
	}
	client := goapi.NewHTTPClientWithConfig(strfmt.Default, cfg)
	return client
}
