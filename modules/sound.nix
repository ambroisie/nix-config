{ config, lib, ... }:
let
  cfg = config.my.modules.sound;
in
{
  options.my.modules.sound = with lib; {
    enable = mkEnableOption "sound configuration";

    pulse = {
      enable = mkEnableOption "pulseaudio configuration";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Basic configuration
    {
      sound.enable = true;
    }

    # Pulseaudio setup
    (lib.mkIf cfg.pulse.enable {
      hardware.pulseaudio.enable = true;
    })
  ]);
}
