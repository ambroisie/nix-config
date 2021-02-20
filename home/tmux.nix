{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    clock24 = true; # I'm one of those heathens
    escapeTime = 0; # Let vim do its thing instead
    historyLimit = 5000; # Bigger buffer

    plugins = with pkgs.tmuxPlugins; [
      # Open high-lighted files in copy mode
      open
      # Better pane management
      pain-control
      # Better session management
      sessionist
      # X clipboard integration
      yank
      {
        # Show when prefix has been pressed
        plugin = prefix-highlight;
        extraConfig = ''
          # Also show when I'm in copy or sync mode
          set -g @prefix_highlight_show_copy_mode 'on'
          set -g @prefix_highlight_show_sync_mode 'on'
          # Show prefix mode in status bar
          set -g status-right '#{prefix_highlight} %a %Y-%m-%d %H:%M'
        '';
      }
    ];
  };
}
