{ self, inputs, ... }:
{
  perSystem = { system, ... }: {
    # Work-around for https://github.com/nix-community/home-manager/issues/3075
    legacyPackages = {
      homeConfigurations = {
        ambroisie = inputs.home-manager.lib.homeManagerConfiguration {
          # Work-around for home-manager
          # * not letting me set `lib` as an extraSpecialArgs
          # * not respecting `nixpkgs.overlays` [1]
          # [1]: https://github.com/nix-community/home-manager/issues/2954
          pkgs = import inputs.nixpkgs {
            inherit system;

            overlays = (lib.attrValues self.overlays) ++ [
              inputs.nur.overlay
            ];
          };

          modules = [
            "${self}/home"
            {
              # The basics
              home.username = "ambroisie";
              home.homeDirectory = "/home/ambroisie";
              # Let Home Manager install and manage itself.
              programs.home-manager.enable = true;
              # This is a generic linux install
              targets.genericLinux.enable = true;
            }
          ];

          extraSpecialArgs = {
            # Inject inputs to use them in global registry
            inherit inputs;
          };
        };
      };
    };
  };
}
