{ config, inputs, lib, ... }:
let
  cfg = config.my.home.nix-gl;
in
{
  options.my.home.nix-gl = with lib; {
    enable = mkEnableOption "nixGL configuration";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      nixGL = {
        inherit (inputs.nixgl) packages;
      };
    }
  ]);
}
