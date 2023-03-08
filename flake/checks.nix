{ self, inputs, ... }:
{
  perSystem = { system, ... }: {
    checks = {
      # NOTE: seems like inputs' does not output the 'lib' attribute
      pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
        src = self;

        hooks = {
          nixpkgs-fmt = {
            enable = true;
          };

          shellcheck = {
            enable = true;
          };
        };
      };
    };
  };
}
