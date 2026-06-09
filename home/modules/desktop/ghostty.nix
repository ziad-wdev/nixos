{ config, ... }:

{
  xdg.configFile."ghostty/themes/custom".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/matugen/output/ghostty";

  programs.ghostty = {
    enable = true;

    settings = {
      theme = "custom";

      # Window Configuration
      window-decoration = false;
      window-padding-x = 12;
      window-padding-y = 12;

      # Cursor Configuration
      cursor-style = "block";
      cursor-style-blink = true;

      # Scrollback
      scrollback-limit = 4096;

      # Terminal features
      mouse-hide-while-typing = true;
      confirm-close-surface = false;
      copy-on-select = false;

      # Disable annoying copied to clipboard
      app-notifications = "no-clipboard-copy,no-config-reload";

      # Key bindings for common actions
      keybind = [
        "ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
        "shift+enter=text:\\n"
        "ctrl+z=text:\\x03"
      ];

      # Tab configuration
      gtk-titlebar = false;

      # Shell integration
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title,no-cursor";

      # Rando stuff
      gtk-single-instance = true;
    };
  };
}
