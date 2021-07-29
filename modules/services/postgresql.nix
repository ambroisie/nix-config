{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.postgresql;
in
{
  options.my.services.postgresql = with lib; {
    enable = my.mkDisableOption "postgres configuration";
  };

  config = lib.mkMerge [
    # Let other services enable postgres when they need it
    (lib.mkIf cfg.enable {
      services.postgresql = {
        package = pkgs.postgresql_12;
      };
    })
  ];
}
