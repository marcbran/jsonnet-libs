local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.ref else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [val] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then '${%s}' % [val._.ref] else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
};

local path(segments) = {
  ref: { _: { ref: std.join('.', segments) } },
  child(segment): path(segments + [segment]),
};

local func(name, parameters=[]) = {
  local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
  _: { ref: '%s(%s)' % [name, parameterString] },
};

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
      _: p.ref._ {
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
      annotations: p.child('annotations').ref,
      api_version: p.child('api_version').ref,
      field_manager: p.child('field_manager').ref,
      force: p.child('force').ref,
      id: p.child('id').ref,
      kind: p.child('kind').ref,
      template_annotations: p.child('template_annotations').ref,
    },
    api_service(name, block): {
      local p = path(['kubernetes_api_service', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_api_service: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    api_service_v1(name, block): {
      local p = path(['kubernetes_api_service_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_api_service_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    certificate_signing_request(name, block): {
      local p = path(['kubernetes_certificate_signing_request', name]),
      _: p.ref._ {
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
      auto_approve: p.child('auto_approve').ref,
      certificate: p.child('certificate').ref,
      id: p.child('id').ref,
    },
    certificate_signing_request_v1(name, block): {
      local p = path(['kubernetes_certificate_signing_request_v1', name]),
      _: p.ref._ {
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
      auto_approve: p.child('auto_approve').ref,
      certificate: p.child('certificate').ref,
      id: p.child('id').ref,
    },
    cluster_role(name, block): {
      local p = path(['kubernetes_cluster_role', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_cluster_role: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    cluster_role_binding(name, block): {
      local p = path(['kubernetes_cluster_role_binding', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_cluster_role_binding: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    cluster_role_binding_v1(name, block): {
      local p = path(['kubernetes_cluster_role_binding_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_cluster_role_binding_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    cluster_role_v1(name, block): {
      local p = path(['kubernetes_cluster_role_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_cluster_role_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    config_map(name, block): {
      local p = path(['kubernetes_config_map', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
    },
    config_map_v1(name, block): {
      local p = path(['kubernetes_config_map_v1', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
    },
    config_map_v1_data(name, block): {
      local p = path(['kubernetes_config_map_v1_data', name]),
      _: p.ref._ {
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
      data: p.child('data').ref,
      field_manager: p.child('field_manager').ref,
      force: p.child('force').ref,
      id: p.child('id').ref,
    },
    cron_job(name, block): {
      local p = path(['kubernetes_cron_job', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_cron_job: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    cron_job_v1(name, block): {
      local p = path(['kubernetes_cron_job_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_cron_job_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    csi_driver(name, block): {
      local p = path(['kubernetes_csi_driver', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_csi_driver: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    csi_driver_v1(name, block): {
      local p = path(['kubernetes_csi_driver_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_csi_driver_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    daemon_set_v1(name, block): {
      local p = path(['kubernetes_daemon_set_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_rollout: p.child('wait_for_rollout').ref,
    },
    daemonset(name, block): {
      local p = path(['kubernetes_daemonset', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_rollout: p.child('wait_for_rollout').ref,
    },
    default_service_account(name, block): {
      local p = path(['kubernetes_default_service_account', name]),
      _: p.ref._ {
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
      automount_service_account_token: p.child('automount_service_account_token').ref,
      default_secret_name: p.child('default_secret_name').ref,
      id: p.child('id').ref,
    },
    default_service_account_v1(name, block): {
      local p = path(['kubernetes_default_service_account_v1', name]),
      _: p.ref._ {
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
      automount_service_account_token: p.child('automount_service_account_token').ref,
      default_secret_name: p.child('default_secret_name').ref,
      id: p.child('id').ref,
    },
    deployment(name, block): {
      local p = path(['kubernetes_deployment', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_rollout: p.child('wait_for_rollout').ref,
    },
    deployment_v1(name, block): {
      local p = path(['kubernetes_deployment_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_rollout: p.child('wait_for_rollout').ref,
    },
    endpoint_slice_v1(name, block): {
      local p = path(['kubernetes_endpoint_slice_v1', name]),
      _: p.ref._ {
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
      address_type: p.child('address_type').ref,
      id: p.child('id').ref,
    },
    endpoints(name, block): {
      local p = path(['kubernetes_endpoints', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_endpoints: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    endpoints_v1(name, block): {
      local p = path(['kubernetes_endpoints_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_endpoints_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    env(name, block): {
      local p = path(['kubernetes_env', name]),
      _: p.ref._ {
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
      api_version: p.child('api_version').ref,
      container: p.child('container').ref,
      field_manager: p.child('field_manager').ref,
      force: p.child('force').ref,
      id: p.child('id').ref,
      init_container: p.child('init_container').ref,
      kind: p.child('kind').ref,
    },
    horizontal_pod_autoscaler(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    horizontal_pod_autoscaler_v1(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    horizontal_pod_autoscaler_v2(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler_v2', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler_v2: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    horizontal_pod_autoscaler_v2beta2(name, block): {
      local p = path(['kubernetes_horizontal_pod_autoscaler_v2beta2', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_horizontal_pod_autoscaler_v2beta2: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    ingress(name, block): {
      local p = path(['kubernetes_ingress', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      status: p.child('status').ref,
      wait_for_load_balancer: p.child('wait_for_load_balancer').ref,
    },
    ingress_class(name, block): {
      local p = path(['kubernetes_ingress_class', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_ingress_class: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    ingress_class_v1(name, block): {
      local p = path(['kubernetes_ingress_class_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_ingress_class_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    ingress_v1(name, block): {
      local p = path(['kubernetes_ingress_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      status: p.child('status').ref,
      wait_for_load_balancer: p.child('wait_for_load_balancer').ref,
    },
    job(name, block): {
      local p = path(['kubernetes_job', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_completion: p.child('wait_for_completion').ref,
    },
    job_v1(name, block): {
      local p = path(['kubernetes_job_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_completion: p.child('wait_for_completion').ref,
    },
    labels(name, block): {
      local p = path(['kubernetes_labels', name]),
      _: p.ref._ {
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
      api_version: p.child('api_version').ref,
      field_manager: p.child('field_manager').ref,
      force: p.child('force').ref,
      id: p.child('id').ref,
      kind: p.child('kind').ref,
      labels: p.child('labels').ref,
    },
    limit_range(name, block): {
      local p = path(['kubernetes_limit_range', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_limit_range: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    limit_range_v1(name, block): {
      local p = path(['kubernetes_limit_range_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_limit_range_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    manifest(name, block): {
      local p = path(['kubernetes_manifest', name]),
      _: p.ref._ {
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
      computed_fields: p.child('computed_fields').ref,
      manifest: p.child('manifest').ref,
      object: p.child('object').ref,
      wait_for: p.child('wait_for').ref,
    },
    mutating_webhook_configuration(name, block): {
      local p = path(['kubernetes_mutating_webhook_configuration', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_mutating_webhook_configuration: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    mutating_webhook_configuration_v1(name, block): {
      local p = path(['kubernetes_mutating_webhook_configuration_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_mutating_webhook_configuration_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    namespace(name, block): {
      local p = path(['kubernetes_namespace', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_default_service_account: p.child('wait_for_default_service_account').ref,
    },
    namespace_v1(name, block): {
      local p = path(['kubernetes_namespace_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_default_service_account: p.child('wait_for_default_service_account').ref,
    },
    network_policy(name, block): {
      local p = path(['kubernetes_network_policy', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_network_policy: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    network_policy_v1(name, block): {
      local p = path(['kubernetes_network_policy_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_network_policy_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    node_taint(name, block): {
      local p = path(['kubernetes_node_taint', name]),
      _: p.ref._ {
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
      field_manager: p.child('field_manager').ref,
      force: p.child('force').ref,
      id: p.child('id').ref,
    },
    persistent_volume(name, block): {
      local p = path(['kubernetes_persistent_volume', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_persistent_volume: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    persistent_volume_claim(name, block): {
      local p = path(['kubernetes_persistent_volume_claim', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_until_bound: p.child('wait_until_bound').ref,
    },
    persistent_volume_claim_v1(name, block): {
      local p = path(['kubernetes_persistent_volume_claim_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_until_bound: p.child('wait_until_bound').ref,
    },
    persistent_volume_v1(name, block): {
      local p = path(['kubernetes_persistent_volume_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_persistent_volume_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    pod(name, block): {
      local p = path(['kubernetes_pod', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      target_state: p.child('target_state').ref,
    },
    pod_disruption_budget(name, block): {
      local p = path(['kubernetes_pod_disruption_budget', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_pod_disruption_budget: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    pod_disruption_budget_v1(name, block): {
      local p = path(['kubernetes_pod_disruption_budget_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_pod_disruption_budget_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    pod_security_policy(name, block): {
      local p = path(['kubernetes_pod_security_policy', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_pod_security_policy: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    pod_security_policy_v1beta1(name, block): {
      local p = path(['kubernetes_pod_security_policy_v1beta1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_pod_security_policy_v1beta1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    pod_v1(name, block): {
      local p = path(['kubernetes_pod_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      target_state: p.child('target_state').ref,
    },
    priority_class(name, block): {
      local p = path(['kubernetes_priority_class', name]),
      _: p.ref._ {
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
      description: p.child('description').ref,
      global_default: p.child('global_default').ref,
      id: p.child('id').ref,
      preemption_policy: p.child('preemption_policy').ref,
      value: p.child('value').ref,
    },
    priority_class_v1(name, block): {
      local p = path(['kubernetes_priority_class_v1', name]),
      _: p.ref._ {
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
      description: p.child('description').ref,
      global_default: p.child('global_default').ref,
      id: p.child('id').ref,
      preemption_policy: p.child('preemption_policy').ref,
      value: p.child('value').ref,
    },
    replication_controller(name, block): {
      local p = path(['kubernetes_replication_controller', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_replication_controller: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    replication_controller_v1(name, block): {
      local p = path(['kubernetes_replication_controller_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_replication_controller_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    resource_quota(name, block): {
      local p = path(['kubernetes_resource_quota', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_resource_quota: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    resource_quota_v1(name, block): {
      local p = path(['kubernetes_resource_quota_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_resource_quota_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    role(name, block): {
      local p = path(['kubernetes_role', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_role: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    role_binding(name, block): {
      local p = path(['kubernetes_role_binding', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_role_binding: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    role_binding_v1(name, block): {
      local p = path(['kubernetes_role_binding_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_role_binding_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    role_v1(name, block): {
      local p = path(['kubernetes_role_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_role_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    runtime_class_v1(name, block): {
      local p = path(['kubernetes_runtime_class_v1', name]),
      _: p.ref._ {
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
      handler: p.child('handler').ref,
      id: p.child('id').ref,
    },
    secret(name, block): {
      local p = path(['kubernetes_secret', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
      type: p.child('type').ref,
      wait_for_service_account_token: p.child('wait_for_service_account_token').ref,
    },
    secret_v1(name, block): {
      local p = path(['kubernetes_secret_v1', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
      type: p.child('type').ref,
      wait_for_service_account_token: p.child('wait_for_service_account_token').ref,
    },
    service(name, block): {
      local p = path(['kubernetes_service', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      status: p.child('status').ref,
      wait_for_load_balancer: p.child('wait_for_load_balancer').ref,
    },
    service_account(name, block): {
      local p = path(['kubernetes_service_account', name]),
      _: p.ref._ {
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
      automount_service_account_token: p.child('automount_service_account_token').ref,
      default_secret_name: p.child('default_secret_name').ref,
      id: p.child('id').ref,
    },
    service_account_v1(name, block): {
      local p = path(['kubernetes_service_account_v1', name]),
      _: p.ref._ {
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
      automount_service_account_token: p.child('automount_service_account_token').ref,
      default_secret_name: p.child('default_secret_name').ref,
      id: p.child('id').ref,
    },
    service_v1(name, block): {
      local p = path(['kubernetes_service_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      status: p.child('status').ref,
      wait_for_load_balancer: p.child('wait_for_load_balancer').ref,
    },
    stateful_set(name, block): {
      local p = path(['kubernetes_stateful_set', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_rollout: p.child('wait_for_rollout').ref,
    },
    stateful_set_v1(name, block): {
      local p = path(['kubernetes_stateful_set_v1', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      wait_for_rollout: p.child('wait_for_rollout').ref,
    },
    storage_class(name, block): {
      local p = path(['kubernetes_storage_class', name]),
      _: p.ref._ {
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
      allow_volume_expansion: p.child('allow_volume_expansion').ref,
      id: p.child('id').ref,
      mount_options: p.child('mount_options').ref,
      parameters: p.child('parameters').ref,
      reclaim_policy: p.child('reclaim_policy').ref,
      storage_provisioner: p.child('storage_provisioner').ref,
      volume_binding_mode: p.child('volume_binding_mode').ref,
    },
    storage_class_v1(name, block): {
      local p = path(['kubernetes_storage_class_v1', name]),
      _: p.ref._ {
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
      allow_volume_expansion: p.child('allow_volume_expansion').ref,
      id: p.child('id').ref,
      mount_options: p.child('mount_options').ref,
      parameters: p.child('parameters').ref,
      reclaim_policy: p.child('reclaim_policy').ref,
      storage_provisioner: p.child('storage_provisioner').ref,
      volume_binding_mode: p.child('volume_binding_mode').ref,
    },
    token_request_v1(name, block): {
      local p = path(['kubernetes_token_request_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_token_request_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      token: p.child('token').ref,
    },
    validating_webhook_configuration(name, block): {
      local p = path(['kubernetes_validating_webhook_configuration', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_validating_webhook_configuration: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    validating_webhook_configuration_v1(name, block): {
      local p = path(['kubernetes_validating_webhook_configuration_v1', name]),
      _: p.ref._ {
        block: {
          resource: {
            kubernetes_validating_webhook_configuration_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
  },
  data: {
    all_namespaces(name, block): {
      local p = path(['data', 'kubernetes_all_namespaces', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_all_namespaces: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      namespaces: p.child('namespaces').ref,
    },
    config_map(name, block): {
      local p = path(['data', 'kubernetes_config_map', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
    },
    config_map_v1(name, block): {
      local p = path(['data', 'kubernetes_config_map_v1', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
    },
    endpoints_v1(name, block): {
      local p = path(['data', 'kubernetes_endpoints_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_endpoints_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    ingress(name, block): {
      local p = path(['data', 'kubernetes_ingress', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_ingress: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
      status: p.child('status').ref,
    },
    ingress_v1(name, block): {
      local p = path(['data', 'kubernetes_ingress_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_ingress_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
      status: p.child('status').ref,
    },
    mutating_webhook_configuration_v1(name, block): {
      local p = path(['data', 'kubernetes_mutating_webhook_configuration_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_mutating_webhook_configuration_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      webhook: p.child('webhook').ref,
    },
    namespace(name, block): {
      local p = path(['data', 'kubernetes_namespace', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_namespace: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
    },
    namespace_v1(name, block): {
      local p = path(['data', 'kubernetes_namespace_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_namespace_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
    },
    nodes(name, block): {
      local p = path(['data', 'kubernetes_nodes', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_nodes: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      nodes: p.child('nodes').ref,
    },
    persistent_volume_claim(name, block): {
      local p = path(['data', 'kubernetes_persistent_volume_claim', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_persistent_volume_claim: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    persistent_volume_claim_v1(name, block): {
      local p = path(['data', 'kubernetes_persistent_volume_claim_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_persistent_volume_claim_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    persistent_volume_v1(name, block): {
      local p = path(['data', 'kubernetes_persistent_volume_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_persistent_volume_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
    },
    pod(name, block): {
      local p = path(['data', 'kubernetes_pod', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_pod: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
      status: p.child('status').ref,
    },
    pod_v1(name, block): {
      local p = path(['data', 'kubernetes_pod_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_pod_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
      status: p.child('status').ref,
    },
    resource(name, block): {
      local p = path(['data', 'kubernetes_resource', name]),
      _: p.ref._ {
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
      api_version: p.child('api_version').ref,
      kind: p.child('kind').ref,
      object: p.child('object').ref,
    },
    resources(name, block): {
      local p = path(['data', 'kubernetes_resources', name]),
      _: p.ref._ {
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
      api_version: p.child('api_version').ref,
      field_selector: p.child('field_selector').ref,
      kind: p.child('kind').ref,
      label_selector: p.child('label_selector').ref,
      limit: p.child('limit').ref,
      namespace: p.child('namespace').ref,
      objects: p.child('objects').ref,
    },
    secret(name, block): {
      local p = path(['data', 'kubernetes_secret', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
      type: p.child('type').ref,
    },
    secret_v1(name, block): {
      local p = path(['data', 'kubernetes_secret_v1', name]),
      _: p.ref._ {
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
      binary_data: p.child('binary_data').ref,
      data: p.child('data').ref,
      id: p.child('id').ref,
      immutable: p.child('immutable').ref,
      type: p.child('type').ref,
    },
    server_version(name, block): {
      local p = path(['data', 'kubernetes_server_version', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_server_version: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      build_date: p.child('build_date').ref,
      compiler: p.child('compiler').ref,
      git_commit: p.child('git_commit').ref,
      git_tree_state: p.child('git_tree_state').ref,
      git_version: p.child('git_version').ref,
      go_version: p.child('go_version').ref,
      id: p.child('id').ref,
      major: p.child('major').ref,
      minor: p.child('minor').ref,
      platform: p.child('platform').ref,
      version: p.child('version').ref,
    },
    service(name, block): {
      local p = path(['data', 'kubernetes_service', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_service: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
      status: p.child('status').ref,
    },
    service_account(name, block): {
      local p = path(['data', 'kubernetes_service_account', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_service_account: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').ref,
      default_secret_name: p.child('default_secret_name').ref,
      id: p.child('id').ref,
      image_pull_secret: p.child('image_pull_secret').ref,
      secret: p.child('secret').ref,
    },
    service_account_v1(name, block): {
      local p = path(['data', 'kubernetes_service_account_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_service_account_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      automount_service_account_token: p.child('automount_service_account_token').ref,
      default_secret_name: p.child('default_secret_name').ref,
      id: p.child('id').ref,
      image_pull_secret: p.child('image_pull_secret').ref,
      secret: p.child('secret').ref,
    },
    service_v1(name, block): {
      local p = path(['data', 'kubernetes_service_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_service_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      spec: p.child('spec').ref,
      status: p.child('status').ref,
    },
    storage_class(name, block): {
      local p = path(['data', 'kubernetes_storage_class', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_storage_class: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      allow_volume_expansion: p.child('allow_volume_expansion').ref,
      id: p.child('id').ref,
      mount_options: p.child('mount_options').ref,
      parameters: p.child('parameters').ref,
      reclaim_policy: p.child('reclaim_policy').ref,
      storage_provisioner: p.child('storage_provisioner').ref,
      volume_binding_mode: p.child('volume_binding_mode').ref,
    },
    storage_class_v1(name, block): {
      local p = path(['data', 'kubernetes_storage_class_v1', name]),
      _: p.ref._ {
        block: {
          data: {
            kubernetes_storage_class_v1: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      allow_volume_expansion: p.child('allow_volume_expansion').ref,
      id: p.child('id').ref,
      mount_options: p.child('mount_options').ref,
      parameters: p.child('parameters').ref,
      reclaim_policy: p.child('reclaim_policy').ref,
      storage_provisioner: p.child('storage_provisioner').ref,
      volume_binding_mode: p.child('volume_binding_mode').ref,
    },
  },
  func: {
    manifest_decode(manifest): func('provider::kubernetes::manifest_decode', [manifest]),
    manifest_decode_multi(manifest): func('provider::kubernetes::manifest_decode_multi', [manifest]),
    manifest_encode(manifest): func('provider::kubernetes::manifest_encode', [manifest]),
  },
};

provider
