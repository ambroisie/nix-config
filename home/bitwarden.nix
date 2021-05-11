{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.bitwarden;
in
{
  options.my.home.bitwarden = with lib; {
    enable = my.mkDisableOption "bitwarden configuration";

    pinentry = mkOption {
      type = types.str;
      default = "tty";
      example = "gtk2";
      description = "Which pinentry interface to use";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rbw = {
      enable = true;

      settings = {
        email = "bruno@belanyi.fr";
        pinentryFlavor = cfg.pinentry;
      };
    };
  };
}
