local terraformStack(resources) =
  local requiredProviders = std.foldl(
    function(acc, provider) std.mergePatch(acc, provider),
    [resource.__required_provider__ for resource in resources],
    {}
  );
  local terraform = {
    terraform: {
      required_providers: requiredProviders,
    },
  };
  local blocks = [resource.__block__ for resource in resources];
  [terraform] + blocks;

terraformStack
