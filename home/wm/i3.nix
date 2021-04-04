{ config, lib, pkgs, ... }:
let
  isEnabled = config.my.home.wm.windowManager == "i3";

  terminal = "i3-sensible-terminal";

  alt = "Mod1"; # `Alt` key
  modifier = "Mod4"; # `Super` key
  movementKeys = [ "Left" "Down" "Up" "Right" ];
  vimMovementKeys = [ "h" "j" "k" "l" ];
  shutdownMode =
    "(l)ock, (e)xit, switch_(u)ser, (h)ibernate, (r)eboot, (Shift+s)hutdown";

  # Takes an attrset of bindings for movement keys, transforms it to Vim keys
  toVimKeyBindings =
    let
      toVimKeys = builtins.replaceStrings movementKeys vimMovementKeys;
    in
    lib.my.renameAttrs toVimKeys;

  # Takes an attrset of bindings for movement keys, add equivalent Vim keys
  addVimKeyBindings = bindings: bindings // (toVimKeyBindings bindings);
  # Generate an attrset of movement bindings, using the mapper function
  genMovementBindings = f: addVimKeyBindings (lib.my.genAttrs' movementKeys f);
in
{
  config = lib.mkIf isEnabled {
    home.packages = with pkgs; [
      arandr # Used by a mapping
      flameshot # Used by a mapping, started at startup
      playerctl # Used by a mapping
    ];

    xsession.windowManager.i3 = {
      enable = true;

      config = {
        inherit modifier;

        bars =
          let
            barConfigPath =
              config.xdg.configFile."i3status-rust/config-top.toml".target;
          in
          [
            {
              statusCommand = "i3status-rs ${barConfigPath}";
              trayOutput = "primary";
              position = "top";

              colors = {
                background = "#021215";
                statusline = "#93a1a1";
                separator = "#2aa198";

                focusedWorkspace = {
                  border = "#2aa198";
                  background = "#073642";
                  text = "#eee895";
                };

                activeWorkspace = {
                  border = "#073642";
                  background = "#002b36";
                  text = "#839496";
                };

                inactiveWorkspace = {
                  border = "#002b36";
                  background = "#021215";
                  text = "#586e75";
                };

                urgentWorkspace = {
                  border = "#cb4b16";
                  background = "#dc322f";
                  text = "#fdf6e3";
                };
              };
            }
          ];

        floating = {
          inherit modifier;

          criteria = [
            { class = "^tridactyl_editor$"; }
            { class = "^Blueman-.*$"; }
            { title = "^htop$"; }
            { class = "^Thunderbird$"; instance = "Mailnews"; window_role = "filterlist"; }
            { class = "^Pavucontrol.*$"; }
            { class = "^Arandr$"; }
          ];
        };

        focus = {
          followMouse = true; # It is annoying sometimes, but useful enough to use
          mouseWarping = true; # Let's moving around when switching screens
        };

        fonts = [
          "DejaVu Sans Mono 8"
        ];

        # I don't care for i3's default values, I specify them all explicitly
        keybindings = builtins.foldl' (lhs: rhs: lhs // rhs) { } [
          {
            # The basics
            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+Shift+Return" = "exec env TMUX=nil ${terminal}";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+Shift+e" =
              "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
          }
          {
            # Splits
            "${modifier}+g" = "split h"; # Horizontally
            "${modifier}+v" = "split v"; # Vertically
          }
          {
            # Layouts
            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
          }
          {
            # Toggle tiling/floating
            "${modifier}+Control+space" = "floating toggle";
            # Change focus between tiling/floating
            "${modifier}+space" = "focus mode_toggle";
          }
          {
            # Focus parent container
            "${modifier}+q" = "focus parent";
            # Focus child container
            "${modifier}+a" = "focus child";
          }
          {
            # Rofi tools
            "${modifier}+d" = "exec rofi -show drun -disable-history";
            "${modifier}+Shift+d" = "exec rofi -show run -disable-history";
            "${modifier}+p" = "exec --no-startup-id flameshot gui";
            "${modifier}+Shift+p" = "exec rofi -show emoji";
          }
          (
            # Changing container focus
            genMovementBindings (
              key: lib.nameValuePair
                "${modifier}+${key}"
                "focus ${lib.toLower key}"
            )
          )
          (
            # Changing screen focus
            genMovementBindings (
              key: lib.nameValuePair
                "${modifier}+${alt}+${key}"
                "focus output ${lib.toLower key}"
            )
          )
          (
            # Moving workspace to another screen
            genMovementBindings (
              key: lib.nameValuePair
                "${modifier}+${alt}+Control+${key}"
                "move workspace to output ${lib.toLower key}"
            )
          )
          (
            # Moving container to another screen
            genMovementBindings (
              key: lib.nameValuePair
                "${modifier}+${alt}+Shift+${key}"
                "move container to output ${lib.toLower key}"
            )
          )
          (addVimKeyBindings {
            # Scroll through workspaces on given screen
            "${modifier}+Control+Left" = "workspace prev_on_output";
            "${modifier}+Control+Right" = "workspace next_on_output";
            # Use scratchpad
            "${modifier}+Control+Up" = "move to scratchpad";
            "${modifier}+Control+Down" = "scratchpad show";
          })
          (
            # Moving floating window
            genMovementBindings (
              key: lib.nameValuePair
                "${modifier}+Shift+${key}"
                "move ${lib.toLower key} 10 px"
            )
          )
          {
            # Media keys
            "XF86AudioRaiseVolume" = "exec amixer -q -D pulse sset Master 5%+";
            "XF86AudioLowerVolume" = "exec amixer -q -D pulse sset Master 5%-";
            "Control+XF86AudioRaiseVolume" = "exec amixer -q -D pulse sset Master 1%+";
            "Control+XF86AudioLowerVolume" = "exec amixer -q -D pulse sset Master 1%-";
            "XF86AudioMute" = "exec amixer -q -D pulse sset Master toggle";

            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
          }
          {
            # Sub-modes
            "${modifier}+r" = "mode resize";
            "${modifier}+Shift+space" = "mode floating";
            "${modifier}+0" = ''mode "${shutdownMode}"'';
          }
        ];

        keycodebindings =
          let
            toKeycode = n: if n == 0 then 19 else n + 9;
            createWorkspaceBindings = mapping: command:
              let
                createWorkspaceBinding = num:
                  lib.nameValuePair
                    "${mapping}+${toString (toKeycode num)}"
                    "${command} ${toString num}";
                oneToNine = builtins.genList (x: x + 1) 9;
              in
              lib.my.genAttrs' oneToNine createWorkspaceBinding;
          in
          builtins.foldl' (lhs: rhs: lhs // rhs) { } [
            (createWorkspaceBindings modifier "workspace number")
            (createWorkspaceBindings "${modifier}+Shift" "move container to workspace number")
          ];

        modes =
          let
            makeModeBindings = attrs: (addVimKeyBindings attrs) // {
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          in
          {
            resize = makeModeBindings {
              # Normal movements
              "Left" = "resize shrink width 10 px or 10 ppt";
              "Down" = "resize grow height 10 px or 10 ppt";
              "Up" = "resize shrink height 10 px or 10 ppt";
              "Right" = "resize grow width 10 px or 10 ppt";
              # Small movements
              "Control+Left" = "resize shrink width 1 px or 1 ppt";
              "Control+Down" = "resize grow height 1 px or 1 ppt";
              "Control+Up" = "resize shrink height 1 px or 1 ppt";
              "Control+Right" = "resize grow width 1 px or 1 ppt";
              # Big movements
              "Shift+Left" = "resize shrink width 100 px or 100 ppt";
              "Shift+Down" = "resize grow height 100 px or 100 ppt";
              "Shift+Up" = "resize shrink height 100 px or 100 ppt";
              "Shift+Right" = "resize grow width 100 px or 100 ppt";
            };

            floating = makeModeBindings {
              # Normal movements
              "Left" = "move left 10 px";
              "Down" = "move down 10 px";
              "Up" = "move up 10 px";
              "Right" = "move right 10 px";
              # Small movements
              "Control+Left" = "move left 1 px";
              "Control+Down" = "move down 1 px";
              "Control+Up" = "move up 1 px";
              "Control+Right" = "move right 1 px";
              # Big movements
              "Shift+Left" = "move left 100 px";
              "Shift+Down" = "move down 100 px";
              "Shift+Up" = "move up 100 px";
              "Shift+Right" = "move right 100 px";
            };

            ${shutdownMode} = makeModeBindings {
              "l" = "exec --no-startup-id loginctl lock-session, mode default";
              "s" = "exec --no-startup-id systemctl suspend, mode default";
              "u" = "exec --no-startup-id dm-tool switch-to-greeter, mode default";
              "e" = "exec --no-startup-id i3-msg exit, mode default";
              "h" = "exec --no-startup-id systemctl hibernate, mode default";
              "r" = "exec --no-startup-id systemctl reboot, mode default";
              "Shift+s" = "exec --no-startup-id systemctl poweroff, mode default";
            };
          };

        startup = [
          # FIXME
          # { commdand; always; notification; }
          {
            command = "flameshot";
          }
        ];
      };
    };
  };
}
