# A docker-based CI/CD system
#
# Inspired by [1]
# [1]: https://github.com/Mic92/dotfiles/blob/master/nixos/eve/modules/drone.nix
{ lib, ... }:
{
  imports = [
    ./agent-docker
    ./agent-local
    ./server
  ];

  options.my.services.woodpecker = with lib; {
    enable = mkEnableOption "Woodpecker CI";
    runners = mkOption {
      type = with types; listOf (enum [ "local" "docker" ]);
      default = [ ];
      example = [ "local" "docker" ];
      description = "Types of runners to enable";
    };
    admin = mkOption {
      type = types.str;
      default = "ambroisie";
      example = "admin";
      description = "Name of the admin user";
    };
    port = mkOption {
      type = types.port;
      default = 3031;
      example = 8080;
      description = "Internal port of the Woodpecker UI";
    };
    grpcPort = mkOption {
      type = types.port;
      default = 9001;
      example = 8080;
      description = "Internal port of the Woodpecker gRPC";
    };
    secretFile = mkOption {
      type = types.str;
      example = "/run/secrets/woodpecker-gitea.env";
      description = "Secrets to inject into Woodpecker server";
    };
    sharedSecretFile = mkOption {
      type = types.str;
      example = "/run/secrets/woodpecker-rpc.env";
      description = "Shared RPC secret to inject into server and runners";
    };
  };
}
