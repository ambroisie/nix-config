{ config, lib, pkgs, ... }:
let
  cfg = config.my.home.tmux;
  hasGUI = lib.any lib.id [
    config.my.home.x.enable
    (config.my.home.wm.windowManager != null)
  ];

  mkTerminalFlag = tmuxVar: opt: flag:
    let
      mkFlag = term: ''set -as ${tmuxVar} ",${term}:${flag}"'';
      enabledTerminals = lib.filterAttrs (_: v: v.${opt}) cfg.terminalFeatures;
      terminals = lib.attrNames enabledTerminals;
    in
    lib.concatMapStringsSep "\n" mkFlag terminals;

  mkTerminalFeature = mkTerminalFlag "terminal-features";
  mkTerminalOverride = mkTerminalFlag "terminal-overrides";
in
{
  options.my.home.tmux = with lib; {
    enable = my.mkDisableOption "tmux terminal multiplexer";

    enablePassthrough = mkEnableOption "tmux DCS passthrough sequence";

    enableResurrect = mkEnableOption "tmux-resurrect plugin";

    terminalFeatures = mkOption {
      type = with types; attrsOf (submodule {
        options = {
          hyperlinks = my.mkDisableOption "hyperlinks through OSC8";

          trueColor = my.mkDisableOption "24-bit (RGB) color support";

          underscoreStyle = my.mkDisableOption "underscore style/color support";
        };
      });

      default = { ${config.my.home.terminal.default} = { }; };
      defaultText = literalExpression ''
        { ''${config.my.home.terminal.default} = { }; };
      '';
      example = { xterm-256color = { }; };
      description = ''
        $TERM values which should be considered to have additional features.
      '';
    };
  };

  config.programs.tmux = lib.mkIf cfg.enable {
    enable = true;

    keyMode = "vi"; # Home-row keys and other niceties
    clock24 = true; # I'm one of those heathens
    escapeTime = 0; # Let vim do its thing instead
    historyLimit = 1000000; # Bigger buffer
    mouse = false; # I dislike mouse support
    focusEvents = true; # Report focus events
    terminal = "tmux-256color"; # I want accurate termcap info
    aggressiveResize = true; # Automatic resize when switching client size

    # FIXME
    # * Sixel support
    # * OSC 133 prompt integration
    # FIXME: when sensible-on-top is disabled: check if any of those are unset
    # * tmux bind-key $prefix_without_ctrl last-window
    # *
    # * tmux bind-key C-b send-prefix: included
    # * aggressive resize? done
    # * tmux bind-key C-p previous-window: done
    # * tmux bind-key C-n next-window: done
    # * C-r to refresh my config: done
    # * tmux set-option -g focus-events on: done

    # FIXME: make PRs for `bind-key` description
    plugins = with pkgs.tmuxPlugins; builtins.filter (attr: attr != { }) [
      # Open high-lighted files in copy mode
      open
      # Better pane management
      pain-control
      # Better session management
      sessionist
      # X clipboard integration
      {
        plugin = yank;
        extraConfig = ''
          # Use 'clipboard' because of misbehaving apps (e.g: firefox)
          set -g @yank_selection_mouse 'clipboard'
          # Stay in copy mode after yanking
          set -g @yank_action 'copy-pipe'
        '';
      }
      # Show when prefix has been pressed
      {
        plugin = prefix-highlight;
        extraConfig = ''
          # Also show when I'm in copy or sync mode
          set -g @prefix_highlight_show_copy_mode 'on'
          set -g @prefix_highlight_show_sync_mode 'on'
          # Show prefix mode in status bar
          set -g status-right '#{prefix_highlight} %a %Y-%m-%d %H:%M'
        '';
      }
      # Resurrect sessions
      (lib.optionalAttrs cfg.enableResurrect {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-dir '${config.xdg.stateHome}/tmux/resurrect'
        '';
      })
    ];

    extraConfig = ''
      # Refresh configuration
      bind-key -N "Source tmux.conf" R source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Sourced tmux.conf!"

      # Accept sloppy Ctrl key when switching windows, on top of default mapping
      bind-key -N "Select the previous window" C-p previous-window
      bind-key -N "Select the next window" C-n next-window

      # Better vim mode
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      ${
        lib.optionalString
          (!hasGUI)
          "bind-key -T copy-mode-vi 'y' send -X copy-selection"
      }
      # Block selection in vim mode
      bind-key -Tcopy-mode-vi 'C-v' send -X begin-selection \; send -X rectangle-toggle

      # Allow any application to send OSC52 escapes to set the clipboard
      set -s set-clipboard on

      # Longer session names in status bar
      set -g status-left-length 16

      ${
        lib.optionalString cfg.enablePassthrough ''
          # Allow any application to use the tmux DCS for passthrough
          set -g allow-passthrough on
        ''
      }

      # Force OSC8 hyperlinks for each relevant $TERM
      ${mkTerminalFeature "hyperlinks" "hyperlinks"}
      # Force 24-bit color for each relevant $TERM
      ${mkTerminalFeature "trueColor" "RGB"}
      # Force underscore style/color for each relevant $TERM
      ${mkTerminalFeature "underscoreStyle" "usstyle"}
      # FIXME: see https://github.com/folke/tokyonight.nvim#fix-undercurls-in-tmux for additional overrides
      # ${mkTerminalOverride "underscoreStyle" "Smulx=\\E[4::%p1%dm"}
      # ${mkTerminalOverride "underscoreStyle" "Setulc=\\E[58::2::::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m"}
    '';
  };
}
