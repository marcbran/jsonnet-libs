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
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      environment: p.child('environment').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      repository: p.child('repository').ref,
      secret_name: p.child('secret_name').ref,
      updated_at: p.child('updated_at').ref,
    },
    actions_environment_variable(name, block): {
      local p = path(['github_actions_environment_variable', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      environment: p.child('environment').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      updated_at: p.child('updated_at').ref,
      value: p.child('value').ref,
      variable_name: p.child('variable_name').ref,
    },
    actions_organization_oidc_subject_claim_customization_template(name, block): {
      local p = path(['github_actions_organization_oidc_subject_claim_customization_template', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      include_claim_keys: p.child('include_claim_keys').ref,
    },
    actions_organization_permissions(name, block): {
      local p = path(['github_actions_organization_permissions', name]),
      _: p.ref._ {
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
      allowed_actions: p.child('allowed_actions').ref,
      enabled_repositories: p.child('enabled_repositories').ref,
      id: p.child('id').ref,
    },
    actions_organization_secret(name, block): {
      local p = path(['github_actions_organization_secret', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      secret_name: p.child('secret_name').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
      updated_at: p.child('updated_at').ref,
      visibility: p.child('visibility').ref,
    },
    actions_organization_secret_repositories(name, block): {
      local p = path(['github_actions_organization_secret_repositories', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      secret_name: p.child('secret_name').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
    },
    actions_organization_variable(name, block): {
      local p = path(['github_actions_organization_variable', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      id: p.child('id').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
      updated_at: p.child('updated_at').ref,
      value: p.child('value').ref,
      variable_name: p.child('variable_name').ref,
      visibility: p.child('visibility').ref,
    },
    actions_repository_access_level(name, block): {
      local p = path(['github_actions_repository_access_level', name]),
      _: p.ref._ {
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
      access_level: p.child('access_level').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    actions_repository_oidc_subject_claim_customization_template(name, block): {
      local p = path(['github_actions_repository_oidc_subject_claim_customization_template', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      include_claim_keys: p.child('include_claim_keys').ref,
      repository: p.child('repository').ref,
      use_default: p.child('use_default').ref,
    },
    actions_repository_permissions(name, block): {
      local p = path(['github_actions_repository_permissions', name]),
      _: p.ref._ {
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
      allowed_actions: p.child('allowed_actions').ref,
      enabled: p.child('enabled').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    actions_runner_group(name, block): {
      local p = path(['github_actions_runner_group', name]),
      _: p.ref._ {
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
      allows_public_repositories: p.child('allows_public_repositories').ref,
      default: p.child('default').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      inherited: p.child('inherited').ref,
      name: p.child('name').ref,
      restricted_to_workflows: p.child('restricted_to_workflows').ref,
      runners_url: p.child('runners_url').ref,
      selected_repositories_url: p.child('selected_repositories_url').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
      selected_workflows: p.child('selected_workflows').ref,
      visibility: p.child('visibility').ref,
    },
    actions_secret(name, block): {
      local p = path(['github_actions_secret', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      repository: p.child('repository').ref,
      secret_name: p.child('secret_name').ref,
      updated_at: p.child('updated_at').ref,
    },
    actions_variable(name, block): {
      local p = path(['github_actions_variable', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      updated_at: p.child('updated_at').ref,
      value: p.child('value').ref,
      variable_name: p.child('variable_name').ref,
    },
    app_installation_repositories(name, block): {
      local p = path(['github_app_installation_repositories', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      installation_id: p.child('installation_id').ref,
      selected_repositories: p.child('selected_repositories').ref,
    },
    app_installation_repository(name, block): {
      local p = path(['github_app_installation_repository', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      installation_id: p.child('installation_id').ref,
      repo_id: p.child('repo_id').ref,
      repository: p.child('repository').ref,
    },
    branch(name, block): {
      local p = path(['github_branch', name]),
      _: p.ref._ {
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
      branch: p.child('branch').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      ref: p.child('ref').ref,
      repository: p.child('repository').ref,
      sha: p.child('sha').ref,
      source_branch: p.child('source_branch').ref,
      source_sha: p.child('source_sha').ref,
    },
    branch_default(name, block): {
      local p = path(['github_branch_default', name]),
      _: p.ref._ {
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
      branch: p.child('branch').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      rename: p.child('rename').ref,
      repository: p.child('repository').ref,
    },
    branch_protection(name, block): {
      local p = path(['github_branch_protection', name]),
      _: p.ref._ {
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
      allows_deletions: p.child('allows_deletions').ref,
      allows_force_pushes: p.child('allows_force_pushes').ref,
      enforce_admins: p.child('enforce_admins').ref,
      force_push_bypassers: p.child('force_push_bypassers').ref,
      id: p.child('id').ref,
      lock_branch: p.child('lock_branch').ref,
      pattern: p.child('pattern').ref,
      repository_id: p.child('repository_id').ref,
      require_conversation_resolution: p.child('require_conversation_resolution').ref,
      require_signed_commits: p.child('require_signed_commits').ref,
      required_linear_history: p.child('required_linear_history').ref,
    },
    branch_protection_v3(name, block): {
      local p = path(['github_branch_protection_v3', name]),
      _: p.ref._ {
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
      branch: p.child('branch').ref,
      enforce_admins: p.child('enforce_admins').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      require_conversation_resolution: p.child('require_conversation_resolution').ref,
      require_signed_commits: p.child('require_signed_commits').ref,
    },
    codespaces_organization_secret(name, block): {
      local p = path(['github_codespaces_organization_secret', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      secret_name: p.child('secret_name').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
      updated_at: p.child('updated_at').ref,
      visibility: p.child('visibility').ref,
    },
    codespaces_organization_secret_repositories(name, block): {
      local p = path(['github_codespaces_organization_secret_repositories', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      secret_name: p.child('secret_name').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
    },
    codespaces_secret(name, block): {
      local p = path(['github_codespaces_secret', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      repository: p.child('repository').ref,
      secret_name: p.child('secret_name').ref,
      updated_at: p.child('updated_at').ref,
    },
    codespaces_user_secret(name, block): {
      local p = path(['github_codespaces_user_secret', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      secret_name: p.child('secret_name').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
      updated_at: p.child('updated_at').ref,
    },
    dependabot_organization_secret(name, block): {
      local p = path(['github_dependabot_organization_secret', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      secret_name: p.child('secret_name').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
      updated_at: p.child('updated_at').ref,
      visibility: p.child('visibility').ref,
    },
    dependabot_organization_secret_repositories(name, block): {
      local p = path(['github_dependabot_organization_secret_repositories', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      secret_name: p.child('secret_name').ref,
      selected_repository_ids: p.child('selected_repository_ids').ref,
    },
    dependabot_secret(name, block): {
      local p = path(['github_dependabot_secret', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      encrypted_value: p.child('encrypted_value').ref,
      id: p.child('id').ref,
      plaintext_value: p.child('plaintext_value').ref,
      repository: p.child('repository').ref,
      secret_name: p.child('secret_name').ref,
      updated_at: p.child('updated_at').ref,
    },
    emu_group_mapping(name, block): {
      local p = path(['github_emu_group_mapping', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      group_id: p.child('group_id').ref,
      id: p.child('id').ref,
      team_slug: p.child('team_slug').ref,
    },
    enterprise_actions_permissions(name, block): {
      local p = path(['github_enterprise_actions_permissions', name]),
      _: p.ref._ {
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
      allowed_actions: p.child('allowed_actions').ref,
      enabled_organizations: p.child('enabled_organizations').ref,
      enterprise_slug: p.child('enterprise_slug').ref,
      id: p.child('id').ref,
    },
    enterprise_actions_runner_group(name, block): {
      local p = path(['github_enterprise_actions_runner_group', name]),
      _: p.ref._ {
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
      allows_public_repositories: p.child('allows_public_repositories').ref,
      default: p.child('default').ref,
      enterprise_slug: p.child('enterprise_slug').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      restricted_to_workflows: p.child('restricted_to_workflows').ref,
      runners_url: p.child('runners_url').ref,
      selected_organization_ids: p.child('selected_organization_ids').ref,
      selected_organizations_url: p.child('selected_organizations_url').ref,
      selected_workflows: p.child('selected_workflows').ref,
      visibility: p.child('visibility').ref,
    },
    enterprise_organization(name, block): {
      local p = path(['github_enterprise_organization', name]),
      _: p.ref._ {
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
      admin_logins: p.child('admin_logins').ref,
      billing_email: p.child('billing_email').ref,
      database_id: p.child('database_id').ref,
      description: p.child('description').ref,
      display_name: p.child('display_name').ref,
      enterprise_id: p.child('enterprise_id').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
    },
    issue(name, block): {
      local p = path(['github_issue', name]),
      _: p.ref._ {
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
      assignees: p.child('assignees').ref,
      body: p.child('body').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      issue_id: p.child('issue_id').ref,
      labels: p.child('labels').ref,
      milestone_number: p.child('milestone_number').ref,
      number: p.child('number').ref,
      repository: p.child('repository').ref,
      title: p.child('title').ref,
    },
    issue_label(name, block): {
      local p = path(['github_issue_label', name]),
      _: p.ref._ {
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
      color: p.child('color').ref,
      description: p.child('description').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      repository: p.child('repository').ref,
      url: p.child('url').ref,
    },
    issue_labels(name, block): {
      local p = path(['github_issue_labels', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    membership(name, block): {
      local p = path(['github_membership', name]),
      _: p.ref._ {
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
      downgrade_on_destroy: p.child('downgrade_on_destroy').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      role: p.child('role').ref,
      username: p.child('username').ref,
    },
    organization_block(name, block): {
      local p = path(['github_organization_block', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      username: p.child('username').ref,
    },
    organization_custom_role(name, block): {
      local p = path(['github_organization_custom_role', name]),
      _: p.ref._ {
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
      base_role: p.child('base_role').ref,
      description: p.child('description').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      permissions: p.child('permissions').ref,
    },
    organization_project(name, block): {
      local p = path(['github_organization_project', name]),
      _: p.ref._ {
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
      body: p.child('body').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      url: p.child('url').ref,
    },
    organization_ruleset(name, block): {
      local p = path(['github_organization_ruleset', name]),
      _: p.ref._ {
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
      enforcement: p.child('enforcement').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      ruleset_id: p.child('ruleset_id').ref,
      target: p.child('target').ref,
    },
    organization_security_manager(name, block): {
      local p = path(['github_organization_security_manager', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      team_slug: p.child('team_slug').ref,
    },
    organization_settings(name, block): {
      local p = path(['github_organization_settings', name]),
      _: p.ref._ {
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
      advanced_security_enabled_for_new_repositories: p.child('advanced_security_enabled_for_new_repositories').ref,
      billing_email: p.child('billing_email').ref,
      blog: p.child('blog').ref,
      company: p.child('company').ref,
      default_repository_permission: p.child('default_repository_permission').ref,
      dependabot_alerts_enabled_for_new_repositories: p.child('dependabot_alerts_enabled_for_new_repositories').ref,
      dependabot_security_updates_enabled_for_new_repositories: p.child('dependabot_security_updates_enabled_for_new_repositories').ref,
      dependency_graph_enabled_for_new_repositories: p.child('dependency_graph_enabled_for_new_repositories').ref,
      description: p.child('description').ref,
      email: p.child('email').ref,
      has_organization_projects: p.child('has_organization_projects').ref,
      has_repository_projects: p.child('has_repository_projects').ref,
      id: p.child('id').ref,
      location: p.child('location').ref,
      members_can_create_internal_repositories: p.child('members_can_create_internal_repositories').ref,
      members_can_create_pages: p.child('members_can_create_pages').ref,
      members_can_create_private_pages: p.child('members_can_create_private_pages').ref,
      members_can_create_private_repositories: p.child('members_can_create_private_repositories').ref,
      members_can_create_public_pages: p.child('members_can_create_public_pages').ref,
      members_can_create_public_repositories: p.child('members_can_create_public_repositories').ref,
      members_can_create_repositories: p.child('members_can_create_repositories').ref,
      members_can_fork_private_repositories: p.child('members_can_fork_private_repositories').ref,
      name: p.child('name').ref,
      secret_scanning_enabled_for_new_repositories: p.child('secret_scanning_enabled_for_new_repositories').ref,
      secret_scanning_push_protection_enabled_for_new_repositories: p.child('secret_scanning_push_protection_enabled_for_new_repositories').ref,
      twitter_username: p.child('twitter_username').ref,
      web_commit_signoff_required: p.child('web_commit_signoff_required').ref,
    },
    organization_webhook(name, block): {
      local p = path(['github_organization_webhook', name]),
      _: p.ref._ {
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
      active: p.child('active').ref,
      etag: p.child('etag').ref,
      events: p.child('events').ref,
      id: p.child('id').ref,
      url: p.child('url').ref,
    },
    project_card(name, block): {
      local p = path(['github_project_card', name]),
      _: p.ref._ {
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
      card_id: p.child('card_id').ref,
      column_id: p.child('column_id').ref,
      content_id: p.child('content_id').ref,
      content_type: p.child('content_type').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      note: p.child('note').ref,
    },
    project_column(name, block): {
      local p = path(['github_project_column', name]),
      _: p.ref._ {
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
      column_id: p.child('column_id').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      project_id: p.child('project_id').ref,
    },
    release(name, block): {
      local p = path(['github_release', name]),
      _: p.ref._ {
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
      assets_url: p.child('assets_url').ref,
      body: p.child('body').ref,
      created_at: p.child('created_at').ref,
      discussion_category_name: p.child('discussion_category_name').ref,
      draft: p.child('draft').ref,
      etag: p.child('etag').ref,
      generate_release_notes: p.child('generate_release_notes').ref,
      html_url: p.child('html_url').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      prerelease: p.child('prerelease').ref,
      published_at: p.child('published_at').ref,
      release_id: p.child('release_id').ref,
      repository: p.child('repository').ref,
      tag_name: p.child('tag_name').ref,
      tarball_url: p.child('tarball_url').ref,
      target_commitish: p.child('target_commitish').ref,
      upload_url: p.child('upload_url').ref,
      url: p.child('url').ref,
      zipball_url: p.child('zipball_url').ref,
    },
    repository(name, block): {
      local p = path(['github_repository', name]),
      _: p.ref._ {
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
      allow_auto_merge: p.child('allow_auto_merge').ref,
      allow_merge_commit: p.child('allow_merge_commit').ref,
      allow_rebase_merge: p.child('allow_rebase_merge').ref,
      allow_squash_merge: p.child('allow_squash_merge').ref,
      allow_update_branch: p.child('allow_update_branch').ref,
      archive_on_destroy: p.child('archive_on_destroy').ref,
      archived: p.child('archived').ref,
      auto_init: p.child('auto_init').ref,
      default_branch: p.child('default_branch').ref,
      delete_branch_on_merge: p.child('delete_branch_on_merge').ref,
      description: p.child('description').ref,
      etag: p.child('etag').ref,
      full_name: p.child('full_name').ref,
      git_clone_url: p.child('git_clone_url').ref,
      gitignore_template: p.child('gitignore_template').ref,
      has_discussions: p.child('has_discussions').ref,
      has_downloads: p.child('has_downloads').ref,
      has_issues: p.child('has_issues').ref,
      has_projects: p.child('has_projects').ref,
      has_wiki: p.child('has_wiki').ref,
      homepage_url: p.child('homepage_url').ref,
      html_url: p.child('html_url').ref,
      http_clone_url: p.child('http_clone_url').ref,
      id: p.child('id').ref,
      ignore_vulnerability_alerts_during_read: p.child('ignore_vulnerability_alerts_during_read').ref,
      is_template: p.child('is_template').ref,
      license_template: p.child('license_template').ref,
      merge_commit_message: p.child('merge_commit_message').ref,
      merge_commit_title: p.child('merge_commit_title').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      primary_language: p.child('primary_language').ref,
      private: p.child('private').ref,
      repo_id: p.child('repo_id').ref,
      squash_merge_commit_message: p.child('squash_merge_commit_message').ref,
      squash_merge_commit_title: p.child('squash_merge_commit_title').ref,
      ssh_clone_url: p.child('ssh_clone_url').ref,
      svn_url: p.child('svn_url').ref,
      topics: p.child('topics').ref,
      visibility: p.child('visibility').ref,
      vulnerability_alerts: p.child('vulnerability_alerts').ref,
      web_commit_signoff_required: p.child('web_commit_signoff_required').ref,
    },
    repository_autolink_reference(name, block): {
      local p = path(['github_repository_autolink_reference', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      is_alphanumeric: p.child('is_alphanumeric').ref,
      key_prefix: p.child('key_prefix').ref,
      repository: p.child('repository').ref,
      target_url_template: p.child('target_url_template').ref,
    },
    repository_collaborator(name, block): {
      local p = path(['github_repository_collaborator', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      invitation_id: p.child('invitation_id').ref,
      permission: p.child('permission').ref,
      permission_diff_suppression: p.child('permission_diff_suppression').ref,
      repository: p.child('repository').ref,
      username: p.child('username').ref,
    },
    repository_collaborators(name, block): {
      local p = path(['github_repository_collaborators', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      invitation_ids: p.child('invitation_ids').ref,
      repository: p.child('repository').ref,
    },
    repository_dependabot_security_updates(name, block): {
      local p = path(['github_repository_dependabot_security_updates', name]),
      _: p.ref._ {
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
      enabled: p.child('enabled').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    repository_deploy_key(name, block): {
      local p = path(['github_repository_deploy_key', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      key: p.child('key').ref,
      read_only: p.child('read_only').ref,
      repository: p.child('repository').ref,
      title: p.child('title').ref,
    },
    repository_deployment_branch_policy(name, block): {
      local p = path(['github_repository_deployment_branch_policy', name]),
      _: p.ref._ {
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
      environment_name: p.child('environment_name').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      repository: p.child('repository').ref,
    },
    repository_environment(name, block): {
      local p = path(['github_repository_environment', name]),
      _: p.ref._ {
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
      can_admins_bypass: p.child('can_admins_bypass').ref,
      environment: p.child('environment').ref,
      id: p.child('id').ref,
      prevent_self_review: p.child('prevent_self_review').ref,
      repository: p.child('repository').ref,
      wait_timer: p.child('wait_timer').ref,
    },
    repository_environment_deployment_policy(name, block): {
      local p = path(['github_repository_environment_deployment_policy', name]),
      _: p.ref._ {
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
      branch_pattern: p.child('branch_pattern').ref,
      environment: p.child('environment').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    repository_file(name, block): {
      local p = path(['github_repository_file', name]),
      _: p.ref._ {
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
      branch: p.child('branch').ref,
      commit_author: p.child('commit_author').ref,
      commit_email: p.child('commit_email').ref,
      commit_message: p.child('commit_message').ref,
      commit_sha: p.child('commit_sha').ref,
      content: p.child('content').ref,
      file: p.child('file').ref,
      id: p.child('id').ref,
      overwrite_on_create: p.child('overwrite_on_create').ref,
      ref: p.child('ref').ref,
      repository: p.child('repository').ref,
      sha: p.child('sha').ref,
    },
    repository_milestone(name, block): {
      local p = path(['github_repository_milestone', name]),
      _: p.ref._ {
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
      description: p.child('description').ref,
      due_date: p.child('due_date').ref,
      id: p.child('id').ref,
      number: p.child('number').ref,
      owner: p.child('owner').ref,
      repository: p.child('repository').ref,
      state: p.child('state').ref,
      title: p.child('title').ref,
    },
    repository_project(name, block): {
      local p = path(['github_repository_project', name]),
      _: p.ref._ {
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
      body: p.child('body').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      repository: p.child('repository').ref,
      url: p.child('url').ref,
    },
    repository_pull_request(name, block): {
      local p = path(['github_repository_pull_request', name]),
      _: p.ref._ {
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
      base_ref: p.child('base_ref').ref,
      base_repository: p.child('base_repository').ref,
      base_sha: p.child('base_sha').ref,
      body: p.child('body').ref,
      draft: p.child('draft').ref,
      head_ref: p.child('head_ref').ref,
      head_sha: p.child('head_sha').ref,
      id: p.child('id').ref,
      labels: p.child('labels').ref,
      maintainer_can_modify: p.child('maintainer_can_modify').ref,
      number: p.child('number').ref,
      opened_at: p.child('opened_at').ref,
      opened_by: p.child('opened_by').ref,
      owner: p.child('owner').ref,
      state: p.child('state').ref,
      title: p.child('title').ref,
      updated_at: p.child('updated_at').ref,
    },
    repository_ruleset(name, block): {
      local p = path(['github_repository_ruleset', name]),
      _: p.ref._ {
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
      enforcement: p.child('enforcement').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      repository: p.child('repository').ref,
      ruleset_id: p.child('ruleset_id').ref,
      target: p.child('target').ref,
    },
    repository_tag_protection(name, block): {
      local p = path(['github_repository_tag_protection', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      pattern: p.child('pattern').ref,
      repository: p.child('repository').ref,
      tag_protection_id: p.child('tag_protection_id').ref,
    },
    repository_topics(name, block): {
      local p = path(['github_repository_topics', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      topics: p.child('topics').ref,
    },
    repository_webhook(name, block): {
      local p = path(['github_repository_webhook', name]),
      _: p.ref._ {
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
      active: p.child('active').ref,
      etag: p.child('etag').ref,
      events: p.child('events').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      url: p.child('url').ref,
    },
    team(name, block): {
      local p = path(['github_team', name]),
      _: p.ref._ {
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
      create_default_maintainer: p.child('create_default_maintainer').ref,
      description: p.child('description').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      ldap_dn: p.child('ldap_dn').ref,
      members_count: p.child('members_count').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      parent_team_id: p.child('parent_team_id').ref,
      parent_team_read_id: p.child('parent_team_read_id').ref,
      parent_team_read_slug: p.child('parent_team_read_slug').ref,
      privacy: p.child('privacy').ref,
      slug: p.child('slug').ref,
    },
    team_members(name, block): {
      local p = path(['github_team_members', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      team_id: p.child('team_id').ref,
    },
    team_membership(name, block): {
      local p = path(['github_team_membership', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      role: p.child('role').ref,
      team_id: p.child('team_id').ref,
      username: p.child('username').ref,
    },
    team_repository(name, block): {
      local p = path(['github_team_repository', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      permission: p.child('permission').ref,
      repository: p.child('repository').ref,
      team_id: p.child('team_id').ref,
    },
    team_settings(name, block): {
      local p = path(['github_team_settings', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      team_id: p.child('team_id').ref,
      team_slug: p.child('team_slug').ref,
      team_uid: p.child('team_uid').ref,
    },
    team_sync_group_mapping(name, block): {
      local p = path(['github_team_sync_group_mapping', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      team_slug: p.child('team_slug').ref,
    },
    user_gpg_key(name, block): {
      local p = path(['github_user_gpg_key', name]),
      _: p.ref._ {
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
      armored_public_key: p.child('armored_public_key').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      key_id: p.child('key_id').ref,
    },
    user_invitation_accepter(name, block): {
      local p = path(['github_user_invitation_accepter', name]),
      _: p.ref._ {
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
      allow_empty_id: p.child('allow_empty_id').ref,
      id: p.child('id').ref,
      invitation_id: p.child('invitation_id').ref,
    },
    user_ssh_key(name, block): {
      local p = path(['github_user_ssh_key', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      key: p.child('key').ref,
      title: p.child('title').ref,
      url: p.child('url').ref,
    },
  },
  data: {
    actions_environment_secrets(name, block): {
      local p = path(['data', 'github_actions_environment_secrets', name]),
      _: p.ref._ {
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
      environment: p.child('environment').ref,
      full_name: p.child('full_name').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      secrets: p.child('secrets').ref,
    },
    actions_environment_variables(name, block): {
      local p = path(['data', 'github_actions_environment_variables', name]),
      _: p.ref._ {
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
      environment: p.child('environment').ref,
      full_name: p.child('full_name').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      variables: p.child('variables').ref,
    },
    actions_organization_oidc_subject_claim_customization_template(name, block): {
      local p = path(['data', 'github_actions_organization_oidc_subject_claim_customization_template', name]),
      _: p.ref._ {
        block: {
          data: {
            github_actions_organization_oidc_subject_claim_customization_template: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      include_claim_keys: p.child('include_claim_keys').ref,
    },
    actions_organization_public_key(name, block): {
      local p = path(['data', 'github_actions_organization_public_key', name]),
      _: p.ref._ {
        block: {
          data: {
            github_actions_organization_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      key: p.child('key').ref,
      key_id: p.child('key_id').ref,
    },
    actions_organization_registration_token(name, block): {
      local p = path(['data', 'github_actions_organization_registration_token', name]),
      _: p.ref._ {
        block: {
          data: {
            github_actions_organization_registration_token: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      expires_at: p.child('expires_at').ref,
      id: p.child('id').ref,
      token: p.child('token').ref,
    },
    actions_organization_secrets(name, block): {
      local p = path(['data', 'github_actions_organization_secrets', name]),
      _: p.ref._ {
        block: {
          data: {
            github_actions_organization_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      secrets: p.child('secrets').ref,
    },
    actions_organization_variables(name, block): {
      local p = path(['data', 'github_actions_organization_variables', name]),
      _: p.ref._ {
        block: {
          data: {
            github_actions_organization_variables: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      variables: p.child('variables').ref,
    },
    actions_public_key(name, block): {
      local p = path(['data', 'github_actions_public_key', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      key: p.child('key').ref,
      key_id: p.child('key_id').ref,
      repository: p.child('repository').ref,
    },
    actions_registration_token(name, block): {
      local p = path(['data', 'github_actions_registration_token', name]),
      _: p.ref._ {
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
      expires_at: p.child('expires_at').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      token: p.child('token').ref,
    },
    actions_repository_oidc_subject_claim_customization_template(name, block): {
      local p = path(['data', 'github_actions_repository_oidc_subject_claim_customization_template', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      include_claim_keys: p.child('include_claim_keys').ref,
      name: p.child('name').ref,
      use_default: p.child('use_default').ref,
    },
    actions_secrets(name, block): {
      local p = path(['data', 'github_actions_secrets', name]),
      _: p.ref._ {
        block: {
          data: {
            github_actions_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      secrets: p.child('secrets').ref,
    },
    actions_variables(name, block): {
      local p = path(['data', 'github_actions_variables', name]),
      _: p.ref._ {
        block: {
          data: {
            github_actions_variables: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      variables: p.child('variables').ref,
    },
    app(name, block): {
      local p = path(['data', 'github_app', name]),
      _: p.ref._ {
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
      description: p.child('description').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      slug: p.child('slug').ref,
    },
    app_token(name, block): {
      local p = path(['data', 'github_app_token', name]),
      _: p.ref._ {
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
      app_id: p.child('app_id').ref,
      id: p.child('id').ref,
      installation_id: p.child('installation_id').ref,
      pem_file: p.child('pem_file').ref,
      token: p.child('token').ref,
    },
    branch(name, block): {
      local p = path(['data', 'github_branch', name]),
      _: p.ref._ {
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
      branch: p.child('branch').ref,
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      ref: p.child('ref').ref,
      repository: p.child('repository').ref,
      sha: p.child('sha').ref,
    },
    branch_protection_rules(name, block): {
      local p = path(['data', 'github_branch_protection_rules', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      rules: p.child('rules').ref,
    },
    codespaces_organization_public_key(name, block): {
      local p = path(['data', 'github_codespaces_organization_public_key', name]),
      _: p.ref._ {
        block: {
          data: {
            github_codespaces_organization_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      key: p.child('key').ref,
      key_id: p.child('key_id').ref,
    },
    codespaces_organization_secrets(name, block): {
      local p = path(['data', 'github_codespaces_organization_secrets', name]),
      _: p.ref._ {
        block: {
          data: {
            github_codespaces_organization_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      secrets: p.child('secrets').ref,
    },
    codespaces_public_key(name, block): {
      local p = path(['data', 'github_codespaces_public_key', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      key: p.child('key').ref,
      key_id: p.child('key_id').ref,
      repository: p.child('repository').ref,
    },
    codespaces_secrets(name, block): {
      local p = path(['data', 'github_codespaces_secrets', name]),
      _: p.ref._ {
        block: {
          data: {
            github_codespaces_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      secrets: p.child('secrets').ref,
    },
    codespaces_user_public_key(name, block): {
      local p = path(['data', 'github_codespaces_user_public_key', name]),
      _: p.ref._ {
        block: {
          data: {
            github_codespaces_user_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      key: p.child('key').ref,
      key_id: p.child('key_id').ref,
    },
    codespaces_user_secrets(name, block): {
      local p = path(['data', 'github_codespaces_user_secrets', name]),
      _: p.ref._ {
        block: {
          data: {
            github_codespaces_user_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      secrets: p.child('secrets').ref,
    },
    collaborators(name, block): {
      local p = path(['data', 'github_collaborators', name]),
      _: p.ref._ {
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
      affiliation: p.child('affiliation').ref,
      collaborator: p.child('collaborator').ref,
      id: p.child('id').ref,
      owner: p.child('owner').ref,
      repository: p.child('repository').ref,
    },
    dependabot_organization_public_key(name, block): {
      local p = path(['data', 'github_dependabot_organization_public_key', name]),
      _: p.ref._ {
        block: {
          data: {
            github_dependabot_organization_public_key: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      key: p.child('key').ref,
      key_id: p.child('key_id').ref,
    },
    dependabot_organization_secrets(name, block): {
      local p = path(['data', 'github_dependabot_organization_secrets', name]),
      _: p.ref._ {
        block: {
          data: {
            github_dependabot_organization_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      secrets: p.child('secrets').ref,
    },
    dependabot_public_key(name, block): {
      local p = path(['data', 'github_dependabot_public_key', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      key: p.child('key').ref,
      key_id: p.child('key_id').ref,
      repository: p.child('repository').ref,
    },
    dependabot_secrets(name, block): {
      local p = path(['data', 'github_dependabot_secrets', name]),
      _: p.ref._ {
        block: {
          data: {
            github_dependabot_secrets: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      secrets: p.child('secrets').ref,
    },
    enterprise(name, block): {
      local p = path(['data', 'github_enterprise', name]),
      _: p.ref._ {
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
      created_at: p.child('created_at').ref,
      database_id: p.child('database_id').ref,
      description: p.child('description').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      slug: p.child('slug').ref,
      url: p.child('url').ref,
    },
    external_groups(name, block): {
      local p = path(['data', 'github_external_groups', name]),
      _: p.ref._ {
        block: {
          data: {
            github_external_groups: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      external_groups: p.child('external_groups').ref,
      id: p.child('id').ref,
    },
    ip_ranges(name, block): {
      local p = path(['data', 'github_ip_ranges', name]),
      _: p.ref._ {
        block: {
          data: {
            github_ip_ranges: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      actions: p.child('actions').ref,
      actions_ipv4: p.child('actions_ipv4').ref,
      actions_ipv6: p.child('actions_ipv6').ref,
      api: p.child('api').ref,
      api_ipv4: p.child('api_ipv4').ref,
      api_ipv6: p.child('api_ipv6').ref,
      dependabot: p.child('dependabot').ref,
      dependabot_ipv4: p.child('dependabot_ipv4').ref,
      dependabot_ipv6: p.child('dependabot_ipv6').ref,
      git: p.child('git').ref,
      git_ipv4: p.child('git_ipv4').ref,
      git_ipv6: p.child('git_ipv6').ref,
      hooks: p.child('hooks').ref,
      hooks_ipv4: p.child('hooks_ipv4').ref,
      hooks_ipv6: p.child('hooks_ipv6').ref,
      id: p.child('id').ref,
      importer: p.child('importer').ref,
      importer_ipv4: p.child('importer_ipv4').ref,
      importer_ipv6: p.child('importer_ipv6').ref,
      packages: p.child('packages').ref,
      packages_ipv4: p.child('packages_ipv4').ref,
      packages_ipv6: p.child('packages_ipv6').ref,
      pages: p.child('pages').ref,
      pages_ipv4: p.child('pages_ipv4').ref,
      pages_ipv6: p.child('pages_ipv6').ref,
      web: p.child('web').ref,
      web_ipv4: p.child('web_ipv4').ref,
      web_ipv6: p.child('web_ipv6').ref,
    },
    issue_labels(name, block): {
      local p = path(['data', 'github_issue_labels', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      labels: p.child('labels').ref,
      repository: p.child('repository').ref,
    },
    membership(name, block): {
      local p = path(['data', 'github_membership', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      organization: p.child('organization').ref,
      role: p.child('role').ref,
      state: p.child('state').ref,
      username: p.child('username').ref,
    },
    organization(name, block): {
      local p = path(['data', 'github_organization', name]),
      _: p.ref._ {
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
      advanced_security_enabled_for_new_repositories: p.child('advanced_security_enabled_for_new_repositories').ref,
      default_repository_permission: p.child('default_repository_permission').ref,
      dependabot_alerts_enabled_for_new_repositories: p.child('dependabot_alerts_enabled_for_new_repositories').ref,
      dependabot_security_updates_enabled_for_new_repositories: p.child('dependabot_security_updates_enabled_for_new_repositories').ref,
      dependency_graph_enabled_for_new_repositories: p.child('dependency_graph_enabled_for_new_repositories').ref,
      description: p.child('description').ref,
      id: p.child('id').ref,
      ignore_archived_repos: p.child('ignore_archived_repos').ref,
      login: p.child('login').ref,
      members: p.child('members').ref,
      members_allowed_repository_creation_type: p.child('members_allowed_repository_creation_type').ref,
      members_can_create_internal_repositories: p.child('members_can_create_internal_repositories').ref,
      members_can_create_pages: p.child('members_can_create_pages').ref,
      members_can_create_private_pages: p.child('members_can_create_private_pages').ref,
      members_can_create_private_repositories: p.child('members_can_create_private_repositories').ref,
      members_can_create_public_pages: p.child('members_can_create_public_pages').ref,
      members_can_create_public_repositories: p.child('members_can_create_public_repositories').ref,
      members_can_create_repositories: p.child('members_can_create_repositories').ref,
      members_can_fork_private_repositories: p.child('members_can_fork_private_repositories').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      orgname: p.child('orgname').ref,
      plan: p.child('plan').ref,
      repositories: p.child('repositories').ref,
      secret_scanning_enabled_for_new_repositories: p.child('secret_scanning_enabled_for_new_repositories').ref,
      secret_scanning_push_protection_enabled_for_new_repositories: p.child('secret_scanning_push_protection_enabled_for_new_repositories').ref,
      two_factor_requirement_enabled: p.child('two_factor_requirement_enabled').ref,
      users: p.child('users').ref,
      web_commit_signoff_required: p.child('web_commit_signoff_required').ref,
    },
    organization_custom_role(name, block): {
      local p = path(['data', 'github_organization_custom_role', name]),
      _: p.ref._ {
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
      base_role: p.child('base_role').ref,
      description: p.child('description').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      permissions: p.child('permissions').ref,
    },
    organization_external_identities(name, block): {
      local p = path(['data', 'github_organization_external_identities', name]),
      _: p.ref._ {
        block: {
          data: {
            github_organization_external_identities: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      identities: p.child('identities').ref,
    },
    organization_ip_allow_list(name, block): {
      local p = path(['data', 'github_organization_ip_allow_list', name]),
      _: p.ref._ {
        block: {
          data: {
            github_organization_ip_allow_list: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      ip_allow_list: p.child('ip_allow_list').ref,
    },
    organization_team_sync_groups(name, block): {
      local p = path(['data', 'github_organization_team_sync_groups', name]),
      _: p.ref._ {
        block: {
          data: {
            github_organization_team_sync_groups: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      groups: p.child('groups').ref,
      id: p.child('id').ref,
    },
    organization_teams(name, block): {
      local p = path(['data', 'github_organization_teams', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      results_per_page: p.child('results_per_page').ref,
      root_teams_only: p.child('root_teams_only').ref,
      summary_only: p.child('summary_only').ref,
      teams: p.child('teams').ref,
    },
    organization_webhooks(name, block): {
      local p = path(['data', 'github_organization_webhooks', name]),
      _: p.ref._ {
        block: {
          data: {
            github_organization_webhooks: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      webhooks: p.child('webhooks').ref,
    },
    ref(name, block): {
      local p = path(['data', 'github_ref', name]),
      _: p.ref._ {
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
      etag: p.child('etag').ref,
      id: p.child('id').ref,
      owner: p.child('owner').ref,
      ref: p.child('ref').ref,
      repository: p.child('repository').ref,
      sha: p.child('sha').ref,
    },
    release(name, block): {
      local p = path(['data', 'github_release', name]),
      _: p.ref._ {
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
      asserts_url: p.child('asserts_url').ref,
      assets: p.child('assets').ref,
      assets_url: p.child('assets_url').ref,
      body: p.child('body').ref,
      created_at: p.child('created_at').ref,
      draft: p.child('draft').ref,
      html_url: p.child('html_url').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      owner: p.child('owner').ref,
      prerelease: p.child('prerelease').ref,
      published_at: p.child('published_at').ref,
      release_id: p.child('release_id').ref,
      release_tag: p.child('release_tag').ref,
      repository: p.child('repository').ref,
      retrieve_by: p.child('retrieve_by').ref,
      tarball_url: p.child('tarball_url').ref,
      target_commitish: p.child('target_commitish').ref,
      upload_url: p.child('upload_url').ref,
      url: p.child('url').ref,
      zipball_url: p.child('zipball_url').ref,
    },
    repositories(name, block): {
      local p = path(['data', 'github_repositories', name]),
      _: p.ref._ {
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
      full_names: p.child('full_names').ref,
      id: p.child('id').ref,
      include_repo_id: p.child('include_repo_id').ref,
      names: p.child('names').ref,
      query: p.child('query').ref,
      repo_ids: p.child('repo_ids').ref,
      results_per_page: p.child('results_per_page').ref,
      sort: p.child('sort').ref,
    },
    repository(name, block): {
      local p = path(['data', 'github_repository', name]),
      _: p.ref._ {
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
      allow_auto_merge: p.child('allow_auto_merge').ref,
      allow_merge_commit: p.child('allow_merge_commit').ref,
      allow_rebase_merge: p.child('allow_rebase_merge').ref,
      allow_squash_merge: p.child('allow_squash_merge').ref,
      archived: p.child('archived').ref,
      default_branch: p.child('default_branch').ref,
      description: p.child('description').ref,
      fork: p.child('fork').ref,
      full_name: p.child('full_name').ref,
      git_clone_url: p.child('git_clone_url').ref,
      has_discussions: p.child('has_discussions').ref,
      has_downloads: p.child('has_downloads').ref,
      has_issues: p.child('has_issues').ref,
      has_projects: p.child('has_projects').ref,
      has_wiki: p.child('has_wiki').ref,
      homepage_url: p.child('homepage_url').ref,
      html_url: p.child('html_url').ref,
      http_clone_url: p.child('http_clone_url').ref,
      id: p.child('id').ref,
      is_template: p.child('is_template').ref,
      merge_commit_message: p.child('merge_commit_message').ref,
      merge_commit_title: p.child('merge_commit_title').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      pages: p.child('pages').ref,
      primary_language: p.child('primary_language').ref,
      private: p.child('private').ref,
      repo_id: p.child('repo_id').ref,
      repository_license: p.child('repository_license').ref,
      squash_merge_commit_message: p.child('squash_merge_commit_message').ref,
      squash_merge_commit_title: p.child('squash_merge_commit_title').ref,
      ssh_clone_url: p.child('ssh_clone_url').ref,
      svn_url: p.child('svn_url').ref,
      template: p.child('template').ref,
      topics: p.child('topics').ref,
      visibility: p.child('visibility').ref,
    },
    repository_autolink_references(name, block): {
      local p = path(['data', 'github_repository_autolink_references', name]),
      _: p.ref._ {
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
      autolink_references: p.child('autolink_references').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    repository_branches(name, block): {
      local p = path(['data', 'github_repository_branches', name]),
      _: p.ref._ {
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
      branches: p.child('branches').ref,
      id: p.child('id').ref,
      only_non_protected_branches: p.child('only_non_protected_branches').ref,
      only_protected_branches: p.child('only_protected_branches').ref,
      repository: p.child('repository').ref,
    },
    repository_deploy_keys(name, block): {
      local p = path(['data', 'github_repository_deploy_keys', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      keys: p.child('keys').ref,
      repository: p.child('repository').ref,
    },
    repository_deployment_branch_policies(name, block): {
      local p = path(['data', 'github_repository_deployment_branch_policies', name]),
      _: p.ref._ {
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
      deployment_branch_policies: p.child('deployment_branch_policies').ref,
      environment_name: p.child('environment_name').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    repository_environments(name, block): {
      local p = path(['data', 'github_repository_environments', name]),
      _: p.ref._ {
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
      environments: p.child('environments').ref,
      id: p.child('id').ref,
      repository: p.child('repository').ref,
    },
    repository_file(name, block): {
      local p = path(['data', 'github_repository_file', name]),
      _: p.ref._ {
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
      branch: p.child('branch').ref,
      commit_author: p.child('commit_author').ref,
      commit_email: p.child('commit_email').ref,
      commit_message: p.child('commit_message').ref,
      commit_sha: p.child('commit_sha').ref,
      content: p.child('content').ref,
      file: p.child('file').ref,
      id: p.child('id').ref,
      ref: p.child('ref').ref,
      repository: p.child('repository').ref,
      sha: p.child('sha').ref,
    },
    repository_milestone(name, block): {
      local p = path(['data', 'github_repository_milestone', name]),
      _: p.ref._ {
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
      description: p.child('description').ref,
      due_date: p.child('due_date').ref,
      id: p.child('id').ref,
      number: p.child('number').ref,
      owner: p.child('owner').ref,
      repository: p.child('repository').ref,
      state: p.child('state').ref,
      title: p.child('title').ref,
    },
    repository_pull_request(name, block): {
      local p = path(['data', 'github_repository_pull_request', name]),
      _: p.ref._ {
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
      base_ref: p.child('base_ref').ref,
      base_repository: p.child('base_repository').ref,
      base_sha: p.child('base_sha').ref,
      body: p.child('body').ref,
      draft: p.child('draft').ref,
      head_owner: p.child('head_owner').ref,
      head_ref: p.child('head_ref').ref,
      head_repository: p.child('head_repository').ref,
      head_sha: p.child('head_sha').ref,
      id: p.child('id').ref,
      labels: p.child('labels').ref,
      maintainer_can_modify: p.child('maintainer_can_modify').ref,
      number: p.child('number').ref,
      opened_at: p.child('opened_at').ref,
      opened_by: p.child('opened_by').ref,
      owner: p.child('owner').ref,
      state: p.child('state').ref,
      title: p.child('title').ref,
      updated_at: p.child('updated_at').ref,
    },
    repository_pull_requests(name, block): {
      local p = path(['data', 'github_repository_pull_requests', name]),
      _: p.ref._ {
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
      base_ref: p.child('base_ref').ref,
      base_repository: p.child('base_repository').ref,
      head_ref: p.child('head_ref').ref,
      id: p.child('id').ref,
      owner: p.child('owner').ref,
      results: p.child('results').ref,
      sort_by: p.child('sort_by').ref,
      sort_direction: p.child('sort_direction').ref,
      state: p.child('state').ref,
    },
    repository_teams(name, block): {
      local p = path(['data', 'github_repository_teams', name]),
      _: p.ref._ {
        block: {
          data: {
            github_repository_teams: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      full_name: p.child('full_name').ref,
      id: p.child('id').ref,
      name: p.child('name').ref,
      teams: p.child('teams').ref,
    },
    repository_webhooks(name, block): {
      local p = path(['data', 'github_repository_webhooks', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      repository: p.child('repository').ref,
      webhooks: p.child('webhooks').ref,
    },
    rest_api(name, block): {
      local p = path(['data', 'github_rest_api', name]),
      _: p.ref._ {
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
      body: p.child('body').ref,
      code: p.child('code').ref,
      endpoint: p.child('endpoint').ref,
      headers: p.child('headers').ref,
      id: p.child('id').ref,
      status: p.child('status').ref,
    },
    ssh_keys(name, block): {
      local p = path(['data', 'github_ssh_keys', name]),
      _: p.ref._ {
        block: {
          data: {
            github_ssh_keys: {
              [name]: std.prune({
              }),
            },
          },
        },
      },
      id: p.child('id').ref,
      keys: p.child('keys').ref,
    },
    team(name, block): {
      local p = path(['data', 'github_team', name]),
      _: p.ref._ {
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
      description: p.child('description').ref,
      id: p.child('id').ref,
      members: p.child('members').ref,
      membership_type: p.child('membership_type').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      permission: p.child('permission').ref,
      privacy: p.child('privacy').ref,
      repositories: p.child('repositories').ref,
      repositories_detailed: p.child('repositories_detailed').ref,
      results_per_page: p.child('results_per_page').ref,
      slug: p.child('slug').ref,
      summary_only: p.child('summary_only').ref,
    },
    tree(name, block): {
      local p = path(['data', 'github_tree', name]),
      _: p.ref._ {
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
      entries: p.child('entries').ref,
      id: p.child('id').ref,
      recursive: p.child('recursive').ref,
      repository: p.child('repository').ref,
      tree_sha: p.child('tree_sha').ref,
    },
    user(name, block): {
      local p = path(['data', 'github_user', name]),
      _: p.ref._ {
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
      avatar_url: p.child('avatar_url').ref,
      bio: p.child('bio').ref,
      blog: p.child('blog').ref,
      company: p.child('company').ref,
      created_at: p.child('created_at').ref,
      email: p.child('email').ref,
      followers: p.child('followers').ref,
      following: p.child('following').ref,
      gpg_keys: p.child('gpg_keys').ref,
      gravatar_id: p.child('gravatar_id').ref,
      id: p.child('id').ref,
      location: p.child('location').ref,
      login: p.child('login').ref,
      name: p.child('name').ref,
      node_id: p.child('node_id').ref,
      public_gists: p.child('public_gists').ref,
      public_repos: p.child('public_repos').ref,
      site_admin: p.child('site_admin').ref,
      ssh_keys: p.child('ssh_keys').ref,
      suspended_at: p.child('suspended_at').ref,
      updated_at: p.child('updated_at').ref,
      username: p.child('username').ref,
    },
    user_external_identity(name, block): {
      local p = path(['data', 'github_user_external_identity', name]),
      _: p.ref._ {
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
      id: p.child('id').ref,
      login: p.child('login').ref,
      saml_identity: p.child('saml_identity').ref,
      scim_identity: p.child('scim_identity').ref,
      username: p.child('username').ref,
    },
    users(name, block): {
      local p = path(['data', 'github_users', name]),
      _: p.ref._ {
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
      emails: p.child('emails').ref,
      id: p.child('id').ref,
      logins: p.child('logins').ref,
      node_ids: p.child('node_ids').ref,
      unknown_logins: p.child('unknown_logins').ref,
      usernames: p.child('usernames').ref,
    },
  },
};

provider
