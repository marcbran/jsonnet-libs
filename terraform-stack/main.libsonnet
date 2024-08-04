local terraformStack(resources) =
  local requiredProviders = std.foldl(
    function(acc, provider) std.mergePatch(acc, provider),
    [resource._required_provider for resource in resources],
    {}
  );
  local terraform = {
    terraform: {
      required_providers: requiredProviders,
    },
  };
  local blocks = [resource._block for resource in resources];
  [terraform] + blocks;

terraformStack
