# Abstracting away the need for a common 'media' group

{ config, lib, ... }:
let
  needed = with config.my.services;
    jellyfin.enable || pirate.enable;
in
{
  config.users.groups.media = lib.mkIf needed { };
}
