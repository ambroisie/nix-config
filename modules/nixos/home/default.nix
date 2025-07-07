{ config, inputs, lib, ... }:
let
  actualPath = [ "home-manager" "users" config.my.user.name "my" "home" ];
  aliasPath = [ "my" "home" ];

  cfg = config.my.user.home;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager # enable home-manager options
    (lib.mkAliasOptionModule aliasPath actualPath) # simplify setting home options
  ];

  config = lib.mkIf cfg.enable {
    home-manager = {
      users.${config.my.user.name} = {
        # Not a fan of out-of-directory imports, but this is a good exception
        imports = [
          "${inputs.self}/modules/common"
          "${inputs.self}/modules/home"
        ];
      };

      # Nix Flakes compatibility
      useGlobalPkgs = true;
      useUserPackages = true;

      # Forward inputs to home-manager configuration
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
