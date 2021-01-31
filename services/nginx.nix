# Configuration shamelessly stolen from [1]
#
# [1]: https://github.com/delroth/infra.delroth.net/blob/master/common/nginx.nix
{ config, lib, ... }:

{
  # Whenever something defines an nginx vhost, ensure that nginx defaults are
  # properly set.
  config = lib.mkIf ((builtins.attrNames config.services.nginx.virtualHosts) != [ ]) {
    services.nginx = {
      enable = true;
      statusPage = true; # For monitoring scraping.

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    # Nginx needs to be able to read the certificates
    users.users.nginx.extraGroups = [ "acme" ];

    # Use DNS wildcard certificate
    security.acme = {
      email = "bruno.acme@belanyi.fr";
      acceptTerms = true;
      certs =
        let
          domain = config.networking.domain;
        in
        {
          "${domain}" = {
            extraDomainNames = [ "*.${domain}" ];
            dnsProvider = "gandiv5";
            credentialsFile = ../secrets/acme/key.env;
          };
        };
    };
  };
}
