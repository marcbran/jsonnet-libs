# grafonnet-dev

Very simple Go CLI tool for automatically updating a Grafana dashboard after file changes.

## Install

To add grafonnet-layout to a jsonnet project:

```console
go install
```

## Usage

```console
export GRAFANA_SCHEME=http
export GRAFANA_HOST=localhost:3000
export GRAFANA_API_ACCESS_TOKEN="asdfqwerasdfqwer"
grafonnet-dev main.jsonnet
```
