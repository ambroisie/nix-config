# Simplify setting home options
{ config, lib, ... }:
let
  actualPath = [ "home-manager" "users" config.my.user.name "my" "home" ];
  aliasPath = [ "my" "home" ];
in
{
  imports = [
    (lib.mkAliasOptionModule aliasPath actualPath)
  ];
}
