{ config, lib, ... }:
let
  cfg = config.my.services.servarr.bazarr;
in
{
  options.my.services.servarr.bazarr = with lib; {
    enable = lib.mkEnableOption "Bazarr" // {
      default = config.my.services.servarr.enableAll;
    };
  };

  config = lib.mkIf cfg.enable {
    services.bazarr = {
      enable = true;
      group = "media";
    };

    # Set-up media group
    users.groups.media = { };

    my.services.nginx.virtualHosts = {
      bazarr = {
        port = 6767;
      };
    };

    # Bazarr does not log authentication failures...
  };
}
