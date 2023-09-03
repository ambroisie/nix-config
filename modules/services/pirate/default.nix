# The total autonomous media delivery system.
# Relevant link [1].
#
# [1]: https://youtu.be/I26Ql-uX6AM
{ config, lib, ... }:
let
  cfg = config.my.services.pirate;

  ports = {
    bazarr = 6767;
    lidarr = 8686;
    radarr = 7878;
    sonarr = 8989;
  };

  mkService = service: {
    services.${service} = {
      enable = true;
      group = "media";
    };
  };

  mkRedirection = service: {
    my.services.nginx.virtualHosts = [
      {
        subdomain = service;
        port = ports.${service};
      }
    ];
  };

  mkFullConfig = service: lib.mkMerge [
    (mkService service)
    (mkRedirection service)
  ];
in
{
  options.my.services.pirate = {
    enable = lib.mkEnableOption "Media automation";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      # Set-up media group
      users.groups.media = { };
    }
    # Bazarr for subtitles
    (mkFullConfig "bazarr")
    # Lidarr for music
    (mkFullConfig "lidarr")
    # Radarr for movies
    (mkFullConfig "radarr")
    # Sonarr for shows
    (mkFullConfig "sonarr")
  ]);
}
