# A low-ressource, full-featured git forge.
{ config, lib, ... }:
let
  cfg = config.my.services.gitea;
  domain = config.networking.domain;
  giteaDomain = "gitea.${config.networking.domain}";
in
{
  options.my.services.gitea = {
    enable = lib.mkEnableOption "Gitea";
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;
      appName = "Ambroisie's Gitea";
      domain = "${giteaDomain}";
      rootUrl = "https://${giteaDomain}";
      useWizard = true;
      disableRegistration = true;
      lfs.enable = true;
    };

    # Enable DB
    services.postgresql = {
      enable = true;
      authentication = ''
        local gitea all ident map=gitea-users
      '';
      identMap = '' # Map the gitea user to postgresql
        gitea-users gitea gitea
      '';
    };

    # Proxy to Gitea
    services.nginx.virtualHosts."${giteaDomain}" = {
      forceSSL = true;
      useACMEHost = "${domain}";

      locations."/".proxyPass = "http://localhost:3000/";
    };
  };
}
