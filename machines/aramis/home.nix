{ pkgs, ... }:
{
  my.home = {
    # Image viewver
    feh.enable = true;
    # Firefo profile and extensions
    firefox.enable = true;
    # Blue light filter
    gammastep.enable = true;
    # Use a small popup to enter passwords
    gpg.pinentry = "gtk2";
    # Machine specific packages
    packages.additionalPackages = with pkgs; [
      jellyfin-media-player # Wraps the webui and mpv together
      pavucontrol # Audio mixer GUI
      quasselClient # IRC client
      transgui # Transmission remote
    ];
    # Network-Manager applet
    nm-applet.enable = true;
    # Termite terminal
    terminal.program = "termite";
    # Keyboard settings
    x.enable = true;
    # Zathura document viewer
    zathura.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Nice wallpaper
  services.xserver.displayManager.lightdm.background =
    let
      wallpapers = "${pkgs.plasma-workspace-wallpapers}/share/wallpapers";
    in
    "${wallpapers}/summer_1am/contents/images/2560x1600.jpg";
}
