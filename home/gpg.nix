{ ... }:
{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true; # One agent to rule them all
    pinentryFlavor = "curses";
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}
