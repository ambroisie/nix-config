# User setup
{ config, lib, ... }:
let
  my = config.my;
  groupIfExists = grp:
    lib.lists.optional
      (builtins.hasAttr grp config.users.groups)
      grp;
  groupsIfExist = grps: builtins.concatMap groupIfExists grps;
in
{
  users.users.blog = {
    description = "Blog Publisher";
    isNormalUser = true;
    group = "nginx";
    createHome = false; # Messes with permissions
    home = "/var/www/";
    openssh.authorizedKeys.keys = [ my.secrets.drone.ssh.publicKey ];
  };

  users.users.ambroisie.extraGroups = groupsIfExist [
    "media"
  ];
}
