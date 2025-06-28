package main

import (
	"encoding/json"
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	err := run(os.Args[1])
	if err != nil {
		panic(err)
	}
}

func run(dir string) error {
	elem, err := pullElements()
	if err != nil {
		return err
	}
	err = writeJson(elem, dir)
	if err != nil {
		return err
	}

	return nil
}

func pullElements() ([]string, error) {
	res, err := http.Get("https://developer.mozilla.org/en-US/docs/Web/HTML/Element")
	if err != nil {
		return nil, err
	}
	defer res.Body.Close()

	if res.StatusCode != 200 {
		return nil, fmt.Errorf("status code error: %d %s", res.StatusCode, res.Status)
	}

	doc, err := goquery.NewDocumentFromReader(res.Body)
	if err != nil {
		return nil, err
	}

	var elem []string
	doc.Find("table tr").Each(func(i int, s *goquery.Selection) {
		elemText := s.Find("td").First().Text()
		elems := strings.Split(elemText, ",")
		for _, e := range elems {
			e = strings.TrimSpace(e)
			if !strings.HasPrefix(e, "<") {
				continue
			}
			if !strings.HasSuffix(e, ">") {
				continue
			}
			elem = append(elem, e[1:len(e)-1])
		}
	})
	return elem, nil
}

func writeJson(elem []string, dir string) error {
	err := os.MkdirAll(dir, 0755)
	if err != nil {
		return err
	}
	file, err := os.Create(filepath.Join(dir, "elements.json"))
	if err != nil {
		return err
	}
	defer file.Close()
	b, err := json.MarshalIndent(elem, "", "  ")
	if err != nil {
		return err
	}
	_, err = file.Write(b)
	if err != nil {
		return err
	}
	return nil
}
