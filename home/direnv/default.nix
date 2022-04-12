{ config, lib, ... }:
let
  cfg = config.my.home.direnv;
in
{
  options.my.home.direnv = with lib.my; {
    enable = mkDisableOption "direnv configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv = {
        # A better `use_nix`
        enable = true;
      };
    };

    xdg.configFile =
      let
        libDir = ./lib;
        contents = builtins.readDir libDir;
        names = lib.attrNames contents;
        files = lib.filter (name: contents.${name} == "regular") names;
        linkLibFile = name:
          lib.nameValuePair
            "direnv/lib/${name}"
            { source = libDir + "/${name}"; };
      in
      lib.my.genAttrs' files linkLibFile;
  };
}
