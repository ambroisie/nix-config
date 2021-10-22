# An SSH server, using 'mosh'
{ config, lib, ... }:
let
  cfg = config.my.services.ssh-server;
in
{
  options.my.services.ssh-server = {
    enable = lib.mkEnableOption "SSH Server using 'mosh'";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      # Enable the OpenSSH daemon.
      enable = true;

      settings = {
        # Be more secure
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # Persist SSH keys
    my.system.persist.files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    # Opens the relevant UDP ports.
    programs.mosh.enable = true;
  };
}
