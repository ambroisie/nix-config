{ ... }:
{
  my.home = {
    # Termite terminal
    terminal.program = "termite";
    # i3 settings
    wm.windowManager = "i3";
    # Keyboard settings
    x.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable i3
  services.xserver.windowManager.i3.enable = true;
}
