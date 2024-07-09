package main

import (
	"github.com/prometheus/client_model/go"
	"google.golang.org/protobuf/proto"
	"testing"
)

func TestFormatJsonnet(t *testing.T) {
	tests := []struct {
		name     string
		prefix   string
		families []*io_prometheus_client.MetricFamily
		expected string
	}{
		{
			name:   "Single MetricFamily",
			prefix: "test",
			families: []*io_prometheus_client.MetricFamily{
				{
					Name: proto.String("test_metric1"),
					Help: proto.String("This is metric 1"),
					Type: io_prometheus_client.MetricType_COUNTER.Enum(),
				},
			},
			expected: `local test = {
  // HELP This is metric 1
  // TYPE counter
  metric1: metric('test_metric1'),
};

test
`,
		},
		{
			name:   "Multiple MetricFamilies",
			prefix: "test",
			families: []*io_prometheus_client.MetricFamily{
				{
					Name: proto.String("test_metric1"),
					Help: proto.String("This is metric 1"),
					Type: io_prometheus_client.MetricType_COUNTER.Enum(),
				},
				{
					Name: proto.String("test_metric2"),
					Help: proto.String("This is metric 2"),
					Type: io_prometheus_client.MetricType_GAUGE.Enum(),
				},
			},
			expected: `local test = {
  // HELP This is metric 1
  // TYPE counter
  metric1: metric('test_metric1'),

  // HELP This is metric 2
  // TYPE gauge
  metric2: metric('test_metric2'),
};

test
`,
		},
		{
			name:   "No matching prefix",
			prefix: "test",
			families: []*io_prometheus_client.MetricFamily{
				{
					Name: proto.String("other_metric"),
					Help: proto.String("This is another metric"),
					Type: io_prometheus_client.MetricType_COUNTER.Enum(),
				},
			},
			expected: `local test = {
};

test
`,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actual := formatJsonnet(tt.prefix, tt.families)
			expected := head + tt.expected
			if actual != expected {
				t.Errorf("formatJsonnet() \n   actual: %v \n expected: %v", actual, expected)
			}
		})
	}
}

var head = `local metric(name) = {
  local eq(value) = {
    output(field): '%s%s"%s"' % [field, '=', value],
  },
  local labels = [[field, self[field]] for field in std.sort(std.objectFields(self)) if field != 'output'],
  local comparisons = [[label[0], if std.type(label[1]) == 'string' then eq(label[1]) else label[1]] for label in labels],
  local filters = [comparison[1].output(comparison[0]) for comparison in comparisons],
  local filterString = std.join(', ', filters),
  output: if (std.length(filterString) > 0) then '%s{%s}' % [name, filterString] else name,
};

`
