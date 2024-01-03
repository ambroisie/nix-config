# Configuration that spans across system and home, or are almagations of modules
{ config, lib, _class, ... }:
{
  imports = [
    ./bluetooth
    ./devices
    ./gtk
    ./laptop
    ./wm
    ./x
  ];

  config = lib.mkMerge [
    # Transparently enable home-manager profiles as well
    (lib.optionalAttrs (_class != "homeManager") {
      home-manager.users.${config.my.user.name} = {
        config = {
          my = {
            inherit (config.my) profiles;
          };
        };
      };
    })
  ];
}
