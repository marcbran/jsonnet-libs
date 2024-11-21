local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then val._.ref else '"%s"' % [std.strReplace(val._.str, '\n', '\\n')] else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [std.strReplace(val, '\n', '\\n')] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then if std.objectHas(val._, 'ref') then '${%s}' % [val._.ref] else val._.str else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  providerRequirements(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.providerRequirements else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.providerRequirements(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.providerRequirements(val[key]), val), {}) else {},
};

local providerTemplate(provider, requirements, configuration) = {
  local providerRequirements = { [provider]: requirements },
  local providerAlias = if configuration == null then null else configuration.alias,
  local providerWithAlias = if configuration == null then null else '%s.%s' % [provider, providerAlias],
  local providerConfiguration = if configuration == null then {} else { [providerWithAlias]: { provider: { [provider]: configuration } } },
  local providerReference = if configuration == null then {} else { provider: providerWithAlias },
  blockType(blockType): {
    local blockTypePath = if blockType == 'resource' then [] else ['data'],
    resource(type, name): {
      local resourceType = std.substr(type, std.length(provider) + 1, std.length(type)),
      local resourcePath = blockTypePath + [type, name],
      _(rawBlock, block): {
        local metaBlock = {
          depends_on: build.template(std.get(rawBlock, 'depends_on', null)),
          count: build.template(std.get(rawBlock, 'count', null)),
          for_each: build.template(std.get(rawBlock, 'for_each', null)),
        },
        providerRequirements: build.providerRequirements([block] + [providerRequirements]),
        providerConfiguration: providerConfiguration,
        provider: provider,
        providerAlias: providerAlias,
        resourceType: resourceType,
        name: name,
        ref: std.join('.', resourcePath),
        block: {
          [blockType]: {
            [type]: {
              [name]: std.prune(metaBlock + block + providerReference),
            },
          },
        },
      },
      field(fieldName): {
        local fieldPath = resourcePath + [fieldName],
        _: {
          ref: std.join('.', fieldPath),
        },
      },
    },
  },
  func(name, parameters=[]): {
    local parameterString = std.join(', ', [build.expression(parameter) for parameter in parameters]),
    _: {
      providerRequirements: build.providerRequirements(parameters + [providerRequirements]),
      providerConfiguration: providerConfiguration,
      ref: 'provider::%s::%s(%s)' % [provider, name, parameterString],
    },
  },
};

local provider(configuration) = {
  local requirements = {
    source: 'registry.terraform.io/hashicorp/kubernetes',
    version: '2.33.0',
  },
  local provider = providerTemplate('kubernetes', requirements, configuration),
  resource: {
    local blockType = provider.blockType('resource'),
    annotations(name, block): {
      local resource = blockType.resource('kubernetes_annotations', name),
      _: resource._(block, {
        annotations: build.template(std.get(block, 'annotations', null)),
        api_version: build.template(block.api_version),
        field_manager: build.template(std.get(block, 'field_manager', null)),
        force: build.template(std.get(block, 'force', null)),
        id: build.template(std.get(block, 'id', null)),
        kind: build.template(block.kind),
        template_annotations: build.template(std.get(block, 'template_annotations', null)),
      }),
      annotations: resource.field('annotations'),
      api_version: resource.field('api_version'),
      field_manager: resource.field('field_manager'),
      force: resource.field('force'),
      id: resource.field('id'),
      kind: resource.field('kind'),
      template_annotations: resource.field('template_annotations'),
    },
    api_service(name, block): {
      local resource = blockType.resource('kubernetes_api_service', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    api_service_v1(name, block): {
      local resource = blockType.resource('kubernetes_api_service_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    certificate_signing_request(name, block): {
      local resource = blockType.resource('kubernetes_certificate_signing_request', name),
      _: resource._(block, {
        auto_approve: build.template(std.get(block, 'auto_approve', null)),
        certificate: build.template(std.get(block, 'certificate', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      auto_approve: resource.field('auto_approve'),
      certificate: resource.field('certificate'),
      id: resource.field('id'),
    },
    certificate_signing_request_v1(name, block): {
      local resource = blockType.resource('kubernetes_certificate_signing_request_v1', name),
      _: resource._(block, {
        auto_approve: build.template(std.get(block, 'auto_approve', null)),
        certificate: build.template(std.get(block, 'certificate', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      auto_approve: resource.field('auto_approve'),
      certificate: resource.field('certificate'),
      id: resource.field('id'),
    },
    cluster_role(name, block): {
      local resource = blockType.resource('kubernetes_cluster_role', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    cluster_role_binding(name, block): {
      local resource = blockType.resource('kubernetes_cluster_role_binding', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    cluster_role_binding_v1(name, block): {
      local resource = blockType.resource('kubernetes_cluster_role_binding_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    cluster_role_v1(name, block): {
      local resource = blockType.resource('kubernetes_cluster_role_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    config_map(name, block): {
      local resource = blockType.resource('kubernetes_config_map', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
    },
    config_map_v1(name, block): {
      local resource = blockType.resource('kubernetes_config_map_v1', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
    },
    config_map_v1_data(name, block): {
      local resource = blockType.resource('kubernetes_config_map_v1_data', name),
      _: resource._(block, {
        data: build.template(block.data),
        field_manager: build.template(std.get(block, 'field_manager', null)),
        force: build.template(std.get(block, 'force', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      data: resource.field('data'),
      field_manager: resource.field('field_manager'),
      force: resource.field('force'),
      id: resource.field('id'),
    },
    cron_job(name, block): {
      local resource = blockType.resource('kubernetes_cron_job', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    cron_job_v1(name, block): {
      local resource = blockType.resource('kubernetes_cron_job_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    csi_driver(name, block): {
      local resource = blockType.resource('kubernetes_csi_driver', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    csi_driver_v1(name, block): {
      local resource = blockType.resource('kubernetes_csi_driver_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    daemon_set_v1(name, block): {
      local resource = blockType.resource('kubernetes_daemon_set_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null)),
      }),
      id: resource.field('id'),
      wait_for_rollout: resource.field('wait_for_rollout'),
    },
    daemonset(name, block): {
      local resource = blockType.resource('kubernetes_daemonset', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null)),
      }),
      id: resource.field('id'),
      wait_for_rollout: resource.field('wait_for_rollout'),
    },
    default_service_account(name, block): {
      local resource = blockType.resource('kubernetes_default_service_account', name),
      _: resource._(block, {
        automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null)),
        default_secret_name: build.template(std.get(block, 'default_secret_name', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      automount_service_account_token: resource.field('automount_service_account_token'),
      default_secret_name: resource.field('default_secret_name'),
      id: resource.field('id'),
    },
    default_service_account_v1(name, block): {
      local resource = blockType.resource('kubernetes_default_service_account_v1', name),
      _: resource._(block, {
        automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null)),
        default_secret_name: build.template(std.get(block, 'default_secret_name', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      automount_service_account_token: resource.field('automount_service_account_token'),
      default_secret_name: resource.field('default_secret_name'),
      id: resource.field('id'),
    },
    deployment(name, block): {
      local resource = blockType.resource('kubernetes_deployment', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null)),
      }),
      id: resource.field('id'),
      wait_for_rollout: resource.field('wait_for_rollout'),
    },
    deployment_v1(name, block): {
      local resource = blockType.resource('kubernetes_deployment_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null)),
      }),
      id: resource.field('id'),
      wait_for_rollout: resource.field('wait_for_rollout'),
    },
    endpoint_slice_v1(name, block): {
      local resource = blockType.resource('kubernetes_endpoint_slice_v1', name),
      _: resource._(block, {
        address_type: build.template(block.address_type),
        id: build.template(std.get(block, 'id', null)),
      }),
      address_type: resource.field('address_type'),
      id: resource.field('id'),
    },
    endpoints(name, block): {
      local resource = blockType.resource('kubernetes_endpoints', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    endpoints_v1(name, block): {
      local resource = blockType.resource('kubernetes_endpoints_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    env(name, block): {
      local resource = blockType.resource('kubernetes_env', name),
      _: resource._(block, {
        api_version: build.template(block.api_version),
        container: build.template(std.get(block, 'container', null)),
        field_manager: build.template(std.get(block, 'field_manager', null)),
        force: build.template(std.get(block, 'force', null)),
        id: build.template(std.get(block, 'id', null)),
        init_container: build.template(std.get(block, 'init_container', null)),
        kind: build.template(block.kind),
      }),
      api_version: resource.field('api_version'),
      container: resource.field('container'),
      field_manager: resource.field('field_manager'),
      force: resource.field('force'),
      id: resource.field('id'),
      init_container: resource.field('init_container'),
      kind: resource.field('kind'),
    },
    horizontal_pod_autoscaler(name, block): {
      local resource = blockType.resource('kubernetes_horizontal_pod_autoscaler', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    horizontal_pod_autoscaler_v1(name, block): {
      local resource = blockType.resource('kubernetes_horizontal_pod_autoscaler_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    horizontal_pod_autoscaler_v2(name, block): {
      local resource = blockType.resource('kubernetes_horizontal_pod_autoscaler_v2', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    horizontal_pod_autoscaler_v2beta2(name, block): {
      local resource = blockType.resource('kubernetes_horizontal_pod_autoscaler_v2beta2', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    ingress(name, block): {
      local resource = blockType.resource('kubernetes_ingress', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        status: build.template(std.get(block, 'status', null)),
        wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null)),
      }),
      id: resource.field('id'),
      status: resource.field('status'),
      wait_for_load_balancer: resource.field('wait_for_load_balancer'),
    },
    ingress_class(name, block): {
      local resource = blockType.resource('kubernetes_ingress_class', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    ingress_class_v1(name, block): {
      local resource = blockType.resource('kubernetes_ingress_class_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    ingress_v1(name, block): {
      local resource = blockType.resource('kubernetes_ingress_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        status: build.template(std.get(block, 'status', null)),
        wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null)),
      }),
      id: resource.field('id'),
      status: resource.field('status'),
      wait_for_load_balancer: resource.field('wait_for_load_balancer'),
    },
    job(name, block): {
      local resource = blockType.resource('kubernetes_job', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_completion: build.template(std.get(block, 'wait_for_completion', null)),
      }),
      id: resource.field('id'),
      wait_for_completion: resource.field('wait_for_completion'),
    },
    job_v1(name, block): {
      local resource = blockType.resource('kubernetes_job_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_completion: build.template(std.get(block, 'wait_for_completion', null)),
      }),
      id: resource.field('id'),
      wait_for_completion: resource.field('wait_for_completion'),
    },
    labels(name, block): {
      local resource = blockType.resource('kubernetes_labels', name),
      _: resource._(block, {
        api_version: build.template(block.api_version),
        field_manager: build.template(std.get(block, 'field_manager', null)),
        force: build.template(std.get(block, 'force', null)),
        id: build.template(std.get(block, 'id', null)),
        kind: build.template(block.kind),
        labels: build.template(block.labels),
      }),
      api_version: resource.field('api_version'),
      field_manager: resource.field('field_manager'),
      force: resource.field('force'),
      id: resource.field('id'),
      kind: resource.field('kind'),
      labels: resource.field('labels'),
    },
    limit_range(name, block): {
      local resource = blockType.resource('kubernetes_limit_range', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    limit_range_v1(name, block): {
      local resource = blockType.resource('kubernetes_limit_range_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    manifest(name, block): {
      local resource = blockType.resource('kubernetes_manifest', name),
      _: resource._(block, {
        computed_fields: build.template(std.get(block, 'computed_fields', null)),
        manifest: build.template(block.manifest),
        object: build.template(std.get(block, 'object', null)),
        wait_for: build.template(std.get(block, 'wait_for', null)),
      }),
      computed_fields: resource.field('computed_fields'),
      manifest: resource.field('manifest'),
      object: resource.field('object'),
      wait_for: resource.field('wait_for'),
    },
    mutating_webhook_configuration(name, block): {
      local resource = blockType.resource('kubernetes_mutating_webhook_configuration', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    mutating_webhook_configuration_v1(name, block): {
      local resource = blockType.resource('kubernetes_mutating_webhook_configuration_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    namespace(name, block): {
      local resource = blockType.resource('kubernetes_namespace', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_default_service_account: build.template(std.get(block, 'wait_for_default_service_account', null)),
      }),
      id: resource.field('id'),
      wait_for_default_service_account: resource.field('wait_for_default_service_account'),
    },
    namespace_v1(name, block): {
      local resource = blockType.resource('kubernetes_namespace_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_default_service_account: build.template(std.get(block, 'wait_for_default_service_account', null)),
      }),
      id: resource.field('id'),
      wait_for_default_service_account: resource.field('wait_for_default_service_account'),
    },
    network_policy(name, block): {
      local resource = blockType.resource('kubernetes_network_policy', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    network_policy_v1(name, block): {
      local resource = blockType.resource('kubernetes_network_policy_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    node_taint(name, block): {
      local resource = blockType.resource('kubernetes_node_taint', name),
      _: resource._(block, {
        field_manager: build.template(std.get(block, 'field_manager', null)),
        force: build.template(std.get(block, 'force', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      field_manager: resource.field('field_manager'),
      force: resource.field('force'),
      id: resource.field('id'),
    },
    persistent_volume(name, block): {
      local resource = blockType.resource('kubernetes_persistent_volume', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    persistent_volume_claim(name, block): {
      local resource = blockType.resource('kubernetes_persistent_volume_claim', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_until_bound: build.template(std.get(block, 'wait_until_bound', null)),
      }),
      id: resource.field('id'),
      wait_until_bound: resource.field('wait_until_bound'),
    },
    persistent_volume_claim_v1(name, block): {
      local resource = blockType.resource('kubernetes_persistent_volume_claim_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_until_bound: build.template(std.get(block, 'wait_until_bound', null)),
      }),
      id: resource.field('id'),
      wait_until_bound: resource.field('wait_until_bound'),
    },
    persistent_volume_v1(name, block): {
      local resource = blockType.resource('kubernetes_persistent_volume_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    pod(name, block): {
      local resource = blockType.resource('kubernetes_pod', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        target_state: build.template(std.get(block, 'target_state', null)),
      }),
      id: resource.field('id'),
      target_state: resource.field('target_state'),
    },
    pod_disruption_budget(name, block): {
      local resource = blockType.resource('kubernetes_pod_disruption_budget', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    pod_disruption_budget_v1(name, block): {
      local resource = blockType.resource('kubernetes_pod_disruption_budget_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    pod_security_policy(name, block): {
      local resource = blockType.resource('kubernetes_pod_security_policy', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    pod_security_policy_v1beta1(name, block): {
      local resource = blockType.resource('kubernetes_pod_security_policy_v1beta1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    pod_v1(name, block): {
      local resource = blockType.resource('kubernetes_pod_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        target_state: build.template(std.get(block, 'target_state', null)),
      }),
      id: resource.field('id'),
      target_state: resource.field('target_state'),
    },
    priority_class(name, block): {
      local resource = blockType.resource('kubernetes_priority_class', name),
      _: resource._(block, {
        description: build.template(std.get(block, 'description', null)),
        global_default: build.template(std.get(block, 'global_default', null)),
        id: build.template(std.get(block, 'id', null)),
        preemption_policy: build.template(std.get(block, 'preemption_policy', null)),
        value: build.template(block.value),
      }),
      description: resource.field('description'),
      global_default: resource.field('global_default'),
      id: resource.field('id'),
      preemption_policy: resource.field('preemption_policy'),
      value: resource.field('value'),
    },
    priority_class_v1(name, block): {
      local resource = blockType.resource('kubernetes_priority_class_v1', name),
      _: resource._(block, {
        description: build.template(std.get(block, 'description', null)),
        global_default: build.template(std.get(block, 'global_default', null)),
        id: build.template(std.get(block, 'id', null)),
        preemption_policy: build.template(std.get(block, 'preemption_policy', null)),
        value: build.template(block.value),
      }),
      description: resource.field('description'),
      global_default: resource.field('global_default'),
      id: resource.field('id'),
      preemption_policy: resource.field('preemption_policy'),
      value: resource.field('value'),
    },
    replication_controller(name, block): {
      local resource = blockType.resource('kubernetes_replication_controller', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    replication_controller_v1(name, block): {
      local resource = blockType.resource('kubernetes_replication_controller_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    resource_quota(name, block): {
      local resource = blockType.resource('kubernetes_resource_quota', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    resource_quota_v1(name, block): {
      local resource = blockType.resource('kubernetes_resource_quota_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    role(name, block): {
      local resource = blockType.resource('kubernetes_role', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    role_binding(name, block): {
      local resource = blockType.resource('kubernetes_role_binding', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    role_binding_v1(name, block): {
      local resource = blockType.resource('kubernetes_role_binding_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    role_v1(name, block): {
      local resource = blockType.resource('kubernetes_role_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    runtime_class_v1(name, block): {
      local resource = blockType.resource('kubernetes_runtime_class_v1', name),
      _: resource._(block, {
        handler: build.template(block.handler),
        id: build.template(std.get(block, 'id', null)),
      }),
      handler: resource.field('handler'),
      id: resource.field('id'),
    },
    secret(name, block): {
      local resource = blockType.resource('kubernetes_secret', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
        type: build.template(std.get(block, 'type', null)),
        wait_for_service_account_token: build.template(std.get(block, 'wait_for_service_account_token', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
      type: resource.field('type'),
      wait_for_service_account_token: resource.field('wait_for_service_account_token'),
    },
    secret_v1(name, block): {
      local resource = blockType.resource('kubernetes_secret_v1', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
        type: build.template(std.get(block, 'type', null)),
        wait_for_service_account_token: build.template(std.get(block, 'wait_for_service_account_token', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
      type: resource.field('type'),
      wait_for_service_account_token: resource.field('wait_for_service_account_token'),
    },
    service(name, block): {
      local resource = blockType.resource('kubernetes_service', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        status: build.template(std.get(block, 'status', null)),
        wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null)),
      }),
      id: resource.field('id'),
      status: resource.field('status'),
      wait_for_load_balancer: resource.field('wait_for_load_balancer'),
    },
    service_account(name, block): {
      local resource = blockType.resource('kubernetes_service_account', name),
      _: resource._(block, {
        automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null)),
        default_secret_name: build.template(std.get(block, 'default_secret_name', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      automount_service_account_token: resource.field('automount_service_account_token'),
      default_secret_name: resource.field('default_secret_name'),
      id: resource.field('id'),
    },
    service_account_v1(name, block): {
      local resource = blockType.resource('kubernetes_service_account_v1', name),
      _: resource._(block, {
        automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null)),
        default_secret_name: build.template(std.get(block, 'default_secret_name', null)),
        id: build.template(std.get(block, 'id', null)),
      }),
      automount_service_account_token: resource.field('automount_service_account_token'),
      default_secret_name: resource.field('default_secret_name'),
      id: resource.field('id'),
    },
    service_v1(name, block): {
      local resource = blockType.resource('kubernetes_service_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        status: build.template(std.get(block, 'status', null)),
        wait_for_load_balancer: build.template(std.get(block, 'wait_for_load_balancer', null)),
      }),
      id: resource.field('id'),
      status: resource.field('status'),
      wait_for_load_balancer: resource.field('wait_for_load_balancer'),
    },
    stateful_set(name, block): {
      local resource = blockType.resource('kubernetes_stateful_set', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null)),
      }),
      id: resource.field('id'),
      wait_for_rollout: resource.field('wait_for_rollout'),
    },
    stateful_set_v1(name, block): {
      local resource = blockType.resource('kubernetes_stateful_set_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        wait_for_rollout: build.template(std.get(block, 'wait_for_rollout', null)),
      }),
      id: resource.field('id'),
      wait_for_rollout: resource.field('wait_for_rollout'),
    },
    storage_class(name, block): {
      local resource = blockType.resource('kubernetes_storage_class', name),
      _: resource._(block, {
        allow_volume_expansion: build.template(std.get(block, 'allow_volume_expansion', null)),
        id: build.template(std.get(block, 'id', null)),
        mount_options: build.template(std.get(block, 'mount_options', null)),
        parameters: build.template(std.get(block, 'parameters', null)),
        reclaim_policy: build.template(std.get(block, 'reclaim_policy', null)),
        storage_provisioner: build.template(block.storage_provisioner),
        volume_binding_mode: build.template(std.get(block, 'volume_binding_mode', null)),
      }),
      allow_volume_expansion: resource.field('allow_volume_expansion'),
      id: resource.field('id'),
      mount_options: resource.field('mount_options'),
      parameters: resource.field('parameters'),
      reclaim_policy: resource.field('reclaim_policy'),
      storage_provisioner: resource.field('storage_provisioner'),
      volume_binding_mode: resource.field('volume_binding_mode'),
    },
    storage_class_v1(name, block): {
      local resource = blockType.resource('kubernetes_storage_class_v1', name),
      _: resource._(block, {
        allow_volume_expansion: build.template(std.get(block, 'allow_volume_expansion', null)),
        id: build.template(std.get(block, 'id', null)),
        mount_options: build.template(std.get(block, 'mount_options', null)),
        parameters: build.template(std.get(block, 'parameters', null)),
        reclaim_policy: build.template(std.get(block, 'reclaim_policy', null)),
        storage_provisioner: build.template(block.storage_provisioner),
        volume_binding_mode: build.template(std.get(block, 'volume_binding_mode', null)),
      }),
      allow_volume_expansion: resource.field('allow_volume_expansion'),
      id: resource.field('id'),
      mount_options: resource.field('mount_options'),
      parameters: resource.field('parameters'),
      reclaim_policy: resource.field('reclaim_policy'),
      storage_provisioner: resource.field('storage_provisioner'),
      volume_binding_mode: resource.field('volume_binding_mode'),
    },
    token_request_v1(name, block): {
      local resource = blockType.resource('kubernetes_token_request_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        token: build.template(std.get(block, 'token', null)),
      }),
      id: resource.field('id'),
      token: resource.field('token'),
    },
    validating_webhook_configuration(name, block): {
      local resource = blockType.resource('kubernetes_validating_webhook_configuration', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    validating_webhook_configuration_v1(name, block): {
      local resource = blockType.resource('kubernetes_validating_webhook_configuration_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
  },
  data: {
    local blockType = provider.blockType('data'),
    all_namespaces(name, block): {
      local resource = blockType.resource('kubernetes_all_namespaces', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        namespaces: build.template(std.get(block, 'namespaces', null)),
      }),
      id: resource.field('id'),
      namespaces: resource.field('namespaces'),
    },
    config_map(name, block): {
      local resource = blockType.resource('kubernetes_config_map', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
    },
    config_map_v1(name, block): {
      local resource = blockType.resource('kubernetes_config_map_v1', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
    },
    endpoints_v1(name, block): {
      local resource = blockType.resource('kubernetes_endpoints_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    ingress(name, block): {
      local resource = blockType.resource('kubernetes_ingress', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
        status: build.template(std.get(block, 'status', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
      status: resource.field('status'),
    },
    ingress_v1(name, block): {
      local resource = blockType.resource('kubernetes_ingress_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
        status: build.template(std.get(block, 'status', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
      status: resource.field('status'),
    },
    mutating_webhook_configuration_v1(name, block): {
      local resource = blockType.resource('kubernetes_mutating_webhook_configuration_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        webhook: build.template(std.get(block, 'webhook', null)),
      }),
      id: resource.field('id'),
      webhook: resource.field('webhook'),
    },
    namespace(name, block): {
      local resource = blockType.resource('kubernetes_namespace', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
    },
    namespace_v1(name, block): {
      local resource = blockType.resource('kubernetes_namespace_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
    },
    nodes(name, block): {
      local resource = blockType.resource('kubernetes_nodes', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        nodes: build.template(std.get(block, 'nodes', null)),
      }),
      id: resource.field('id'),
      nodes: resource.field('nodes'),
    },
    persistent_volume_claim(name, block): {
      local resource = blockType.resource('kubernetes_persistent_volume_claim', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    persistent_volume_claim_v1(name, block): {
      local resource = blockType.resource('kubernetes_persistent_volume_claim_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    persistent_volume_v1(name, block): {
      local resource = blockType.resource('kubernetes_persistent_volume_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
      }),
      id: resource.field('id'),
    },
    pod(name, block): {
      local resource = blockType.resource('kubernetes_pod', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
        status: build.template(std.get(block, 'status', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
      status: resource.field('status'),
    },
    pod_v1(name, block): {
      local resource = blockType.resource('kubernetes_pod_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
        status: build.template(std.get(block, 'status', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
      status: resource.field('status'),
    },
    resource(name, block): {
      local resource = blockType.resource('kubernetes_resource', name),
      _: resource._(block, {
        api_version: build.template(block.api_version),
        kind: build.template(block.kind),
        object: build.template(std.get(block, 'object', null)),
      }),
      api_version: resource.field('api_version'),
      kind: resource.field('kind'),
      object: resource.field('object'),
    },
    resources(name, block): {
      local resource = blockType.resource('kubernetes_resources', name),
      _: resource._(block, {
        api_version: build.template(block.api_version),
        field_selector: build.template(std.get(block, 'field_selector', null)),
        kind: build.template(block.kind),
        label_selector: build.template(std.get(block, 'label_selector', null)),
        limit: build.template(std.get(block, 'limit', null)),
        namespace: build.template(std.get(block, 'namespace', null)),
        objects: build.template(std.get(block, 'objects', null)),
      }),
      api_version: resource.field('api_version'),
      field_selector: resource.field('field_selector'),
      kind: resource.field('kind'),
      label_selector: resource.field('label_selector'),
      limit: resource.field('limit'),
      namespace: resource.field('namespace'),
      objects: resource.field('objects'),
    },
    secret(name, block): {
      local resource = blockType.resource('kubernetes_secret', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
        type: build.template(std.get(block, 'type', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
      type: resource.field('type'),
    },
    secret_v1(name, block): {
      local resource = blockType.resource('kubernetes_secret_v1', name),
      _: resource._(block, {
        binary_data: build.template(std.get(block, 'binary_data', null)),
        data: build.template(std.get(block, 'data', null)),
        id: build.template(std.get(block, 'id', null)),
        immutable: build.template(std.get(block, 'immutable', null)),
        type: build.template(std.get(block, 'type', null)),
      }),
      binary_data: resource.field('binary_data'),
      data: resource.field('data'),
      id: resource.field('id'),
      immutable: resource.field('immutable'),
      type: resource.field('type'),
    },
    server_version(name, block): {
      local resource = blockType.resource('kubernetes_server_version', name),
      _: resource._(block, {
        build_date: build.template(std.get(block, 'build_date', null)),
        compiler: build.template(std.get(block, 'compiler', null)),
        git_commit: build.template(std.get(block, 'git_commit', null)),
        git_tree_state: build.template(std.get(block, 'git_tree_state', null)),
        git_version: build.template(std.get(block, 'git_version', null)),
        go_version: build.template(std.get(block, 'go_version', null)),
        id: build.template(std.get(block, 'id', null)),
        major: build.template(std.get(block, 'major', null)),
        minor: build.template(std.get(block, 'minor', null)),
        platform: build.template(std.get(block, 'platform', null)),
        version: build.template(std.get(block, 'version', null)),
      }),
      build_date: resource.field('build_date'),
      compiler: resource.field('compiler'),
      git_commit: resource.field('git_commit'),
      git_tree_state: resource.field('git_tree_state'),
      git_version: resource.field('git_version'),
      go_version: resource.field('go_version'),
      id: resource.field('id'),
      major: resource.field('major'),
      minor: resource.field('minor'),
      platform: resource.field('platform'),
      version: resource.field('version'),
    },
    service(name, block): {
      local resource = blockType.resource('kubernetes_service', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
        status: build.template(std.get(block, 'status', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
      status: resource.field('status'),
    },
    service_account(name, block): {
      local resource = blockType.resource('kubernetes_service_account', name),
      _: resource._(block, {
        automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null)),
        default_secret_name: build.template(std.get(block, 'default_secret_name', null)),
        id: build.template(std.get(block, 'id', null)),
        image_pull_secret: build.template(std.get(block, 'image_pull_secret', null)),
        secret: build.template(std.get(block, 'secret', null)),
      }),
      automount_service_account_token: resource.field('automount_service_account_token'),
      default_secret_name: resource.field('default_secret_name'),
      id: resource.field('id'),
      image_pull_secret: resource.field('image_pull_secret'),
      secret: resource.field('secret'),
    },
    service_account_v1(name, block): {
      local resource = blockType.resource('kubernetes_service_account_v1', name),
      _: resource._(block, {
        automount_service_account_token: build.template(std.get(block, 'automount_service_account_token', null)),
        default_secret_name: build.template(std.get(block, 'default_secret_name', null)),
        id: build.template(std.get(block, 'id', null)),
        image_pull_secret: build.template(std.get(block, 'image_pull_secret', null)),
        secret: build.template(std.get(block, 'secret', null)),
      }),
      automount_service_account_token: resource.field('automount_service_account_token'),
      default_secret_name: resource.field('default_secret_name'),
      id: resource.field('id'),
      image_pull_secret: resource.field('image_pull_secret'),
      secret: resource.field('secret'),
    },
    service_v1(name, block): {
      local resource = blockType.resource('kubernetes_service_v1', name),
      _: resource._(block, {
        id: build.template(std.get(block, 'id', null)),
        spec: build.template(std.get(block, 'spec', null)),
        status: build.template(std.get(block, 'status', null)),
      }),
      id: resource.field('id'),
      spec: resource.field('spec'),
      status: resource.field('status'),
    },
    storage_class(name, block): {
      local resource = blockType.resource('kubernetes_storage_class', name),
      _: resource._(block, {
        allow_volume_expansion: build.template(std.get(block, 'allow_volume_expansion', null)),
        id: build.template(std.get(block, 'id', null)),
        mount_options: build.template(std.get(block, 'mount_options', null)),
        parameters: build.template(std.get(block, 'parameters', null)),
        reclaim_policy: build.template(std.get(block, 'reclaim_policy', null)),
        storage_provisioner: build.template(std.get(block, 'storage_provisioner', null)),
        volume_binding_mode: build.template(std.get(block, 'volume_binding_mode', null)),
      }),
      allow_volume_expansion: resource.field('allow_volume_expansion'),
      id: resource.field('id'),
      mount_options: resource.field('mount_options'),
      parameters: resource.field('parameters'),
      reclaim_policy: resource.field('reclaim_policy'),
      storage_provisioner: resource.field('storage_provisioner'),
      volume_binding_mode: resource.field('volume_binding_mode'),
    },
    storage_class_v1(name, block): {
      local resource = blockType.resource('kubernetes_storage_class_v1', name),
      _: resource._(block, {
        allow_volume_expansion: build.template(std.get(block, 'allow_volume_expansion', null)),
        id: build.template(std.get(block, 'id', null)),
        mount_options: build.template(std.get(block, 'mount_options', null)),
        parameters: build.template(std.get(block, 'parameters', null)),
        reclaim_policy: build.template(std.get(block, 'reclaim_policy', null)),
        storage_provisioner: build.template(std.get(block, 'storage_provisioner', null)),
        volume_binding_mode: build.template(std.get(block, 'volume_binding_mode', null)),
      }),
      allow_volume_expansion: resource.field('allow_volume_expansion'),
      id: resource.field('id'),
      mount_options: resource.field('mount_options'),
      parameters: resource.field('parameters'),
      reclaim_policy: resource.field('reclaim_policy'),
      storage_provisioner: resource.field('storage_provisioner'),
      volume_binding_mode: resource.field('volume_binding_mode'),
    },
  },
  func: {
    manifest_decode(manifest): provider.func('manifest_decode', [manifest]),
    manifest_decode_multi(manifest): provider.func('manifest_decode_multi', [manifest]),
    manifest_encode(manifest): provider.func('manifest_encode', [manifest]),
  },
};

local providerWithConfiguration = provider(null) + {
  withConfiguration(alias, block): provider(std.prune({
    alias: alias,
    client_certificate: build.template(std.get(block, 'client_certificate', null)),
    client_key: build.template(std.get(block, 'client_key', null)),
    cluster_ca_certificate: build.template(std.get(block, 'cluster_ca_certificate', null)),
    config_context: build.template(std.get(block, 'config_context', null)),
    config_context_auth_info: build.template(std.get(block, 'config_context_auth_info', null)),
    config_context_cluster: build.template(std.get(block, 'config_context_cluster', null)),
    config_path: build.template(std.get(block, 'config_path', null)),
    config_paths: build.template(std.get(block, 'config_paths', null)),
    host: build.template(std.get(block, 'host', null)),
    ignore_annotations: build.template(std.get(block, 'ignore_annotations', null)),
    ignore_labels: build.template(std.get(block, 'ignore_labels', null)),
    insecure: build.template(std.get(block, 'insecure', null)),
    password: build.template(std.get(block, 'password', null)),
    proxy_url: build.template(std.get(block, 'proxy_url', null)),
    tls_server_name: build.template(std.get(block, 'tls_server_name', null)),
    token: build.template(std.get(block, 'token', null)),
    username: build.template(std.get(block, 'username', null)),
  })),
};

providerWithConfiguration
