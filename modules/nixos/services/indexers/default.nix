# Torrent and usenet meta-indexers
{ config, lib, ... }:
let
  cfg = config.my.services.indexers;

  nzbhydraPort = 5076;
in
{
  options.my.services.indexers = with lib; {
    nzbhydra.enable = mkEnableOption "NZBHydra2 usenet meta-indexer";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.nzbhydra.enable {
      services.nzbhydra2 = {
        enable = true;
      };

      my.services.nginx.virtualHosts = {
        nzbhydra = {
          port = nzbhydraPort;
        };
      };
    })
  ];
}
