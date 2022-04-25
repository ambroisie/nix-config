{ config, lib, pkgs, ... }:
let
  cfg = config.my.hardware.bluetooth;
in
{
  options.my.hardware.bluetooth = with lib; {
    enable = mkEnableOption "bluetooth configuration";

    enableHeadsetIntegration = my.mkDisableOption "A2DP sink configuration";

    loadExtraCodecs = my.mkDisableOption "extra audio codecs";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Enable bluetooth devices and GUI to connect to them
    {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    }

    # Support for additional bluetooth codecs
    (lib.mkIf cfg.loadExtraCodecs {
      hardware.pulseaudio = {
        extraModules = [ pkgs.pulseaudio-modules-bt ];
        package = pkgs.pulseaudioFull;
      };

      # FIXME: waiting for NixOS module configuration
      environment.etc = {
        "wireplumber/bluetooth.lua.d/50-bluez-config.lua".text = ''
          bluez_monitor.properties = {
            ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
            -- mSBC provides better audio + microphone
            ["bluez5.enable-msbc"] = true,
            -- SBC XQ provides better audio
            ["bluez5.enable-sbc-xq"] = true,
            -- Hardware volume control
            ["bluez5.enable-hw-volume"] = true,
          }
        '';
      };

      services.pipewire = {
        media-session.config.bluez-monitor.rules = [
          {
            # Matches all cards
            matches = [{ "device.name" = "~bluez_card.*"; }];
            actions = {
              "update-props" = {
                "bluez5.reconnect-profiles" = [
                  "hfp_hf"
                  "hsp_hs"
                  "a2dp_sink"
                ];
                # mSBC provides better audio + microphone
                "bluez5.msbc-support" = true;
                # SBC XQ provides better audio
                "bluez5.sbc-xq-support" = true;
              };
            };
          }
          {
            matches = [
              # Matches all sources
              {
                "node.name" = "~bluez_input.*";
              }
              # Matches all outputs
              {
                "node.name" = "~bluez_output.*";
              }
            ];
            actions = {
              "node.pause-on-idle" = false;
            };
          }
        ];
      };
    })

    # Support for A2DP audio profile
    (lib.mkIf cfg.enableHeadsetIntegration {
      hardware.bluetooth.settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    })
  ]);
}
