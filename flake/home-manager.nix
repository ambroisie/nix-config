{ self, config, inputs, lib, ... }:
let
  inherit (config) hosts;

  defaultModules = [
    # Include generic settings
    "${self}/modules/home"
    {
      nixpkgs.overlays = (lib.attrValues self.overlays) ++ [
        inputs.nur.overlays.default
      ];
    }
    {
      # Basic user information defaults
      home.username = lib.mkDefault "ambroisie";
      home.homeDirectory = lib.mkDefault "/home/ambroisie";

      # Make it a Linux installation by default
      targets.genericLinux.enable = lib.mkDefault true;

      # Enable home-manager
      programs.home-manager.enable = true;
    }
    # Import common modules
    "${self}/modules/common"
  ];

  mkHome = name: system: inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};

    modules = defaultModules ++ [
      "${self}/hosts/homes/${name}"
    ];

    # Use my extended lib in NixOS configuration
    inherit (self) lib;

    extraSpecialArgs = {
      # Inject inputs to use them in global registry
      inherit inputs;
    };
  };

in
{
  hosts.homes = {
    "ambroisie@bazin" = "x86_64-linux";
    "ambroisie@mousqueton" = "x86_64-linux";
  };

  perSystem = { system, ... }: {
    # Work-around for https://github.com/nix-community/home-manager/issues/3075
    legacyPackages = {
      homeConfigurations =
        let
          filteredHomes = lib.filterAttrs (_: v: v == system) hosts.homes;
          allHomes = filteredHomes // {
            # Default configuration
            ambroisie = system;
          };
        in
        lib.mapAttrs mkHome allHomes;
    };
  };
}
