{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'node.rules',
        rules: [
          {
            alert: 'NodeDiskRunningFull',
            annotations: {
              description: 'device {{$labels.device}} on node {{$labels.instance}} is running full within the next 24 hours (mounted at {{$labels.mountpoint}})',
              summary: 'Node disk is running full within 24 hours',
            },
            expr: |||
              predict_linear(node_filesystem_free{%(nodeExporterSelector)s}[6h], 3600 * 24) < 0
            ||| % $._config,
            'for': '30m',
            labels: {
              severity: 'warning',
            },
          },
          {
            alert: 'NodeDiskRunningFull',
            annotations: {
              description: 'device {{$labels.device}} on node {{$labels.instance}} is running full within the next 2 hours (mounted at {{$labels.mountpoint}})',
              summary: 'Node disk is running full within 2 hours',
            },
            expr: |||
              predict_linear(node_filesystem_free{%(nodeExporterSelector)s}[30m], 3600 * 2) < 0
            ||| % $._config,
            'for': '10m',
            labels: {
              severity: 'critical',
            },
          },
        ],
      },
    ],
  },
}
