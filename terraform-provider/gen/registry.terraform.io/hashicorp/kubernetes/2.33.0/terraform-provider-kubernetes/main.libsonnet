local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then val._.ref else '"%s"' % [val._.str] else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [val] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then '${%s}' % [val._.ref] else val._.str else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  requiredProvider(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.requiredProvider else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), val), {}) else {},
};

local requiredProvider = {
  _: {
    requiredProvider: {
      kubernetes: {
        source: 'registry.terraform.io/hashicorp/kubernetes',
        version: '2.33.0',
      },
    },
  },
};

local path(segments) = {
  child(segment): path(segments + [segment]),
  out: requiredProvider { _+: { ref: std.join('.', segments) } },
};

local func(name, parameters=[]) =
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]);
  requiredProvider { _+: { ref: '%s(%s)' % [name, parameterString] } };

local provider = {
  local name = 'kubernetes',
  provider(block): {
    _: {
      block: {
        provider: {
          [name]: std.prune({
            alias: std.get(block, 'alias', null, true),
          }),
        },
      },
    },
  },
  resource: {
    annotations(name, block): {
      local p = path(['kubernetes_annotations', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_annotations: {
              [name]: std.prune({
                annotations: build.template(std.get(block, 'annotations', null, true)),
                api_version: build.template(block.api_version),
                field_manager: build.template(std.get(block, 'field_manager', null, true)),
                force: build.template(std.get(block, 'force', null, true)),
                kind: build.template(block.kind),
                template_annotations: build.template(std.get(block, 'template_annotations', null, true)),
              }),
            },
          },
        },
      },
      annotations: p.child('annotations').out,
      api_version: p.child('api_version').out,
      field_manager: p.child('field_manager').out,
      force: p.child('force').out,
      id: p.child('id').out,
      kind: p.child('kind').out,
      template_annotations: p.child('template_annotations').out,
    },
    api_service(name, block): {
      local p = path(['kubernetes_api_service', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_api_service: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    api_service_v1(name, block): {
      local p = path(['kubernetes_api_service_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_api_service_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    certificate_signing_request(name, block): {
      local p = path(['kubernetes_certificate_signing_request', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_certificate_signing_request: {
              [name]: std.prune({
                auto_approve: build.template(std.get(block, 'auto_approve', null, true)),
              }),
            },
          },
        },
      },
      auto_approve: p.child('auto_approve').out,
      certificate: p.child('certificate').out,
      id: p.child('id').out,
    },
    certificate_signing_request_v1(name, block): {
      local p = path(['kubernetes_certificate_signing_request_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_certificate_signing_request_v1: {
              [name]: std.prune({
                auto_approve: build.template(std.get(block, 'auto_approve', null, true)),
              }),
            },
          },
        },
      },
      auto_approve: p.child('auto_approve').out,
      certificate: p.child('certificate').out,
      id: p.child('id').out,
    },
    cluster_role(name, block): {
      local p = path(['kubernetes_cluster_role', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_cluster_role: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    cluster_role_binding(name, block): {
      local p = path(['kubernetes_cluster_role_binding', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_cluster_role_binding: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    cluster_role_binding_v1(name, block): {
      local p = path(['kubernetes_cluster_role_binding_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_cluster_role_binding_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    cluster_role_v1(name, block): {
      local p = path(['kubernetes_cluster_role_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_cluster_role_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    config_map(name, block): {
      local p = path(['kubernetes_config_map', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_config_map: {
              [name]: std.prune({
                binary_data: build.template(std.get(block, 'binary_data', null, true)),
                data: build.template(std.get(block, 'data', null, true)),
                immutable: build.template(std.get(block, 'immutable', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
    },
    config_map_v1(name, block): {
      local p = path(['kubernetes_config_map_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_config_map_v1: {
              [name]: std.prune({
                binary_data: build.template(std.get(block, 'binary_data', null, true)),
                data: build.template(std.get(block, 'data', null, true)),
                immutable: build.template(std.get(block, 'immutable', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
    },
    config_map_v1_data(name, block): {
      local p = path(['kubernetes_config_map_v1_data', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_config_map_v1_data: {
              [name]: std.prune({
                data: build.template(block.data),
                field_manager: build.template(std.get(block, 'field_manager', null, true)),
                force: build.template(std.get(block, 'force', null, true)),
              }),
            },
          },
        },
      },
      data: p.child('data').out,
      field_manager: p.child('field_manager').out,
      force: p.child('force').out,
      id: p.child('id').out,
    },
    cron_job(name, block): {
      local p = path(['kubernetes_cron_job', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_cron_job: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    cron_job_v1(name, block): {
      local p = path(['kubernetes_cron_job_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_cron_job_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    csi_driver(name, block): {
      local p = path(['kubernetes_csi_driver', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_csi_driver: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    csi_driver_v1(name, block): {
      local p = path(['kubernetes_csi_driver_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_csi_driver_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    daemon_set_v1(name, block): {
      local p = path(['kubernetes_daemon_set_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_daemon_set_v1: {
              [name]: std.prune({
                wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_rollout: p.child('wait_for_rollout').out,
    },
    daemonset(name, block): {
      local p = path(['kubernetes_daemonset', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_daemonset: {
              [name]: std.prune({
                wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_rollout: p.child('wait_for_rollout').out,
    },
    default_service_account(name, block): {
      local p = path(['kubernetes_default_service_account', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_default_service_account: {
              [name]: std.prune({
                automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null, true)),
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').out,
      default_secret_name: p.child('default_secret_name').out,
      id: p.child('id').out,
    },
    default_service_account_v1(name, block): {
      local p = path(['kubernetes_default_service_account_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_default_service_account_v1: {
              [name]: std.prune({
                automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null, true)),
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').out,
      default_secret_name: p.child('default_secret_name').out,
      id: p.child('id').out,
    },
    deployment(name, block): {
      local p = path(['kubernetes_deployment', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_deployment: {
              [name]: std.prune({
                wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_rollout: p.child('wait_for_rollout').out,
    },
    deployment_v1(name, block): {
      local p = path(['kubernetes_deployment_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_deployment_v1: {
              [name]: std.prune({
                wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_rollout: p.child('wait_for_rollout').out,
    },
    endpoint_slice_v1(name, block): {
      local p = path(['kubernetes_endpoint_slice_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_endpoint_slice_v1: {
              [name]: std.prune({
                address_type: build.template(block.address_type),
              }),
            },
          },
        },
      },
      address_type: p.child('address_type').out,
      id: p.child('id').out,
    },
    endpoints(name, block): {
      local p = path(['kubernetes_endpoints', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_endpoints: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    endpoints_v1(name, block): {
      local p = path(['kubernetes_endpoints_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_endpoints_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    env(name, block): {
      local p = path(['kubernetes_env', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_env: {
              [name]: std.prune({
                api_version: build.template(block.api_version),
                container: build.template(std.get(block, 'container', null, true)),
                field_manager: build.template(std.get(block, 'field_manager', null, true)),
                force: build.template(std.get(block, 'force', null, true)),
                init_container: build.template(std.get(block, 'init_container', null, true)),
                kind: build.template(block.kind),
              }),
            },
          },
        },
      },
      api_version: p.child('api_version').out,
      container: p.child('container').out,
      field_manager: p.child('field_manager').out,
      force: p.child('force').out,
      id: p.child('id').out,
      init_container: p.child('init_container').out,
      kind: p.child('kind').out,
    },
    horizontal_pod_autoscaler(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    horizontal_pod_autoscaler_v1(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    horizontal_pod_autoscaler_v2(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler_v2', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler_v2: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    horizontal_pod_autoscaler_v2beta2(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler_v2beta2', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler_v2beta2: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    ingress(name, block): {
      local p = path(['kubernetes_ingress', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_ingress: {
              [name]: std.prune({
                wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      status: p.child('status').out,
      wait_for_load_balancer: p.child('wait_for_load_balancer').out,
    },
    ingress_class(name, block): {
      local p = path(['kubernetes_ingress_class', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_ingress_class: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    ingress_class_v1(name, block): {
      local p = path(['kubernetes_ingress_class_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_ingress_class_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    ingress_v1(name, block): {
      local p = path(['kubernetes_ingress_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_ingress_v1: {
              [name]: std.prune({
                wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      status: p.child('status').out,
      wait_for_load_balancer: p.child('wait_for_load_balancer').out,
    },
    job(name, block): {
      local p = path(['kubernetes_job', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_job: {
              [name]: std.prune({
                wait_for_completion: build.template(std.get(block, 'wait_for_completion', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_completion: p.child('wait_for_completion').out,
    },
    job_v1(name, block): {
      local p = path(['kubernetes_job_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_job_v1: {
              [name]: std.prune({
                wait_for_completion: build.template(std.get(block, 'wait_for_completion', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_completion: p.child('wait_for_completion').out,
    },
    labels(name, block): {
      local p = path(['kubernetes_labels', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_labels: {
              [name]: std.prune({
                api_version: build.template(block.api_version),
                field_manager: build.template(std.get(block, 'field_manager', null, true)),
                force: build.template(std.get(block, 'force', null, true)),
                kind: build.template(block.kind),
                labels: build.template(block.labels),
              }),
            },
          },
        },
      },
      api_version: p.child('api_version').out,
      field_manager: p.child('field_manager').out,
      force: p.child('force').out,
      id: p.child('id').out,
      kind: p.child('kind').out,
      labels: p.child('labels').out,
    },
    limit_range(name, block): {
      local p = path(['kubernetes_limit_range', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_limit_range: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    limit_range_v1(name, block): {
      local p = path(['kubernetes_limit_range_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_limit_range_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    manifest(name, block): {
      local p = path(['kubernetes_manifest', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_manifest: {
              [name]: std.prune({
                computed_fields: build.template(std.get(block, 'computed_fields', null, true)),
                manifest: build.template(block.manifest),
                wait_for: build.template(std.get(block, 'wait_for', null, true)),
              }),
            },
          },
        },
      },
      computed_fields: p.child('computed_fields').out,
      manifest: p.child('manifest').out,
      object: p.child('object').out,
      wait_for: p.child('wait_for').out,
    },
    mutating_webhook_configuration(name, block): {
      local p = path(['kubernetes_mutating_webhook_configuration', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_mutating_webhook_configuration: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    mutating_webhook_configuration_v1(name, block): {
      local p = path(['kubernetes_mutating_webhook_configuration_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_mutating_webhook_configuration_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    namespace(name, block): {
      local p = path(['kubernetes_namespace', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_namespace: {
              [name]: std.prune({
                wait_for_default_service_account: build.template(std.get(block, 'wait_for_default_service_account', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_default_service_account: p.child('wait_for_default_service_account').out,
    },
    namespace_v1(name, block): {
      local p = path(['kubernetes_namespace_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_namespace_v1: {
              [name]: std.prune({
                wait_for_default_service_account: build.template(std.get(block, 'wait_for_default_service_account', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_default_service_account: p.child('wait_for_default_service_account').out,
    },
    network_policy(name, block): {
      local p = path(['kubernetes_network_policy', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_network_policy: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    network_policy_v1(name, block): {
      local p = path(['kubernetes_network_policy_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_network_policy_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    node_taint(name, block): {
      local p = path(['kubernetes_node_taint', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_node_taint: {
              [name]: std.prune({
                field_manager: build.template(std.get(block, 'field_manager', null, true)),
                force: build.template(std.get(block, 'force', null, true)),
              }),
            },
          },
        },
      },
      field_manager: p.child('field_manager').out,
      force: p.child('force').out,
      id: p.child('id').out,
    },
    persistent_volume(name, block): {
      local p = path(['kubernetes_persistent_volume', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_persistent_volume: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    persistent_volume_claim(name, block): {
      local p = path(['kubernetes_persistent_volume_claim', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_persistent_volume_claim: {
              [name]: std.prune({
                wait_until_bound: build.template(std.get(block, 'wait_until_bound', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_until_bound: p.child('wait_until_bound').out,
    },
    persistent_volume_claim_v1(name, block): {
      local p = path(['kubernetes_persistent_volume_claim_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_persistent_volume_claim_v1: {
              [name]: std.prune({
                wait_until_bound: build.template(std.get(block, 'wait_until_bound', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_until_bound: p.child('wait_until_bound').out,
    },
    persistent_volume_v1(name, block): {
      local p = path(['kubernetes_persistent_volume_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_persistent_volume_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    pod(name, block): {
      local p = path(['kubernetes_pod', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_pod: {
              [name]: std.prune({
                target_state: build.template(std.get(block, 'target_state', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      target_state: p.child('target_state').out,
    },
    pod_disruption_budget(name, block): {
      local p = path(['kubernetes_pod_disruption_budget', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_pod_disruption_budget: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    pod_disruption_budget_v1(name, block): {
      local p = path(['kubernetes_pod_disruption_budget_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_pod_disruption_budget_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    pod_security_policy(name, block): {
      local p = path(['kubernetes_pod_security_policy', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_pod_security_policy: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    pod_security_policy_v1beta1(name, block): {
      local p = path(['kubernetes_pod_security_policy_v1beta1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_pod_security_policy_v1beta1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    pod_v1(name, block): {
      local p = path(['kubernetes_pod_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_pod_v1: {
              [name]: std.prune({
                target_state: build.template(std.get(block, 'target_state', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      target_state: p.child('target_state').out,
    },
    priority_class(name, block): {
      local p = path(['kubernetes_priority_class', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_priority_class: {
              [name]: std.prune({
                description: build.template(std.get(block, 'description', null, true)),
                global_default: build.template(std.get(block, 'global_default', null, true)),
                preemption_policy: build.template(std.get(block, 'preemption_policy', null, true)),
                value: build.template(block.value),
              }),
            },
          },
        },
      },
      description: p.child('description').out,
      global_default: p.child('global_default').out,
      id: p.child('id').out,
      preemption_policy: p.child('preemption_policy').out,
      value: p.child('value').out,
    },
    priority_class_v1(name, block): {
      local p = path(['kubernetes_priority_class_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_priority_class_v1: {
              [name]: std.prune({
                description: build.template(std.get(block, 'description', null, true)),
                global_default: build.template(std.get(block, 'global_default', null, true)),
                preemption_policy: build.template(std.get(block, 'preemption_policy', null, true)),
                value: build.template(block.value),
              }),
            },
          },
        },
      },
      description: p.child('description').out,
      global_default: p.child('global_default').out,
      id: p.child('id').out,
      preemption_policy: p.child('preemption_policy').out,
      value: p.child('value').out,
    },
    replication_controller(name, block): {
      local p = path(['kubernetes_replication_controller', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_replication_controller: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    replication_controller_v1(name, block): {
      local p = path(['kubernetes_replication_controller_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_replication_controller_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    resource_quota(name, block): {
      local p = path(['kubernetes_resource_quota', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_resource_quota: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    resource_quota_v1(name, block): {
      local p = path(['kubernetes_resource_quota_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_resource_quota_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    role(name, block): {
      local p = path(['kubernetes_role', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_role: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    role_binding(name, block): {
      local p = path(['kubernetes_role_binding', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_role_binding: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    role_binding_v1(name, block): {
      local p = path(['kubernetes_role_binding_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_role_binding_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    role_v1(name, block): {
      local p = path(['kubernetes_role_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_role_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    runtime_class_v1(name, block): {
      local p = path(['kubernetes_runtime_class_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_runtime_class_v1: {
              [name]: std.prune({
                handler: build.template(block.handler),
              }),
            },
          },
        },
      },
      handler: p.child('handler').out,
      id: p.child('id').out,
    },
    secret(name, block): {
      local p = path(['kubernetes_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_secret: {
              [name]: std.prune({
                binary_data: build.template(std.get(block, 'binary_data', null, true)),
                immutable: build.template(std.get(block, 'immutable', null, true)),
                type: build.template(std.get(block, 'type', null, true)),
                wait_for_service_account_token: build.template(std.get(block, 'wait_for_service_account_token', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
      type: p.child('type').out,
      wait_for_service_account_token: p.child('wait_for_service_account_token').out,
    },
    secret_v1(name, block): {
      local p = path(['kubernetes_secret_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_secret_v1: {
              [name]: std.prune({
                binary_data: build.template(std.get(block, 'binary_data', null, true)),
                immutable: build.template(std.get(block, 'immutable', null, true)),
                type: build.template(std.get(block, 'type', null, true)),
                wait_for_service_account_token: build.template(std.get(block, 'wait_for_service_account_token', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
      type: p.child('type').out,
      wait_for_service_account_token: p.child('wait_for_service_account_token').out,
    },
    service(name, block): {
      local p = path(['kubernetes_service', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_service: {
              [name]: std.prune({
                wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      status: p.child('status').out,
      wait_for_load_balancer: p.child('wait_for_load_balancer').out,
    },
    service_account(name, block): {
      local p = path(['kubernetes_service_account', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_service_account: {
              [name]: std.prune({
                automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null, true)),
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').out,
      default_secret_name: p.child('default_secret_name').out,
      id: p.child('id').out,
    },
    service_account_v1(name, block): {
      local p = path(['kubernetes_service_account_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_service_account_v1: {
              [name]: std.prune({
                automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null, true)),
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').out,
      default_secret_name: p.child('default_secret_name').out,
      id: p.child('id').out,
    },
    service_v1(name, block): {
      local p = path(['kubernetes_service_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_service_v1: {
              [name]: std.prune({
                wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      status: p.child('status').out,
      wait_for_load_balancer: p.child('wait_for_load_balancer').out,
    },
    stateful_set(name, block): {
      local p = path(['kubernetes_stateful_set', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_stateful_set: {
              [name]: std.prune({
                wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_rollout: p.child('wait_for_rollout').out,
    },
    stateful_set_v1(name, block): {
      local p = path(['kubernetes_stateful_set_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_stateful_set_v1: {
              [name]: std.prune({
                wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      wait_for_rollout: p.child('wait_for_rollout').out,
    },
    storage_class(name, block): {
      local p = path(['kubernetes_storage_class', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_storage_class: {
              [name]: std.prune({
                allow_volume_expansion: build.template(std.get(block, 'allow_volume_expansion', null, true)),
                mount_options: build.template(std.get(block, 'mount_options', null, true)),
                parameters: build.template(std.get(block, 'parameters', null, true)),
                reclaim_policy: build.template(std.get(block, 'reclaim_policy', null, true)),
                storage_provisioner: build.template(block.storage_provisioner),
                volume_binding_mode: build.template(std.get(block, 'volume_binding_mode', null, true)),
              }),
            },
          },
        },
      },
      allow_volume_expansion: p.child('allow_volume_expansion').out,
      id: p.child('id').out,
      mount_options: p.child('mount_options').out,
      parameters: p.child('parameters').out,
      reclaim_policy: p.child('reclaim_policy').out,
      storage_provisioner: p.child('storage_provisioner').out,
      volume_binding_mode: p.child('volume_binding_mode').out,
    },
    storage_class_v1(name, block): {
      local p = path(['kubernetes_storage_class_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_storage_class_v1: {
              [name]: std.prune({
                allow_volume_expansion: build.template(std.get(block, 'allow_volume_expansion', null, true)),
                mount_options: build.template(std.get(block, 'mount_options', null, true)),
                parameters: build.template(std.get(block, 'parameters', null, true)),
                reclaim_policy: build.template(std.get(block, 'reclaim_policy', null, true)),
                storage_provisioner: build.template(block.storage_provisioner),
                volume_binding_mode: build.template(std.get(block, 'volume_binding_mode', null, true)),
              }),
            },
          },
        },
      },
      allow_volume_expansion: p.child('allow_volume_expansion').out,
      id: p.child('id').out,
      mount_options: p.child('mount_options').out,
      parameters: p.child('parameters').out,
      reclaim_policy: p.child('reclaim_policy').out,
      storage_provisioner: p.child('storage_provisioner').out,
      volume_binding_mode: p.child('volume_binding_mode').out,
    },
    token_request_v1(name, block): {
      local p = path(['kubernetes_token_request_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_token_request_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      token: p.child('token').out,
    },
    validating_webhook_configuration(name, block): {
      local p = path(['kubernetes_validating_webhook_configuration', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_validating_webhook_configuration: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    validating_webhook_configuration_v1(name, block): {
      local p = path(['kubernetes_validating_webhook_configuration_v1', name]),
      _: p.out._ {
        block: {
          resource: {
            kubernetes_validating_webhook_configuration_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
  },
  data: {
    all_namespaces(name, block): {
      local p = path(['data', 'kubernetes_all_namespaces', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_all_namespaces: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      namespaces: p.child('namespaces').out,
    },
    config_map(name, block): {
      local p = path(['data', 'kubernetes_config_map', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_config_map: {
              [name]: std.prune({
                immutable: build.template(std.get(block, 'immutable', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
    },
    config_map_v1(name, block): {
      local p = path(['data', 'kubernetes_config_map_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_config_map_v1: {
              [name]: std.prune({
                immutable: build.template(std.get(block, 'immutable', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
    },
    endpoints_v1(name, block): {
      local p = path(['data', 'kubernetes_endpoints_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_endpoints_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    ingress(name, block): {
      local p = path(['data', 'kubernetes_ingress', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_ingress: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
      status: p.child('status').out,
    },
    ingress_v1(name, block): {
      local p = path(['data', 'kubernetes_ingress_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_ingress_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
      status: p.child('status').out,
    },
    mutating_webhook_configuration_v1(name, block): {
      local p = path(['data', 'kubernetes_mutating_webhook_configuration_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_mutating_webhook_configuration_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      webhook: p.child('webhook').out,
    },
    namespace(name, block): {
      local p = path(['data', 'kubernetes_namespace', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_namespace: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
    },
    namespace_v1(name, block): {
      local p = path(['data', 'kubernetes_namespace_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_namespace_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
    },
    nodes(name, block): {
      local p = path(['data', 'kubernetes_nodes', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_nodes: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      nodes: p.child('nodes').out,
    },
    persistent_volume_claim(name, block): {
      local p = path(['data', 'kubernetes_persistent_volume_claim', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_persistent_volume_claim: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    persistent_volume_claim_v1(name, block): {
      local p = path(['data', 'kubernetes_persistent_volume_claim_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_persistent_volume_claim_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    persistent_volume_v1(name, block): {
      local p = path(['data', 'kubernetes_persistent_volume_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_persistent_volume_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
    },
    pod(name, block): {
      local p = path(['data', 'kubernetes_pod', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_pod: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
      status: p.child('status').out,
    },
    pod_v1(name, block): {
      local p = path(['data', 'kubernetes_pod_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_pod_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
      status: p.child('status').out,
    },
    resource(name, block): {
      local p = path(['data', 'kubernetes_resource', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_resource: {
              [name]: std.prune({
                api_version: build.template(block.api_version),
                kind: build.template(block.kind),
              }),
            },
          },
        },
      },
      api_version: p.child('api_version').out,
      kind: p.child('kind').out,
      object: p.child('object').out,
    },
    resources(name, block): {
      local p = path(['data', 'kubernetes_resources', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_resources: {
              [name]: std.prune({
                api_version: build.template(block.api_version),
                field_selector: build.template(std.get(block, 'field_selector', null, true)),
                kind: build.template(block.kind),
                label_selector: build.template(std.get(block, 'label_selector', null, true)),
                limit: build.template(std.get(block, 'limit', null, true)),
                namespace: build.template(std.get(block, 'namespace', null, true)),
              }),
            },
          },
        },
      },
      api_version: p.child('api_version').out,
      field_selector: p.child('field_selector').out,
      kind: p.child('kind').out,
      label_selector: p.child('label_selector').out,
      limit: p.child('limit').out,
      namespace: p.child('namespace').out,
      objects: p.child('objects').out,
    },
    secret(name, block): {
      local p = path(['data', 'kubernetes_secret', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_secret: {
              [name]: std.prune({
                binary_data: build.template(std.get(block, 'binary_data', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
      type: p.child('type').out,
    },
    secret_v1(name, block): {
      local p = path(['data', 'kubernetes_secret_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_secret_v1: {
              [name]: std.prune({
                binary_data: build.template(std.get(block, 'binary_data', null, true)),
              }),
            },
          },
        },
      },
      binary_data: p.child('binary_data').out,
      data: p.child('data').out,
      id: p.child('id').out,
      immutable: p.child('immutable').out,
      type: p.child('type').out,
    },
    server_version(name, block): {
      local p = path(['data', 'kubernetes_server_version', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_server_version: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      build_date: p.child('build_date').out,
      compiler: p.child('compiler').out,
      git_commit: p.child('git_commit').out,
      git_tree_state: p.child('git_tree_state').out,
      git_version: p.child('git_version').out,
      go_version: p.child('go_version').out,
      id: p.child('id').out,
      major: p.child('major').out,
      minor: p.child('minor').out,
      platform: p.child('platform').out,
      version: p.child('version').out,
    },
    service(name, block): {
      local p = path(['data', 'kubernetes_service', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_service: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
      status: p.child('status').out,
    },
    service_account(name, block): {
      local p = path(['data', 'kubernetes_service_account', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_service_account: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').out,
      default_secret_name: p.child('default_secret_name').out,
      id: p.child('id').out,
      image_pull_secret: p.child('image_pull_secret').out,
      secret: p.child('secret').out,
    },
    service_account_v1(name, block): {
      local p = path(['data', 'kubernetes_service_account_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_service_account_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').out,
      default_secret_name: p.child('default_secret_name').out,
      id: p.child('id').out,
      image_pull_secret: p.child('image_pull_secret').out,
      secret: p.child('secret').out,
    },
    service_v1(name, block): {
      local p = path(['data', 'kubernetes_service_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_service_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      spec: p.child('spec').out,
      status: p.child('status').out,
    },
    storage_class(name, block): {
      local p = path(['data', 'kubernetes_storage_class', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_storage_class: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      allow_volume_expansion: p.child('allow_volume_expansion').out,
      id: p.child('id').out,
      mount_options: p.child('mount_options').out,
      parameters: p.child('parameters').out,
      reclaim_policy: p.child('reclaim_policy').out,
      storage_provisioner: p.child('storage_provisioner').out,
      volume_binding_mode: p.child('volume_binding_mode').out,
    },
    storage_class_v1(name, block): {
      local p = path(['data', 'kubernetes_storage_class_v1', name]),
      _: p.out._ {
        block: {
          data: {
            kubernetes_storage_class_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      allow_volume_expansion: p.child('allow_volume_expansion').out,
      id: p.child('id').out,
      mount_options: p.child('mount_options').out,
      parameters: p.child('parameters').out,
      reclaim_policy: p.child('reclaim_policy').out,
      storage_provisioner: p.child('storage_provisioner').out,
      volume_binding_mode: p.child('volume_binding_mode').out,
    },
  },
  func: {
    manifest_decode(manifest): func('provider::kubernetes::manifest_decode', [manifest]),
    manifest_decode_multi(manifest): func('provider::kubernetes::manifest_decode_multi', [manifest]),
    manifest_encode(manifest): func('provider::kubernetes::manifest_encode', [manifest]),
  },
};

provider
