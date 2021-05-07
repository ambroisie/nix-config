{ config, lib, ... }:
let
  cfg = config.my.module.documentation;
in
{
  options.my.module.documentation = with lib.my; {
    enable = mkDisableOption "Documentation integration";

    dev.enable = mkDisableOption "Documentation aimed at developers";

    info.enable = mkDisableOption "Documentation aimed at developers";

    man.enable = mkDisableOption "Documentation aimed at developers";

    nixos.enable = mkDisableOption "NixOS documentation";
  };

  config.documentation = {
    enable = cfg.enable;

    dev.enable = cfg.dev.enable;

    info.enable = cfg.info.enable;

    man = {
      enable = cfg.man.enable;
      generateCaches = true;
    };

    nixos.enable = cfg.nixos.enable;
  };
}
