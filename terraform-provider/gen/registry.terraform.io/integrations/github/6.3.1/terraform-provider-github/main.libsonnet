local build = {
  expression(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.ref else std.mapWithKey(function(key, value) self.expression(value), val) else if std.type(val) == 'array' then std.map(function(element) self.expression(element), val) else if std.type(val) == 'string' then '"%s"' % [val] else val,
  template(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then '${%s}' % [val._.ref] else std.mapWithKey(function(key, value) self.template(value), val) else if std.type(val) == 'array' then std.map(function(element) self.template(element), val) else if std.type(val) == 'string' then val else val,
  requiredProvider(val): if std.type(val) == 'object' then if std.objectHas(val, '_') then val._.requiredProvider else std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), std.objectFields(val)), {}) else if std.type(val) == 'array' then std.foldl(function(acc, val) std.mergePatch(acc, val), std.map(function(key) build.requiredProvider(val[key]), val), {}) else {},
};

local requiredProvider = {
  _: {
    requiredProvider: {
      github: {
        source: 'registry.terraform.io/integrations/github',
        version: '6.3.1',
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
  local name = 'github',
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
    actions_environment_secret(name, block): {
      local p = path(['github_actions_environment_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_environment_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                environment: build.template(block.environment),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                repository: build.template(block.repository),
                secret_name: build.template(block.secret_name),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      environment: p.child('environment').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      repository: p.child('repository').out,
      secret_name: p.child('secret_name').out,
      updated_at: p.child('updated_at').out,
    },
    actions_environment_variable(name, block): {
      local p = path(['github_actions_environment_variable', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_environment_variable: {
              [name]: std.prune({
                environment: build.template(block.environment),
                repository: build.template(block.repository),
                value: build.template(block.value),
                variable_name: build.template(block.variable_name),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      environment: p.child('environment').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
      updated_at: p.child('updated_at').out,
      value: p.child('value').out,
      variable_name: p.child('variable_name').out,
    },
    actions_organization_oidc_subject_claim_customization_template(name, block): {
      local p = path(['github_actions_organization_oidc_subject_claim_customization_template', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_organization_oidc_subject_claim_customization_template: {
              [name]: std.prune({
                include_claim_keys: build.template(block.include_claim_keys),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      include_claim_keys: p.child('include_claim_keys').out,
    },
    actions_organization_permissions(name, block): {
      local p = path(['github_actions_organization_permissions', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_organization_permissions: {
              [name]: std.prune({
                allowed_actions: build.template(std.get(block, 'allowed_actions', null, true)),
                enabled_repositories: build.template(block.enabled_repositories),
              }),
            },
          },
        },
      },
      allowed_actions: p.child('allowed_actions').out,
      enabled_repositories: p.child('enabled_repositories').out,
      id: p.child('id').out,
    },
    actions_organization_secret(name, block): {
      local p = path(['github_actions_organization_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_organization_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                secret_name: build.template(block.secret_name),
                selected_repository_ids: build.template(std.get(block, 'selected_repository_ids', null, true)),
                visibility: build.template(block.visibility),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      secret_name: p.child('secret_name').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
      updated_at: p.child('updated_at').out,
      visibility: p.child('visibility').out,
    },
    actions_organization_secret_repositories(name, block): {
      local p = path(['github_actions_organization_secret_repositories', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_organization_secret_repositories: {
              [name]: std.prune({
                secret_name: build.template(block.secret_name),
                selected_repository_ids: build.template(block.selected_repository_ids),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      secret_name: p.child('secret_name').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
    },
    actions_organization_variable(name, block): {
      local p = path(['github_actions_organization_variable', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_organization_variable: {
              [name]: std.prune({
                selected_repository_ids: build.template(std.get(block, 'selected_repository_ids', null, true)),
                value: build.template(block.value),
                variable_name: build.template(block.variable_name),
                visibility: build.template(block.visibility),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      id: p.child('id').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
      updated_at: p.child('updated_at').out,
      value: p.child('value').out,
      variable_name: p.child('variable_name').out,
      visibility: p.child('visibility').out,
    },
    actions_repository_access_level(name, block): {
      local p = path(['github_actions_repository_access_level', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_repository_access_level: {
              [name]: std.prune({
                access_level: build.template(block.access_level),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      access_level: p.child('access_level').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    actions_repository_oidc_subject_claim_customization_template(name, block): {
      local p = path(['github_actions_repository_oidc_subject_claim_customization_template', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_repository_oidc_subject_claim_customization_template: {
              [name]: std.prune({
                include_claim_keys: build.template(std.get(block, 'include_claim_keys', null, true)),
                repository: build.template(block.repository),
                use_default: build.template(block.use_default),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      include_claim_keys: p.child('include_claim_keys').out,
      repository: p.child('repository').out,
      use_default: p.child('use_default').out,
    },
    actions_repository_permissions(name, block): {
      local p = path(['github_actions_repository_permissions', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_repository_permissions: {
              [name]: std.prune({
                allowed_actions: build.template(std.get(block, 'allowed_actions', null, true)),
                enabled: build.template(std.get(block, 'enabled', null, true)),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      allowed_actions: p.child('allowed_actions').out,
      enabled: p.child('enabled').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    actions_runner_group(name, block): {
      local p = path(['github_actions_runner_group', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_runner_group: {
              [name]: std.prune({
                allows_public_repositories: build.template(std.get(block, 'allows_public_repositories', null, true)),
                name: build.template(block.name),
                restricted_to_workflows: build.template(std.get(block, 'restricted_to_workflows', null, true)),
                selected_repository_ids: build.template(std.get(block, 'selected_repository_ids', null, true)),
                selected_workflows: build.template(std.get(block, 'selected_workflows', null, true)),
                visibility: build.template(block.visibility),
              }),
            },
          },
        },
      },
      allows_public_repositories: p.child('allows_public_repositories').out,
      default: p.child('default').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      inherited: p.child('inherited').out,
      name: p.child('name').out,
      restricted_to_workflows: p.child('restricted_to_workflows').out,
      runners_url: p.child('runners_url').out,
      selected_repositories_url: p.child('selected_repositories_url').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
      selected_workflows: p.child('selected_workflows').out,
      visibility: p.child('visibility').out,
    },
    actions_secret(name, block): {
      local p = path(['github_actions_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                repository: build.template(block.repository),
                secret_name: build.template(block.secret_name),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      repository: p.child('repository').out,
      secret_name: p.child('secret_name').out,
      updated_at: p.child('updated_at').out,
    },
    actions_variable(name, block): {
      local p = path(['github_actions_variable', name]),
      _: p.out._ {
        block: {
          resource: {
            github_actions_variable: {
              [name]: std.prune({
                repository: build.template(block.repository),
                value: build.template(block.value),
                variable_name: build.template(block.variable_name),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
      updated_at: p.child('updated_at').out,
      value: p.child('value').out,
      variable_name: p.child('variable_name').out,
    },
    app_installation_repositories(name, block): {
      local p = path(['github_app_installation_repositories', name]),
      _: p.out._ {
        block: {
          resource: {
            github_app_installation_repositories: {
              [name]: std.prune({
                installation_id: build.template(block.installation_id),
                selected_repositories: build.template(block.selected_repositories),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      installation_id: p.child('installation_id').out,
      selected_repositories: p.child('selected_repositories').out,
    },
    app_installation_repository(name, block): {
      local p = path(['github_app_installation_repository', name]),
      _: p.out._ {
        block: {
          resource: {
            github_app_installation_repository: {
              [name]: std.prune({
                installation_id: build.template(block.installation_id),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      installation_id: p.child('installation_id').out,
      repo_id: p.child('repo_id').out,
      repository: p.child('repository').out,
    },
    branch(name, block): {
      local p = path(['github_branch', name]),
      _: p.out._ {
        block: {
          resource: {
            github_branch: {
              [name]: std.prune({
                branch: build.template(block.branch),
                repository: build.template(block.repository),
                source_branch: build.template(std.get(block, 'source_branch', null, true)),
              }),
            },
          },
        },
      },
      branch: p.child('branch').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      ref: p.child('ref').out,
      repository: p.child('repository').out,
      sha: p.child('sha').out,
      source_branch: p.child('source_branch').out,
      source_sha: p.child('source_sha').out,
    },
    branch_default(name, block): {
      local p = path(['github_branch_default', name]),
      _: p.out._ {
        block: {
          resource: {
            github_branch_default: {
              [name]: std.prune({
                branch: build.template(block.branch),
                rename: build.template(std.get(block, 'rename', null, true)),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      branch: p.child('branch').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      rename: p.child('rename').out,
      repository: p.child('repository').out,
    },
    branch_protection(name, block): {
      local p = path(['github_branch_protection', name]),
      _: p.out._ {
        block: {
          resource: {
            github_branch_protection: {
              [name]: std.prune({
                allows_deletions: build.template(std.get(block, 'allows_deletions', null, true)),
                allows_force_pushes: build.template(std.get(block, 'allows_force_pushes', null, true)),
                enforce_admins: build.template(std.get(block, 'enforce_admins', null, true)),
                force_push_bypassers: build.template(std.get(block, 'force_push_bypassers', null, true)),
                lock_branch: build.template(std.get(block, 'lock_branch', null, true)),
                pattern: build.template(block.pattern),
                repository_id: build.template(block.repository_id),
                require_conversation_resolution: build.template(std.get(block, 'require_conversation_resolution', null, true)),
                require_signed_commits: build.template(std.get(block, 'require_signed_commits', null, true)),
                required_linear_history: build.template(std.get(block, 'required_linear_history', null, true)),
              }),
            },
          },
        },
      },
      allows_deletions: p.child('allows_deletions').out,
      allows_force_pushes: p.child('allows_force_pushes').out,
      enforce_admins: p.child('enforce_admins').out,
      force_push_bypassers: p.child('force_push_bypassers').out,
      id: p.child('id').out,
      lock_branch: p.child('lock_branch').out,
      pattern: p.child('pattern').out,
      repository_id: p.child('repository_id').out,
      require_conversation_resolution: p.child('require_conversation_resolution').out,
      require_signed_commits: p.child('require_signed_commits').out,
      required_linear_history: p.child('required_linear_history').out,
    },
    branch_protection_v3(name, block): {
      local p = path(['github_branch_protection_v3', name]),
      _: p.out._ {
        block: {
          resource: {
            github_branch_protection_v3: {
              [name]: std.prune({
                branch: build.template(block.branch),
                enforce_admins: build.template(std.get(block, 'enforce_admins', null, true)),
                repository: build.template(block.repository),
                require_conversation_resolution: build.template(std.get(block, 'require_conversation_resolution', null, true)),
                require_signed_commits: build.template(std.get(block, 'require_signed_commits', null, true)),
              }),
            },
          },
        },
      },
      branch: p.child('branch').out,
      enforce_admins: p.child('enforce_admins').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
      require_conversation_resolution: p.child('require_conversation_resolution').out,
      require_signed_commits: p.child('require_signed_commits').out,
    },
    codespaces_organization_secret(name, block): {
      local p = path(['github_codespaces_organization_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_codespaces_organization_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                secret_name: build.template(block.secret_name),
                selected_repository_ids: build.template(std.get(block, 'selected_repository_ids', null, true)),
                visibility: build.template(block.visibility),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      secret_name: p.child('secret_name').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
      updated_at: p.child('updated_at').out,
      visibility: p.child('visibility').out,
    },
    codespaces_organization_secret_repositories(name, block): {
      local p = path(['github_codespaces_organization_secret_repositories', name]),
      _: p.out._ {
        block: {
          resource: {
            github_codespaces_organization_secret_repositories: {
              [name]: std.prune({
                secret_name: build.template(block.secret_name),
                selected_repository_ids: build.template(block.selected_repository_ids),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      secret_name: p.child('secret_name').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
    },
    codespaces_secret(name, block): {
      local p = path(['github_codespaces_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_codespaces_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                repository: build.template(block.repository),
                secret_name: build.template(block.secret_name),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      repository: p.child('repository').out,
      secret_name: p.child('secret_name').out,
      updated_at: p.child('updated_at').out,
    },
    codespaces_user_secret(name, block): {
      local p = path(['github_codespaces_user_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_codespaces_user_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                secret_name: build.template(block.secret_name),
                selected_repository_ids: build.template(std.get(block, 'selected_repository_ids', null, true)),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      secret_name: p.child('secret_name').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
      updated_at: p.child('updated_at').out,
    },
    dependabot_organization_secret(name, block): {
      local p = path(['github_dependabot_organization_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_dependabot_organization_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                secret_name: build.template(block.secret_name),
                selected_repository_ids: build.template(std.get(block, 'selected_repository_ids', null, true)),
                visibility: build.template(block.visibility),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      secret_name: p.child('secret_name').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
      updated_at: p.child('updated_at').out,
      visibility: p.child('visibility').out,
    },
    dependabot_organization_secret_repositories(name, block): {
      local p = path(['github_dependabot_organization_secret_repositories', name]),
      _: p.out._ {
        block: {
          resource: {
            github_dependabot_organization_secret_repositories: {
              [name]: std.prune({
                secret_name: build.template(block.secret_name),
                selected_repository_ids: build.template(block.selected_repository_ids),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      secret_name: p.child('secret_name').out,
      selected_repository_ids: p.child('selected_repository_ids').out,
    },
    dependabot_secret(name, block): {
      local p = path(['github_dependabot_secret', name]),
      _: p.out._ {
        block: {
          resource: {
            github_dependabot_secret: {
              [name]: std.prune({
                encrypted_value: build.template(std.get(block, 'encrypted_value', null, true)),
                plaintext_value: build.template(std.get(block, 'plaintext_value', null, true)),
                repository: build.template(block.repository),
                secret_name: build.template(block.secret_name),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      encrypted_value: p.child('encrypted_value').out,
      id: p.child('id').out,
      plaintext_value: p.child('plaintext_value').out,
      repository: p.child('repository').out,
      secret_name: p.child('secret_name').out,
      updated_at: p.child('updated_at').out,
    },
    emu_group_mapping(name, block): {
      local p = path(['github_emu_group_mapping', name]),
      _: p.out._ {
        block: {
          resource: {
            github_emu_group_mapping: {
              [name]: std.prune({
                group_id: build.template(block.group_id),
                team_slug: build.template(block.team_slug),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      group_id: p.child('group_id').out,
      id: p.child('id').out,
      team_slug: p.child('team_slug').out,
    },
    enterprise_actions_permissions(name, block): {
      local p = path(['github_enterprise_actions_permissions', name]),
      _: p.out._ {
        block: {
          resource: {
            github_enterprise_actions_permissions: {
              [name]: std.prune({
                allowed_actions: build.template(std.get(block, 'allowed_actions', null, true)),
                enabled_organizations: build.template(block.enabled_organizations),
                enterprise_slug: build.template(block.enterprise_slug),
              }),
            },
          },
        },
      },
      allowed_actions: p.child('allowed_actions').out,
      enabled_organizations: p.child('enabled_organizations').out,
      enterprise_slug: p.child('enterprise_slug').out,
      id: p.child('id').out,
    },
    enterprise_actions_runner_group(name, block): {
      local p = path(['github_enterprise_actions_runner_group', name]),
      _: p.out._ {
        block: {
          resource: {
            github_enterprise_actions_runner_group: {
              [name]: std.prune({
                allows_public_repositories: build.template(std.get(block, 'allows_public_repositories', null, true)),
                enterprise_slug: build.template(block.enterprise_slug),
                name: build.template(block.name),
                restricted_to_workflows: build.template(std.get(block, 'restricted_to_workflows', null, true)),
                selected_organization_ids: build.template(std.get(block, 'selected_organization_ids', null, true)),
                selected_workflows: build.template(std.get(block, 'selected_workflows', null, true)),
                visibility: build.template(block.visibility),
              }),
            },
          },
        },
      },
      allows_public_repositories: p.child('allows_public_repositories').out,
      default: p.child('default').out,
      enterprise_slug: p.child('enterprise_slug').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      restricted_to_workflows: p.child('restricted_to_workflows').out,
      runners_url: p.child('runners_url').out,
      selected_organization_ids: p.child('selected_organization_ids').out,
      selected_organizations_url: p.child('selected_organizations_url').out,
      selected_workflows: p.child('selected_workflows').out,
      visibility: p.child('visibility').out,
    },
    enterprise_organization(name, block): {
      local p = path(['github_enterprise_organization', name]),
      _: p.out._ {
        block: {
          resource: {
            github_enterprise_organization: {
              [name]: std.prune({
                admin_logins: build.template(block.admin_logins),
                billing_email: build.template(block.billing_email),
                description: build.template(std.get(block, 'description', null, true)),
                display_name: build.template(std.get(block, 'display_name', null, true)),
                enterprise_id: build.template(block.enterprise_id),
                name: build.template(block.name),
              }),
            },
          },
        },
      },
      admin_logins: p.child('admin_logins').out,
      billing_email: p.child('billing_email').out,
      database_id: p.child('database_id').out,
      description: p.child('description').out,
      display_name: p.child('display_name').out,
      enterprise_id: p.child('enterprise_id').out,
      id: p.child('id').out,
      name: p.child('name').out,
    },
    issue(name, block): {
      local p = path(['github_issue', name]),
      _: p.out._ {
        block: {
          resource: {
            github_issue: {
              [name]: std.prune({
                assignees: build.template(std.get(block, 'assignees', null, true)),
                body: build.template(std.get(block, 'body', null, true)),
                labels: build.template(std.get(block, 'labels', null, true)),
                milestone_number: build.template(std.get(block, 'milestone_number', null, true)),
                repository: build.template(block.repository),
                title: build.template(block.title),
              }),
            },
          },
        },
      },
      assignees: p.child('assignees').out,
      body: p.child('body').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      issue_id: p.child('issue_id').out,
      labels: p.child('labels').out,
      milestone_number: p.child('milestone_number').out,
      number: p.child('number').out,
      repository: p.child('repository').out,
      title: p.child('title').out,
    },
    issue_label(name, block): {
      local p = path(['github_issue_label', name]),
      _: p.out._ {
        block: {
          resource: {
            github_issue_label: {
              [name]: std.prune({
                color: build.template(block.color),
                description: build.template(std.get(block, 'description', null, true)),
                name: build.template(block.name),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      color: p.child('color').out,
      description: p.child('description').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      repository: p.child('repository').out,
      url: p.child('url').out,
    },
    issue_labels(name, block): {
      local p = path(['github_issue_labels', name]),
      _: p.out._ {
        block: {
          resource: {
            github_issue_labels: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    membership(name, block): {
      local p = path(['github_membership', name]),
      _: p.out._ {
        block: {
          resource: {
            github_membership: {
              [name]: std.prune({
                downgrade_on_destroy: build.template(std.get(block, 'downgrade_on_destroy', null, true)),
                role: build.template(std.get(block, 'role', null, true)),
                username: build.template(block.username),
              }),
            },
          },
        },
      },
      downgrade_on_destroy: p.child('downgrade_on_destroy').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      role: p.child('role').out,
      username: p.child('username').out,
    },
    organization_block(name, block): {
      local p = path(['github_organization_block', name]),
      _: p.out._ {
        block: {
          resource: {
            github_organization_block: {
              [name]: std.prune({
                username: build.template(block.username),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      username: p.child('username').out,
    },
    organization_custom_role(name, block): {
      local p = path(['github_organization_custom_role', name]),
      _: p.out._ {
        block: {
          resource: {
            github_organization_custom_role: {
              [name]: std.prune({
                base_role: build.template(block.base_role),
                description: build.template(std.get(block, 'description', null, true)),
                name: build.template(block.name),
                permissions: build.template(block.permissions),
              }),
            },
          },
        },
      },
      base_role: p.child('base_role').out,
      description: p.child('description').out,
      id: p.child('id').out,
      name: p.child('name').out,
      permissions: p.child('permissions').out,
    },
    organization_project(name, block): {
      local p = path(['github_organization_project', name]),
      _: p.out._ {
        block: {
          resource: {
            github_organization_project: {
              [name]: std.prune({
                body: build.template(std.get(block, 'body', null, true)),
                name: build.template(block.name),
              }),
            },
          },
        },
      },
      body: p.child('body').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      url: p.child('url').out,
    },
    organization_ruleset(name, block): {
      local p = path(['github_organization_ruleset', name]),
      _: p.out._ {
        block: {
          resource: {
            github_organization_ruleset: {
              [name]: std.prune({
                enforcement: build.template(block.enforcement),
                name: build.template(block.name),
                target: build.template(block.target),
              }),
            },
          },
        },
      },
      enforcement: p.child('enforcement').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      ruleset_id: p.child('ruleset_id').out,
      target: p.child('target').out,
    },
    organization_security_manager(name, block): {
      local p = path(['github_organization_security_manager', name]),
      _: p.out._ {
        block: {
          resource: {
            github_organization_security_manager: {
              [name]: std.prune({
                team_slug: build.template(block.team_slug),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      team_slug: p.child('team_slug').out,
    },
    organization_settings(name, block): {
      local p = path(['github_organization_settings', name]),
      _: p.out._ {
        block: {
          resource: {
            github_organization_settings: {
              [name]: std.prune({
                advanced_security_enabled_for_new_repositories: build.template(std.get(block, 'advanced_security_enabled_for_new_repositories', null, true)),
                billing_email: build.template(block.billing_email),
                blog: build.template(std.get(block, 'blog', null, true)),
                company: build.template(std.get(block, 'company', null, true)),
                default_repository_permission: build.template(std.get(block, 'default_repository_permission', null, true)),
                dependabot_alerts_enabled_for_new_repositories: build.template(std.get(block, 'dependabot_alerts_enabled_for_new_repositories', null, true)),
                dependabot_security_updates_enabled_for_new_repositories: build.template(std.get(block, 'dependabot_security_updates_enabled_for_new_repositories', null, true)),
                dependency_graph_enabled_for_new_repositories: build.template(std.get(block, 'dependency_graph_enabled_for_new_repositories', null, true)),
                description: build.template(std.get(block, 'description', null, true)),
                email: build.template(std.get(block, 'email', null, true)),
                has_organization_projects: build.template(std.get(block, 'has_organization_projects', null, true)),
                has_repository_projects: build.template(std.get(block, 'has_repository_projects', null, true)),
                location: build.template(std.get(block, 'location', null, true)),
                members_can_create_internal_repositories: build.template(std.get(block, 'members_can_create_internal_repositories', null, true)),
                members_can_create_pages: build.template(std.get(block, 'members_can_create_pages', null, true)),
                members_can_create_private_pages: build.template(std.get(block, 'members_can_create_private_pages', null, true)),
                members_can_create_private_repositories: build.template(std.get(block, 'members_can_create_private_repositories', null, true)),
                members_can_create_public_pages: build.template(std.get(block, 'members_can_create_public_pages', null, true)),
                members_can_create_public_repositories: build.template(std.get(block, 'members_can_create_public_repositories', null, true)),
                members_can_create_repositories: build.template(std.get(block, 'members_can_create_repositories', null, true)),
                members_can_fork_private_repositories: build.template(std.get(block, 'members_can_fork_private_repositories', null, true)),
                name: build.template(std.get(block, 'name', null, true)),
                secret_scanning_enabled_for_new_repositories: build.template(std.get(block, 'secret_scanning_enabled_for_new_repositories', null, true)),
                secret_scanning_push_protection_enabled_for_new_repositories: build.template(std.get(block, 'secret_scanning_push_protection_enabled_for_new_repositories', null, true)),
                twitter_username: build.template(std.get(block, 'twitter_username', null, true)),
                web_commit_signoff_required: build.template(std.get(block, 'web_commit_signoff_required', null, true)),
              }),
            },
          },
        },
      },
      advanced_security_enabled_for_new_repositories: p.child('advanced_security_enabled_for_new_repositories').out,
      billing_email: p.child('billing_email').out,
      blog: p.child('blog').out,
      company: p.child('company').out,
      default_repository_permission: p.child('default_repository_permission').out,
      dependabot_alerts_enabled_for_new_repositories: p.child('dependabot_alerts_enabled_for_new_repositories').out,
      dependabot_security_updates_enabled_for_new_repositories: p.child('dependabot_security_updates_enabled_for_new_repositories').out,
      dependency_graph_enabled_for_new_repositories: p.child('dependency_graph_enabled_for_new_repositories').out,
      description: p.child('description').out,
      email: p.child('email').out,
      has_organization_projects: p.child('has_organization_projects').out,
      has_repository_projects: p.child('has_repository_projects').out,
      id: p.child('id').out,
      location: p.child('location').out,
      members_can_create_internal_repositories: p.child('members_can_create_internal_repositories').out,
      members_can_create_pages: p.child('members_can_create_pages').out,
      members_can_create_private_pages: p.child('members_can_create_private_pages').out,
      members_can_create_private_repositories: p.child('members_can_create_private_repositories').out,
      members_can_create_public_pages: p.child('members_can_create_public_pages').out,
      members_can_create_public_repositories: p.child('members_can_create_public_repositories').out,
      members_can_create_repositories: p.child('members_can_create_repositories').out,
      members_can_fork_private_repositories: p.child('members_can_fork_private_repositories').out,
      name: p.child('name').out,
      secret_scanning_enabled_for_new_repositories: p.child('secret_scanning_enabled_for_new_repositories').out,
      secret_scanning_push_protection_enabled_for_new_repositories: p.child('secret_scanning_push_protection_enabled_for_new_repositories').out,
      twitter_username: p.child('twitter_username').out,
      web_commit_signoff_required: p.child('web_commit_signoff_required').out,
    },
    organization_webhook(name, block): {
      local p = path(['github_organization_webhook', name]),
      _: p.out._ {
        block: {
          resource: {
            github_organization_webhook: {
              [name]: std.prune({
                active: build.template(std.get(block, 'active', null, true)),
                events: build.template(block.events),
              }),
            },
          },
        },
      },
      active: p.child('active').out,
      etag: p.child('etag').out,
      events: p.child('events').out,
      id: p.child('id').out,
      url: p.child('url').out,
    },
    project_card(name, block): {
      local p = path(['github_project_card', name]),
      _: p.out._ {
        block: {
          resource: {
            github_project_card: {
              [name]: std.prune({
                column_id: build.template(block.column_id),
                content_id: build.template(std.get(block, 'content_id', null, true)),
                content_type: build.template(std.get(block, 'content_type', null, true)),
                note: build.template(std.get(block, 'note', null, true)),
              }),
            },
          },
        },
      },
      card_id: p.child('card_id').out,
      column_id: p.child('column_id').out,
      content_id: p.child('content_id').out,
      content_type: p.child('content_type').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      note: p.child('note').out,
    },
    project_column(name, block): {
      local p = path(['github_project_column', name]),
      _: p.out._ {
        block: {
          resource: {
            github_project_column: {
              [name]: std.prune({
                name: build.template(block.name),
                project_id: build.template(block.project_id),
              }),
            },
          },
        },
      },
      column_id: p.child('column_id').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      project_id: p.child('project_id').out,
    },
    release(name, block): {
      local p = path(['github_release', name]),
      _: p.out._ {
        block: {
          resource: {
            github_release: {
              [name]: std.prune({
                body: build.template(std.get(block, 'body', null, true)),
                discussion_category_name: build.template(std.get(block, 'discussion_category_name', null, true)),
                draft: build.template(std.get(block, 'draft', null, true)),
                generate_release_notes: build.template(std.get(block, 'generate_release_notes', null, true)),
                name: build.template(std.get(block, 'name', null, true)),
                prerelease: build.template(std.get(block, 'prerelease', null, true)),
                repository: build.template(block.repository),
                tag_name: build.template(block.tag_name),
                target_commitish: build.template(std.get(block, 'target_commitish', null, true)),
              }),
            },
          },
        },
      },
      assets_url: p.child('assets_url').out,
      body: p.child('body').out,
      created_at: p.child('created_at').out,
      discussion_category_name: p.child('discussion_category_name').out,
      draft: p.child('draft').out,
      etag: p.child('etag').out,
      generate_release_notes: p.child('generate_release_notes').out,
      html_url: p.child('html_url').out,
      id: p.child('id').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      prerelease: p.child('prerelease').out,
      published_at: p.child('published_at').out,
      release_id: p.child('release_id').out,
      repository: p.child('repository').out,
      tag_name: p.child('tag_name').out,
      tarball_url: p.child('tarball_url').out,
      target_commitish: p.child('target_commitish').out,
      upload_url: p.child('upload_url').out,
      url: p.child('url').out,
      zipball_url: p.child('zipball_url').out,
    },
    repository(name, block): {
      local p = path(['github_repository', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository: {
              [name]: std.prune({
                allow_auto_merge: build.template(std.get(block, 'allow_auto_merge', null, true)),
                allow_merge_commit: build.template(std.get(block, 'allow_merge_commit', null, true)),
                allow_rebase_merge: build.template(std.get(block, 'allow_rebase_merge', null, true)),
                allow_squash_merge: build.template(std.get(block, 'allow_squash_merge', null, true)),
                allow_update_branch: build.template(std.get(block, 'allow_update_branch', null, true)),
                archive_on_destroy: build.template(std.get(block, 'archive_on_destroy', null, true)),
                archived: build.template(std.get(block, 'archived', null, true)),
                auto_init: build.template(std.get(block, 'auto_init', null, true)),
                delete_branch_on_merge: build.template(std.get(block, 'delete_branch_on_merge', null, true)),
                description: build.template(std.get(block, 'description', null, true)),
                gitignore_template: build.template(std.get(block, 'gitignore_template', null, true)),
                has_discussions: build.template(std.get(block, 'has_discussions', null, true)),
                has_downloads: build.template(std.get(block, 'has_downloads', null, true)),
                has_issues: build.template(std.get(block, 'has_issues', null, true)),
                has_projects: build.template(std.get(block, 'has_projects', null, true)),
                has_wiki: build.template(std.get(block, 'has_wiki', null, true)),
                homepage_url: build.template(std.get(block, 'homepage_url', null, true)),
                ignore_vulnerability_alerts_during_read: build.template(std.get(block, 'ignore_vulnerability_alerts_during_read', null, true)),
                is_template: build.template(std.get(block, 'is_template', null, true)),
                license_template: build.template(std.get(block, 'license_template', null, true)),
                merge_commit_message: build.template(std.get(block, 'merge_commit_message', null, true)),
                merge_commit_title: build.template(std.get(block, 'merge_commit_title', null, true)),
                name: build.template(block.name),
                squash_merge_commit_message: build.template(std.get(block, 'squash_merge_commit_message', null, true)),
                squash_merge_commit_title: build.template(std.get(block, 'squash_merge_commit_title', null, true)),
                vulnerability_alerts: build.template(std.get(block, 'vulnerability_alerts', null, true)),
                web_commit_signoff_required: build.template(std.get(block, 'web_commit_signoff_required', null, true)),
              }),
            },
          },
        },
      },
      allow_auto_merge: p.child('allow_auto_merge').out,
      allow_merge_commit: p.child('allow_merge_commit').out,
      allow_rebase_merge: p.child('allow_rebase_merge').out,
      allow_squash_merge: p.child('allow_squash_merge').out,
      allow_update_branch: p.child('allow_update_branch').out,
      archive_on_destroy: p.child('archive_on_destroy').out,
      archived: p.child('archived').out,
      auto_init: p.child('auto_init').out,
      default_branch: p.child('default_branch').out,
      delete_branch_on_merge: p.child('delete_branch_on_merge').out,
      description: p.child('description').out,
      etag: p.child('etag').out,
      full_name: p.child('full_name').out,
      git_clone_url: p.child('git_clone_url').out,
      gitignore_template: p.child('gitignore_template').out,
      has_discussions: p.child('has_discussions').out,
      has_downloads: p.child('has_downloads').out,
      has_issues: p.child('has_issues').out,
      has_projects: p.child('has_projects').out,
      has_wiki: p.child('has_wiki').out,
      homepage_url: p.child('homepage_url').out,
      html_url: p.child('html_url').out,
      http_clone_url: p.child('http_clone_url').out,
      id: p.child('id').out,
      ignore_vulnerability_alerts_during_read: p.child('ignore_vulnerability_alerts_during_read').out,
      is_template: p.child('is_template').out,
      license_template: p.child('license_template').out,
      merge_commit_message: p.child('merge_commit_message').out,
      merge_commit_title: p.child('merge_commit_title').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      primary_language: p.child('primary_language').out,
      private: p.child('private').out,
      repo_id: p.child('repo_id').out,
      squash_merge_commit_message: p.child('squash_merge_commit_message').out,
      squash_merge_commit_title: p.child('squash_merge_commit_title').out,
      ssh_clone_url: p.child('ssh_clone_url').out,
      svn_url: p.child('svn_url').out,
      topics: p.child('topics').out,
      visibility: p.child('visibility').out,
      vulnerability_alerts: p.child('vulnerability_alerts').out,
      web_commit_signoff_required: p.child('web_commit_signoff_required').out,
    },
    repository_autolink_reference(name, block): {
      local p = path(['github_repository_autolink_reference', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_autolink_reference: {
              [name]: std.prune({
                is_alphanumeric: build.template(std.get(block, 'is_alphanumeric', null, true)),
                key_prefix: build.template(block.key_prefix),
                repository: build.template(block.repository),
                target_url_template: build.template(block.target_url_template),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      is_alphanumeric: p.child('is_alphanumeric').out,
      key_prefix: p.child('key_prefix').out,
      repository: p.child('repository').out,
      target_url_template: p.child('target_url_template').out,
    },
    repository_collaborator(name, block): {
      local p = path(['github_repository_collaborator', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_collaborator: {
              [name]: std.prune({
                permission: build.template(std.get(block, 'permission', null, true)),
                permission_diff_suppression: build.template(std.get(block, 'permission_diff_suppression', null, true)),
                repository: build.template(block.repository),
                username: build.template(block.username),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      invitation_id: p.child('invitation_id').out,
      permission: p.child('permission').out,
      permission_diff_suppression: p.child('permission_diff_suppression').out,
      repository: p.child('repository').out,
      username: p.child('username').out,
    },
    repository_collaborators(name, block): {
      local p = path(['github_repository_collaborators', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_collaborators: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      invitation_ids: p.child('invitation_ids').out,
      repository: p.child('repository').out,
    },
    repository_dependabot_security_updates(name, block): {
      local p = path(['github_repository_dependabot_security_updates', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_dependabot_security_updates: {
              [name]: std.prune({
                enabled: build.template(block.enabled),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      enabled: p.child('enabled').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    repository_deploy_key(name, block): {
      local p = path(['github_repository_deploy_key', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_deploy_key: {
              [name]: std.prune({
                key: build.template(block.key),
                read_only: build.template(std.get(block, 'read_only', null, true)),
                repository: build.template(block.repository),
                title: build.template(block.title),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      key: p.child('key').out,
      read_only: p.child('read_only').out,
      repository: p.child('repository').out,
      title: p.child('title').out,
    },
    repository_deployment_branch_policy(name, block): {
      local p = path(['github_repository_deployment_branch_policy', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_deployment_branch_policy: {
              [name]: std.prune({
                environment_name: build.template(block.environment_name),
                name: build.template(block.name),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      environment_name: p.child('environment_name').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      repository: p.child('repository').out,
    },
    repository_environment(name, block): {
      local p = path(['github_repository_environment', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_environment: {
              [name]: std.prune({
                can_admins_bypass: build.template(std.get(block, 'can_admins_bypass', null, true)),
                environment: build.template(block.environment),
                prevent_self_review: build.template(std.get(block, 'prevent_self_review', null, true)),
                repository: build.template(block.repository),
                wait_timer: build.template(std.get(block, 'wait_timer', null, true)),
              }),
            },
          },
        },
      },
      can_admins_bypass: p.child('can_admins_bypass').out,
      environment: p.child('environment').out,
      id: p.child('id').out,
      prevent_self_review: p.child('prevent_self_review').out,
      repository: p.child('repository').out,
      wait_timer: p.child('wait_timer').out,
    },
    repository_environment_deployment_policy(name, block): {
      local p = path(['github_repository_environment_deployment_policy', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_environment_deployment_policy: {
              [name]: std.prune({
                branch_pattern: build.template(block.branch_pattern),
                environment: build.template(block.environment),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      branch_pattern: p.child('branch_pattern').out,
      environment: p.child('environment').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    repository_file(name, block): {
      local p = path(['github_repository_file', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_file: {
              [name]: std.prune({
                branch: build.template(std.get(block, 'branch', null, true)),
                commit_author: build.template(std.get(block, 'commit_author', null, true)),
                commit_email: build.template(std.get(block, 'commit_email', null, true)),
                content: build.template(block.content),
                file: build.template(block.file),
                overwrite_on_create: build.template(std.get(block, 'overwrite_on_create', null, true)),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      branch: p.child('branch').out,
      commit_author: p.child('commit_author').out,
      commit_email: p.child('commit_email').out,
      commit_message: p.child('commit_message').out,
      commit_sha: p.child('commit_sha').out,
      content: p.child('content').out,
      file: p.child('file').out,
      id: p.child('id').out,
      overwrite_on_create: p.child('overwrite_on_create').out,
      ref: p.child('ref').out,
      repository: p.child('repository').out,
      sha: p.child('sha').out,
    },
    repository_milestone(name, block): {
      local p = path(['github_repository_milestone', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_milestone: {
              [name]: std.prune({
                description: build.template(std.get(block, 'description', null, true)),
                due_date: build.template(std.get(block, 'due_date', null, true)),
                owner: build.template(block.owner),
                repository: build.template(block.repository),
                state: build.template(std.get(block, 'state', null, true)),
                title: build.template(block.title),
              }),
            },
          },
        },
      },
      description: p.child('description').out,
      due_date: p.child('due_date').out,
      id: p.child('id').out,
      number: p.child('number').out,
      owner: p.child('owner').out,
      repository: p.child('repository').out,
      state: p.child('state').out,
      title: p.child('title').out,
    },
    repository_project(name, block): {
      local p = path(['github_repository_project', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_project: {
              [name]: std.prune({
                body: build.template(std.get(block, 'body', null, true)),
                name: build.template(block.name),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      body: p.child('body').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      repository: p.child('repository').out,
      url: p.child('url').out,
    },
    repository_pull_request(name, block): {
      local p = path(['github_repository_pull_request', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_pull_request: {
              [name]: std.prune({
                base_ref: build.template(block.base_ref),
                base_repository: build.template(block.base_repository),
                body: build.template(std.get(block, 'body', null, true)),
                head_ref: build.template(block.head_ref),
                maintainer_can_modify: build.template(std.get(block, 'maintainer_can_modify', null, true)),
                owner: build.template(std.get(block, 'owner', null, true)),
                title: build.template(block.title),
              }),
            },
          },
        },
      },
      base_ref: p.child('base_ref').out,
      base_repository: p.child('base_repository').out,
      base_sha: p.child('base_sha').out,
      body: p.child('body').out,
      draft: p.child('draft').out,
      head_ref: p.child('head_ref').out,
      head_sha: p.child('head_sha').out,
      id: p.child('id').out,
      labels: p.child('labels').out,
      maintainer_can_modify: p.child('maintainer_can_modify').out,
      number: p.child('number').out,
      opened_at: p.child('opened_at').out,
      opened_by: p.child('opened_by').out,
      owner: p.child('owner').out,
      state: p.child('state').out,
      title: p.child('title').out,
      updated_at: p.child('updated_at').out,
    },
    repository_ruleset(name, block): {
      local p = path(['github_repository_ruleset', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_ruleset: {
              [name]: std.prune({
                enforcement: build.template(block.enforcement),
                name: build.template(block.name),
                repository: build.template(std.get(block, 'repository', null, true)),
                target: build.template(block.target),
              }),
            },
          },
        },
      },
      enforcement: p.child('enforcement').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      repository: p.child('repository').out,
      ruleset_id: p.child('ruleset_id').out,
      target: p.child('target').out,
    },
    repository_tag_protection(name, block): {
      local p = path(['github_repository_tag_protection', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_tag_protection: {
              [name]: std.prune({
                pattern: build.template(block.pattern),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      pattern: p.child('pattern').out,
      repository: p.child('repository').out,
      tag_protection_id: p.child('tag_protection_id').out,
    },
    repository_topics(name, block): {
      local p = path(['github_repository_topics', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_topics: {
              [name]: std.prune({
                repository: build.template(block.repository),
                topics: build.template(block.topics),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      repository: p.child('repository').out,
      topics: p.child('topics').out,
    },
    repository_webhook(name, block): {
      local p = path(['github_repository_webhook', name]),
      _: p.out._ {
        block: {
          resource: {
            github_repository_webhook: {
              [name]: std.prune({
                active: build.template(std.get(block, 'active', null, true)),
                events: build.template(block.events),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      active: p.child('active').out,
      etag: p.child('etag').out,
      events: p.child('events').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
      url: p.child('url').out,
    },
    team(name, block): {
      local p = path(['github_team', name]),
      _: p.out._ {
        block: {
          resource: {
            github_team: {
              [name]: std.prune({
                create_default_maintainer: build.template(std.get(block, 'create_default_maintainer', null, true)),
                description: build.template(std.get(block, 'description', null, true)),
                ldap_dn: build.template(std.get(block, 'ldap_dn', null, true)),
                name: build.template(block.name),
                parent_team_id: build.template(std.get(block, 'parent_team_id', null, true)),
                privacy: build.template(std.get(block, 'privacy', null, true)),
              }),
            },
          },
        },
      },
      create_default_maintainer: p.child('create_default_maintainer').out,
      description: p.child('description').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      ldap_dn: p.child('ldap_dn').out,
      members_count: p.child('members_count').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      parent_team_id: p.child('parent_team_id').out,
      parent_team_read_id: p.child('parent_team_read_id').out,
      parent_team_read_slug: p.child('parent_team_read_slug').out,
      privacy: p.child('privacy').out,
      slug: p.child('slug').out,
    },
    team_members(name, block): {
      local p = path(['github_team_members', name]),
      _: p.out._ {
        block: {
          resource: {
            github_team_members: {
              [name]: std.prune({
                team_id: build.template(block.team_id),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      team_id: p.child('team_id').out,
    },
    team_membership(name, block): {
      local p = path(['github_team_membership', name]),
      _: p.out._ {
        block: {
          resource: {
            github_team_membership: {
              [name]: std.prune({
                role: build.template(std.get(block, 'role', null, true)),
                team_id: build.template(block.team_id),
                username: build.template(block.username),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      role: p.child('role').out,
      team_id: p.child('team_id').out,
      username: p.child('username').out,
    },
    team_repository(name, block): {
      local p = path(['github_team_repository', name]),
      _: p.out._ {
        block: {
          resource: {
            github_team_repository: {
              [name]: std.prune({
                permission: build.template(std.get(block, 'permission', null, true)),
                repository: build.template(block.repository),
                team_id: build.template(block.team_id),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      permission: p.child('permission').out,
      repository: p.child('repository').out,
      team_id: p.child('team_id').out,
    },
    team_settings(name, block): {
      local p = path(['github_team_settings', name]),
      _: p.out._ {
        block: {
          resource: {
            github_team_settings: {
              [name]: std.prune({
                team_id: build.template(block.team_id),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      team_id: p.child('team_id').out,
      team_slug: p.child('team_slug').out,
      team_uid: p.child('team_uid').out,
    },
    team_sync_group_mapping(name, block): {
      local p = path(['github_team_sync_group_mapping', name]),
      _: p.out._ {
        block: {
          resource: {
            github_team_sync_group_mapping: {
              [name]: std.prune({
                team_slug: build.template(block.team_slug),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      team_slug: p.child('team_slug').out,
    },
    user_gpg_key(name, block): {
      local p = path(['github_user_gpg_key', name]),
      _: p.out._ {
        block: {
          resource: {
            github_user_gpg_key: {
              [name]: std.prune({
                armored_public_key: build.template(block.armored_public_key),
              }),
            },
          },
        },
      },
      armored_public_key: p.child('armored_public_key').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      key_id: p.child('key_id').out,
    },
    user_invitation_accepter(name, block): {
      local p = path(['github_user_invitation_accepter', name]),
      _: p.out._ {
        block: {
          resource: {
            github_user_invitation_accepter: {
              [name]: std.prune({
                allow_empty_id: build.template(std.get(block, 'allow_empty_id', null, true)),
                invitation_id: build.template(std.get(block, 'invitation_id', null, true)),
              }),
            },
          },
        },
      },
      allow_empty_id: p.child('allow_empty_id').out,
      id: p.child('id').out,
      invitation_id: p.child('invitation_id').out,
    },
    user_ssh_key(name, block): {
      local p = path(['github_user_ssh_key', name]),
      _: p.out._ {
        block: {
          resource: {
            github_user_ssh_key: {
              [name]: std.prune({
                key: build.template(block.key),
                title: build.template(block.title),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      key: p.child('key').out,
      title: p.child('title').out,
      url: p.child('url').out,
    },
  },
  data: {
    actions_environment_secrets(name, block): {
      local p = path(['data', 'github_actions_environment_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_environment_secrets: {
              [name]: std.prune({
                environment: build.template(block.environment),
              }),
            },
          },
        },
      },
      environment: p.child('environment').out,
      full_name: p.child('full_name').out,
      id: p.child('id').out,
      name: p.child('name').out,
      secrets: p.child('secrets').out,
    },
    actions_environment_variables(name, block): {
      local p = path(['data', 'github_actions_environment_variables', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_environment_variables: {
              [name]: std.prune({
                environment: build.template(block.environment),
              }),
            },
          },
        },
      },
      environment: p.child('environment').out,
      full_name: p.child('full_name').out,
      id: p.child('id').out,
      name: p.child('name').out,
      variables: p.child('variables').out,
    },
    actions_organization_oidc_subject_claim_customization_template(name, block): {
      local p = path(['data', 'github_actions_organization_oidc_subject_claim_customization_template', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_organization_oidc_subject_claim_customization_template: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      include_claim_keys: p.child('include_claim_keys').out,
    },
    actions_organization_public_key(name, block): {
      local p = path(['data', 'github_actions_organization_public_key', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_organization_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      key: p.child('key').out,
      key_id: p.child('key_id').out,
    },
    actions_organization_registration_token(name, block): {
      local p = path(['data', 'github_actions_organization_registration_token', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_organization_registration_token: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      expires_at: p.child('expires_at').out,
      id: p.child('id').out,
      token: p.child('token').out,
    },
    actions_organization_secrets(name, block): {
      local p = path(['data', 'github_actions_organization_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_organization_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      secrets: p.child('secrets').out,
    },
    actions_organization_variables(name, block): {
      local p = path(['data', 'github_actions_organization_variables', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_organization_variables: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      variables: p.child('variables').out,
    },
    actions_public_key(name, block): {
      local p = path(['data', 'github_actions_public_key', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_public_key: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      key: p.child('key').out,
      key_id: p.child('key_id').out,
      repository: p.child('repository').out,
    },
    actions_registration_token(name, block): {
      local p = path(['data', 'github_actions_registration_token', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_registration_token: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      expires_at: p.child('expires_at').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
      token: p.child('token').out,
    },
    actions_repository_oidc_subject_claim_customization_template(name, block): {
      local p = path(['data', 'github_actions_repository_oidc_subject_claim_customization_template', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_repository_oidc_subject_claim_customization_template: {
              [name]: std.prune({
                name: build.template(block.name),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      include_claim_keys: p.child('include_claim_keys').out,
      name: p.child('name').out,
      use_default: p.child('use_default').out,
    },
    actions_secrets(name, block): {
      local p = path(['data', 'github_actions_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').out,
      id: p.child('id').out,
      name: p.child('name').out,
      secrets: p.child('secrets').out,
    },
    actions_variables(name, block): {
      local p = path(['data', 'github_actions_variables', name]),
      _: p.out._ {
        block: {
          data: {
            github_actions_variables: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').out,
      id: p.child('id').out,
      name: p.child('name').out,
      variables: p.child('variables').out,
    },
    app(name, block): {
      local p = path(['data', 'github_app', name]),
      _: p.out._ {
        block: {
          data: {
            github_app: {
              [name]: std.prune({
                slug: build.template(block.slug),
              }),
            },
          },
        },
      },
      description: p.child('description').out,
      id: p.child('id').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      slug: p.child('slug').out,
    },
    app_token(name, block): {
      local p = path(['data', 'github_app_token', name]),
      _: p.out._ {
        block: {
          data: {
            github_app_token: {
              [name]: std.prune({
                app_id: build.template(block.app_id),
                installation_id: build.template(block.installation_id),
                pem_file: build.template(block.pem_file),
              }),
            },
          },
        },
      },
      app_id: p.child('app_id').out,
      id: p.child('id').out,
      installation_id: p.child('installation_id').out,
      pem_file: p.child('pem_file').out,
      token: p.child('token').out,
    },
    branch(name, block): {
      local p = path(['data', 'github_branch', name]),
      _: p.out._ {
        block: {
          data: {
            github_branch: {
              [name]: std.prune({
                branch: build.template(block.branch),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      branch: p.child('branch').out,
      etag: p.child('etag').out,
      id: p.child('id').out,
      ref: p.child('ref').out,
      repository: p.child('repository').out,
      sha: p.child('sha').out,
    },
    branch_protection_rules(name, block): {
      local p = path(['data', 'github_branch_protection_rules', name]),
      _: p.out._ {
        block: {
          data: {
            github_branch_protection_rules: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      repository: p.child('repository').out,
      rules: p.child('rules').out,
    },
    codespaces_organization_public_key(name, block): {
      local p = path(['data', 'github_codespaces_organization_public_key', name]),
      _: p.out._ {
        block: {
          data: {
            github_codespaces_organization_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      key: p.child('key').out,
      key_id: p.child('key_id').out,
    },
    codespaces_organization_secrets(name, block): {
      local p = path(['data', 'github_codespaces_organization_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_codespaces_organization_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      secrets: p.child('secrets').out,
    },
    codespaces_public_key(name, block): {
      local p = path(['data', 'github_codespaces_public_key', name]),
      _: p.out._ {
        block: {
          data: {
            github_codespaces_public_key: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      key: p.child('key').out,
      key_id: p.child('key_id').out,
      repository: p.child('repository').out,
    },
    codespaces_secrets(name, block): {
      local p = path(['data', 'github_codespaces_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_codespaces_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').out,
      id: p.child('id').out,
      name: p.child('name').out,
      secrets: p.child('secrets').out,
    },
    codespaces_user_public_key(name, block): {
      local p = path(['data', 'github_codespaces_user_public_key', name]),
      _: p.out._ {
        block: {
          data: {
            github_codespaces_user_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      key: p.child('key').out,
      key_id: p.child('key_id').out,
    },
    codespaces_user_secrets(name, block): {
      local p = path(['data', 'github_codespaces_user_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_codespaces_user_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      secrets: p.child('secrets').out,
    },
    collaborators(name, block): {
      local p = path(['data', 'github_collaborators', name]),
      _: p.out._ {
        block: {
          data: {
            github_collaborators: {
              [name]: std.prune({
                affiliation: build.template(std.get(block, 'affiliation', null, true)),
                owner: build.template(block.owner),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      affiliation: p.child('affiliation').out,
      collaborator: p.child('collaborator').out,
      id: p.child('id').out,
      owner: p.child('owner').out,
      repository: p.child('repository').out,
    },
    dependabot_organization_public_key(name, block): {
      local p = path(['data', 'github_dependabot_organization_public_key', name]),
      _: p.out._ {
        block: {
          data: {
            github_dependabot_organization_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      key: p.child('key').out,
      key_id: p.child('key_id').out,
    },
    dependabot_organization_secrets(name, block): {
      local p = path(['data', 'github_dependabot_organization_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_dependabot_organization_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      secrets: p.child('secrets').out,
    },
    dependabot_public_key(name, block): {
      local p = path(['data', 'github_dependabot_public_key', name]),
      _: p.out._ {
        block: {
          data: {
            github_dependabot_public_key: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      key: p.child('key').out,
      key_id: p.child('key_id').out,
      repository: p.child('repository').out,
    },
    dependabot_secrets(name, block): {
      local p = path(['data', 'github_dependabot_secrets', name]),
      _: p.out._ {
        block: {
          data: {
            github_dependabot_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').out,
      id: p.child('id').out,
      name: p.child('name').out,
      secrets: p.child('secrets').out,
    },
    enterprise(name, block): {
      local p = path(['data', 'github_enterprise', name]),
      _: p.out._ {
        block: {
          data: {
            github_enterprise: {
              [name]: std.prune({
                slug: build.template(block.slug),
              }),
            },
          },
        },
      },
      created_at: p.child('created_at').out,
      database_id: p.child('database_id').out,
      description: p.child('description').out,
      id: p.child('id').out,
      name: p.child('name').out,
      slug: p.child('slug').out,
      url: p.child('url').out,
    },
    external_groups(name, block): {
      local p = path(['data', 'github_external_groups', name]),
      _: p.out._ {
        block: {
          data: {
            github_external_groups: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      external_groups: p.child('external_groups').out,
      id: p.child('id').out,
    },
    ip_ranges(name, block): {
      local p = path(['data', 'github_ip_ranges', name]),
      _: p.out._ {
        block: {
          data: {
            github_ip_ranges: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      actions: p.child('actions').out,
      actions_ipv4: p.child('actions_ipv4').out,
      actions_ipv6: p.child('actions_ipv6').out,
      api: p.child('api').out,
      api_ipv4: p.child('api_ipv4').out,
      api_ipv6: p.child('api_ipv6').out,
      dependabot: p.child('dependabot').out,
      dependabot_ipv4: p.child('dependabot_ipv4').out,
      dependabot_ipv6: p.child('dependabot_ipv6').out,
      git: p.child('git').out,
      git_ipv4: p.child('git_ipv4').out,
      git_ipv6: p.child('git_ipv6').out,
      hooks: p.child('hooks').out,
      hooks_ipv4: p.child('hooks_ipv4').out,
      hooks_ipv6: p.child('hooks_ipv6').out,
      id: p.child('id').out,
      importer: p.child('importer').out,
      importer_ipv4: p.child('importer_ipv4').out,
      importer_ipv6: p.child('importer_ipv6').out,
      packages: p.child('packages').out,
      packages_ipv4: p.child('packages_ipv4').out,
      packages_ipv6: p.child('packages_ipv6').out,
      pages: p.child('pages').out,
      pages_ipv4: p.child('pages_ipv4').out,
      pages_ipv6: p.child('pages_ipv6').out,
      web: p.child('web').out,
      web_ipv4: p.child('web_ipv4').out,
      web_ipv6: p.child('web_ipv6').out,
    },
    issue_labels(name, block): {
      local p = path(['data', 'github_issue_labels', name]),
      _: p.out._ {
        block: {
          data: {
            github_issue_labels: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      labels: p.child('labels').out,
      repository: p.child('repository').out,
    },
    membership(name, block): {
      local p = path(['data', 'github_membership', name]),
      _: p.out._ {
        block: {
          data: {
            github_membership: {
              [name]: std.prune({
                organization: build.template(std.get(block, 'organization', null, true)),
                username: build.template(block.username),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      organization: p.child('organization').out,
      role: p.child('role').out,
      state: p.child('state').out,
      username: p.child('username').out,
    },
    organization(name, block): {
      local p = path(['data', 'github_organization', name]),
      _: p.out._ {
        block: {
          data: {
            github_organization: {
              [name]: std.prune({
                ignore_archived_repos: build.template(std.get(block, 'ignore_archived_repos', null, true)),
                name: build.template(block.name),
              }),
            },
          },
        },
      },
      advanced_security_enabled_for_new_repositories: p.child('advanced_security_enabled_for_new_repositories').out,
      default_repository_permission: p.child('default_repository_permission').out,
      dependabot_alerts_enabled_for_new_repositories: p.child('dependabot_alerts_enabled_for_new_repositories').out,
      dependabot_security_updates_enabled_for_new_repositories: p.child('dependabot_security_updates_enabled_for_new_repositories').out,
      dependency_graph_enabled_for_new_repositories: p.child('dependency_graph_enabled_for_new_repositories').out,
      description: p.child('description').out,
      id: p.child('id').out,
      ignore_archived_repos: p.child('ignore_archived_repos').out,
      login: p.child('login').out,
      members: p.child('members').out,
      members_allowed_repository_creation_type: p.child('members_allowed_repository_creation_type').out,
      members_can_create_internal_repositories: p.child('members_can_create_internal_repositories').out,
      members_can_create_pages: p.child('members_can_create_pages').out,
      members_can_create_private_pages: p.child('members_can_create_private_pages').out,
      members_can_create_private_repositories: p.child('members_can_create_private_repositories').out,
      members_can_create_public_pages: p.child('members_can_create_public_pages').out,
      members_can_create_public_repositories: p.child('members_can_create_public_repositories').out,
      members_can_create_repositories: p.child('members_can_create_repositories').out,
      members_can_fork_private_repositories: p.child('members_can_fork_private_repositories').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      orgname: p.child('orgname').out,
      plan: p.child('plan').out,
      repositories: p.child('repositories').out,
      secret_scanning_enabled_for_new_repositories: p.child('secret_scanning_enabled_for_new_repositories').out,
      secret_scanning_push_protection_enabled_for_new_repositories: p.child('secret_scanning_push_protection_enabled_for_new_repositories').out,
      two_factor_requirement_enabled: p.child('two_factor_requirement_enabled').out,
      users: p.child('users').out,
      web_commit_signoff_required: p.child('web_commit_signoff_required').out,
    },
    organization_custom_role(name, block): {
      local p = path(['data', 'github_organization_custom_role', name]),
      _: p.out._ {
        block: {
          data: {
            github_organization_custom_role: {
              [name]: std.prune({
                name: build.template(block.name),
              }),
            },
          },
        },
      },
      base_role: p.child('base_role').out,
      description: p.child('description').out,
      id: p.child('id').out,
      name: p.child('name').out,
      permissions: p.child('permissions').out,
    },
    organization_external_identities(name, block): {
      local p = path(['data', 'github_organization_external_identities', name]),
      _: p.out._ {
        block: {
          data: {
            github_organization_external_identities: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      identities: p.child('identities').out,
    },
    organization_ip_allow_list(name, block): {
      local p = path(['data', 'github_organization_ip_allow_list', name]),
      _: p.out._ {
        block: {
          data: {
            github_organization_ip_allow_list: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      ip_allow_list: p.child('ip_allow_list').out,
    },
    organization_team_sync_groups(name, block): {
      local p = path(['data', 'github_organization_team_sync_groups', name]),
      _: p.out._ {
        block: {
          data: {
            github_organization_team_sync_groups: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      groups: p.child('groups').out,
      id: p.child('id').out,
    },
    organization_teams(name, block): {
      local p = path(['data', 'github_organization_teams', name]),
      _: p.out._ {
        block: {
          data: {
            github_organization_teams: {
              [name]: std.prune({
                results_per_page: build.template(std.get(block, 'results_per_page', null, true)),
                root_teams_only: build.template(std.get(block, 'root_teams_only', null, true)),
                summary_only: build.template(std.get(block, 'summary_only', null, true)),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      results_per_page: p.child('results_per_page').out,
      root_teams_only: p.child('root_teams_only').out,
      summary_only: p.child('summary_only').out,
      teams: p.child('teams').out,
    },
    organization_webhooks(name, block): {
      local p = path(['data', 'github_organization_webhooks', name]),
      _: p.out._ {
        block: {
          data: {
            github_organization_webhooks: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      webhooks: p.child('webhooks').out,
    },
    ref(name, block): {
      local p = path(['data', 'github_ref', name]),
      _: p.out._ {
        block: {
          data: {
            github_ref: {
              [name]: std.prune({
                owner: build.template(std.get(block, 'owner', null, true)),
                ref: build.template(block.ref),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      etag: p.child('etag').out,
      id: p.child('id').out,
      owner: p.child('owner').out,
      ref: p.child('ref').out,
      repository: p.child('repository').out,
      sha: p.child('sha').out,
    },
    release(name, block): {
      local p = path(['data', 'github_release', name]),
      _: p.out._ {
        block: {
          data: {
            github_release: {
              [name]: std.prune({
                owner: build.template(block.owner),
                release_id: build.template(std.get(block, 'release_id', null, true)),
                release_tag: build.template(std.get(block, 'release_tag', null, true)),
                repository: build.template(block.repository),
                retrieve_by: build.template(block.retrieve_by),
              }),
            },
          },
        },
      },
      asserts_url: p.child('asserts_url').out,
      assets: p.child('assets').out,
      assets_url: p.child('assets_url').out,
      body: p.child('body').out,
      created_at: p.child('created_at').out,
      draft: p.child('draft').out,
      html_url: p.child('html_url').out,
      id: p.child('id').out,
      name: p.child('name').out,
      owner: p.child('owner').out,
      prerelease: p.child('prerelease').out,
      published_at: p.child('published_at').out,
      release_id: p.child('release_id').out,
      release_tag: p.child('release_tag').out,
      repository: p.child('repository').out,
      retrieve_by: p.child('retrieve_by').out,
      tarball_url: p.child('tarball_url').out,
      target_commitish: p.child('target_commitish').out,
      upload_url: p.child('upload_url').out,
      url: p.child('url').out,
      zipball_url: p.child('zipball_url').out,
    },
    repositories(name, block): {
      local p = path(['data', 'github_repositories', name]),
      _: p.out._ {
        block: {
          data: {
            github_repositories: {
              [name]: std.prune({
                include_repo_id: build.template(std.get(block, 'include_repo_id', null, true)),
                query: build.template(block.query),
                results_per_page: build.template(std.get(block, 'results_per_page', null, true)),
                sort: build.template(std.get(block, 'sort', null, true)),
              }),
            },
          },
        },
      },
      full_names: p.child('full_names').out,
      id: p.child('id').out,
      include_repo_id: p.child('include_repo_id').out,
      names: p.child('names').out,
      query: p.child('query').out,
      repo_ids: p.child('repo_ids').out,
      results_per_page: p.child('results_per_page').out,
      sort: p.child('sort').out,
    },
    repository(name, block): {
      local p = path(['data', 'github_repository', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository: {
              [name]: std.prune({
                description: build.template(std.get(block, 'description', null, true)),
                homepage_url: build.template(std.get(block, 'homepage_url', null, true)),
              }),
            },
          },
        },
      },
      allow_auto_merge: p.child('allow_auto_merge').out,
      allow_merge_commit: p.child('allow_merge_commit').out,
      allow_rebase_merge: p.child('allow_rebase_merge').out,
      allow_squash_merge: p.child('allow_squash_merge').out,
      archived: p.child('archived').out,
      default_branch: p.child('default_branch').out,
      description: p.child('description').out,
      fork: p.child('fork').out,
      full_name: p.child('full_name').out,
      git_clone_url: p.child('git_clone_url').out,
      has_discussions: p.child('has_discussions').out,
      has_downloads: p.child('has_downloads').out,
      has_issues: p.child('has_issues').out,
      has_projects: p.child('has_projects').out,
      has_wiki: p.child('has_wiki').out,
      homepage_url: p.child('homepage_url').out,
      html_url: p.child('html_url').out,
      http_clone_url: p.child('http_clone_url').out,
      id: p.child('id').out,
      is_template: p.child('is_template').out,
      merge_commit_message: p.child('merge_commit_message').out,
      merge_commit_title: p.child('merge_commit_title').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      pages: p.child('pages').out,
      primary_language: p.child('primary_language').out,
      private: p.child('private').out,
      repo_id: p.child('repo_id').out,
      repository_license: p.child('repository_license').out,
      squash_merge_commit_message: p.child('squash_merge_commit_message').out,
      squash_merge_commit_title: p.child('squash_merge_commit_title').out,
      ssh_clone_url: p.child('ssh_clone_url').out,
      svn_url: p.child('svn_url').out,
      template: p.child('template').out,
      topics: p.child('topics').out,
      visibility: p.child('visibility').out,
    },
    repository_autolink_references(name, block): {
      local p = path(['data', 'github_repository_autolink_references', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_autolink_references: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      autolink_references: p.child('autolink_references').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    repository_branches(name, block): {
      local p = path(['data', 'github_repository_branches', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_branches: {
              [name]: std.prune({
                only_non_protected_branches: build.template(std.get(block, 'only_non_protected_branches', null, true)),
                only_protected_branches: build.template(std.get(block, 'only_protected_branches', null, true)),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      branches: p.child('branches').out,
      id: p.child('id').out,
      only_non_protected_branches: p.child('only_non_protected_branches').out,
      only_protected_branches: p.child('only_protected_branches').out,
      repository: p.child('repository').out,
    },
    repository_deploy_keys(name, block): {
      local p = path(['data', 'github_repository_deploy_keys', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_deploy_keys: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      keys: p.child('keys').out,
      repository: p.child('repository').out,
    },
    repository_deployment_branch_policies(name, block): {
      local p = path(['data', 'github_repository_deployment_branch_policies', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_deployment_branch_policies: {
              [name]: std.prune({
                environment_name: build.template(block.environment_name),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      deployment_branch_policies: p.child('deployment_branch_policies').out,
      environment_name: p.child('environment_name').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    repository_environments(name, block): {
      local p = path(['data', 'github_repository_environments', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_environments: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      environments: p.child('environments').out,
      id: p.child('id').out,
      repository: p.child('repository').out,
    },
    repository_file(name, block): {
      local p = path(['data', 'github_repository_file', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_file: {
              [name]: std.prune({
                branch: build.template(std.get(block, 'branch', null, true)),
                file: build.template(block.file),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      branch: p.child('branch').out,
      commit_author: p.child('commit_author').out,
      commit_email: p.child('commit_email').out,
      commit_message: p.child('commit_message').out,
      commit_sha: p.child('commit_sha').out,
      content: p.child('content').out,
      file: p.child('file').out,
      id: p.child('id').out,
      ref: p.child('ref').out,
      repository: p.child('repository').out,
      sha: p.child('sha').out,
    },
    repository_milestone(name, block): {
      local p = path(['data', 'github_repository_milestone', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_milestone: {
              [name]: std.prune({
                number: build.template(block.number),
                owner: build.template(block.owner),
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      description: p.child('description').out,
      due_date: p.child('due_date').out,
      id: p.child('id').out,
      number: p.child('number').out,
      owner: p.child('owner').out,
      repository: p.child('repository').out,
      state: p.child('state').out,
      title: p.child('title').out,
    },
    repository_pull_request(name, block): {
      local p = path(['data', 'github_repository_pull_request', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_pull_request: {
              [name]: std.prune({
                base_repository: build.template(block.base_repository),
                number: build.template(block.number),
                owner: build.template(std.get(block, 'owner', null, true)),
              }),
            },
          },
        },
      },
      base_ref: p.child('base_ref').out,
      base_repository: p.child('base_repository').out,
      base_sha: p.child('base_sha').out,
      body: p.child('body').out,
      draft: p.child('draft').out,
      head_owner: p.child('head_owner').out,
      head_ref: p.child('head_ref').out,
      head_repository: p.child('head_repository').out,
      head_sha: p.child('head_sha').out,
      id: p.child('id').out,
      labels: p.child('labels').out,
      maintainer_can_modify: p.child('maintainer_can_modify').out,
      number: p.child('number').out,
      opened_at: p.child('opened_at').out,
      opened_by: p.child('opened_by').out,
      owner: p.child('owner').out,
      state: p.child('state').out,
      title: p.child('title').out,
      updated_at: p.child('updated_at').out,
    },
    repository_pull_requests(name, block): {
      local p = path(['data', 'github_repository_pull_requests', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_pull_requests: {
              [name]: std.prune({
                base_ref: build.template(std.get(block, 'base_ref', null, true)),
                base_repository: build.template(block.base_repository),
                head_ref: build.template(std.get(block, 'head_ref', null, true)),
                owner: build.template(std.get(block, 'owner', null, true)),
                sort_by: build.template(std.get(block, 'sort_by', null, true)),
                sort_direction: build.template(std.get(block, 'sort_direction', null, true)),
                state: build.template(std.get(block, 'state', null, true)),
              }),
            },
          },
        },
      },
      base_ref: p.child('base_ref').out,
      base_repository: p.child('base_repository').out,
      head_ref: p.child('head_ref').out,
      id: p.child('id').out,
      owner: p.child('owner').out,
      results: p.child('results').out,
      sort_by: p.child('sort_by').out,
      sort_direction: p.child('sort_direction').out,
      state: p.child('state').out,
    },
    repository_teams(name, block): {
      local p = path(['data', 'github_repository_teams', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_teams: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').out,
      id: p.child('id').out,
      name: p.child('name').out,
      teams: p.child('teams').out,
    },
    repository_webhooks(name, block): {
      local p = path(['data', 'github_repository_webhooks', name]),
      _: p.out._ {
        block: {
          data: {
            github_repository_webhooks: {
              [name]: std.prune({
                repository: build.template(block.repository),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      repository: p.child('repository').out,
      webhooks: p.child('webhooks').out,
    },
    rest_api(name, block): {
      local p = path(['data', 'github_rest_api', name]),
      _: p.out._ {
        block: {
          data: {
            github_rest_api: {
              [name]: std.prune({
                endpoint: build.template(block.endpoint),
              }),
            },
          },
        },
      },
      body: p.child('body').out,
      code: p.child('code').out,
      endpoint: p.child('endpoint').out,
      headers: p.child('headers').out,
      id: p.child('id').out,
      status: p.child('status').out,
    },
    ssh_keys(name, block): {
      local p = path(['data', 'github_ssh_keys', name]),
      _: p.out._ {
        block: {
          data: {
            github_ssh_keys: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      keys: p.child('keys').out,
    },
    team(name, block): {
      local p = path(['data', 'github_team', name]),
      _: p.out._ {
        block: {
          data: {
            github_team: {
              [name]: std.prune({
                membership_type: build.template(std.get(block, 'membership_type', null, true)),
                results_per_page: build.template(std.get(block, 'results_per_page', null, true)),
                slug: build.template(block.slug),
                summary_only: build.template(std.get(block, 'summary_only', null, true)),
              }),
            },
          },
        },
      },
      description: p.child('description').out,
      id: p.child('id').out,
      members: p.child('members').out,
      membership_type: p.child('membership_type').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      permission: p.child('permission').out,
      privacy: p.child('privacy').out,
      repositories: p.child('repositories').out,
      repositories_detailed: p.child('repositories_detailed').out,
      results_per_page: p.child('results_per_page').out,
      slug: p.child('slug').out,
      summary_only: p.child('summary_only').out,
    },
    tree(name, block): {
      local p = path(['data', 'github_tree', name]),
      _: p.out._ {
        block: {
          data: {
            github_tree: {
              [name]: std.prune({
                recursive: build.template(std.get(block, 'recursive', null, true)),
                repository: build.template(block.repository),
                tree_sha: build.template(block.tree_sha),
              }),
            },
          },
        },
      },
      entries: p.child('entries').out,
      id: p.child('id').out,
      recursive: p.child('recursive').out,
      repository: p.child('repository').out,
      tree_sha: p.child('tree_sha').out,
    },
    user(name, block): {
      local p = path(['data', 'github_user', name]),
      _: p.out._ {
        block: {
          data: {
            github_user: {
              [name]: std.prune({
                username: build.template(block.username),
              }),
            },
          },
        },
      },
      avatar_url: p.child('avatar_url').out,
      bio: p.child('bio').out,
      blog: p.child('blog').out,
      company: p.child('company').out,
      created_at: p.child('created_at').out,
      email: p.child('email').out,
      followers: p.child('followers').out,
      following: p.child('following').out,
      gpg_keys: p.child('gpg_keys').out,
      gravatar_id: p.child('gravatar_id').out,
      id: p.child('id').out,
      location: p.child('location').out,
      login: p.child('login').out,
      name: p.child('name').out,
      node_id: p.child('node_id').out,
      public_gists: p.child('public_gists').out,
      public_repos: p.child('public_repos').out,
      site_admin: p.child('site_admin').out,
      ssh_keys: p.child('ssh_keys').out,
      suspended_at: p.child('suspended_at').out,
      updated_at: p.child('updated_at').out,
      username: p.child('username').out,
    },
    user_external_identity(name, block): {
      local p = path(['data', 'github_user_external_identity', name]),
      _: p.out._ {
        block: {
          data: {
            github_user_external_identity: {
              [name]: std.prune({
                username: build.template(block.username),
              }),
            },
          },
        },
      },
      id: p.child('id').out,
      login: p.child('login').out,
      saml_identity: p.child('saml_identity').out,
      scim_identity: p.child('scim_identity').out,
      username: p.child('username').out,
    },
    users(name, block): {
      local p = path(['data', 'github_users', name]),
      _: p.out._ {
        block: {
          data: {
            github_users: {
              [name]: std.prune({
                usernames: build.template(block.usernames),
              }),
            },
          },
        },
      },
      emails: p.child('emails').out,
      id: p.child('id').out,
      logins: p.child('logins').out,
      node_ids: p.child('node_ids').out,
      unknown_logins: p.child('unknown_logins').out,
      usernames: p.child('usernames').out,
    },
  },
};

provider
