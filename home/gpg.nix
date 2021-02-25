{ ... }:
{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true; # One agent to rule them all
    pinentryFlavor = "tty";
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}
