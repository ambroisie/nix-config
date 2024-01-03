# Configuration that spans across system and home, or are almagations of modules
{ ... }:
{
  imports = [
    ./gtk
    ./laptop
    ./wm
    ./x
  ];
}
