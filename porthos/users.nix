# User setup
{ config, ... }:
let
  my = config.my;
in
{
  users.users.blog = {
    description = "Blog Publisher";
    isNormalUser = true;
    group = "nginx";
    createHome = true; # Ensures correct permissions
    home = "/var/www/";
    openssh.authorizedKeys.keys = [ my.secrets.drone.ssh.publicKey ];
  };
}
