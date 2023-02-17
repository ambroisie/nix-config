{ self, inputs, ... }:
let
  inherit (inputs)
    deploy-rs
    ;
  inherit (self) lib;
in
{
  perSystem = { system, ... }: {
    checks = deploy-rs.lib.${system}.deployChecks self.deploy;
  };

  flake = {
    deploy = {
      nodes = {
        porthos = {
          hostname = "belanyi.fr";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.porthos;
          };
        };
      };
    };
  };
}
