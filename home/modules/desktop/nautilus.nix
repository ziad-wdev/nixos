{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    nautilus-python
  ];

  home.sessionVariables = {
    NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
  };

  xdg.dataFile."nautilus-python/extensions/ghostty.py".source =
    "${pkgs.ghostty}/share/nautilus-python/extensions/ghostty.py";

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      show-hidden-files = true;
      default-folder-viewer = "icon-view";
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
    };

    "org/gtk/settings/file-chooser" = {
      sort-column = "name";
      sort-order = "ascending";
      sort-directories-first = true;
    };

    "org/gnome/nautilus/icon-view" = {
      captions = [ "size" "none" "none" ];
    };
  };

  # 2. Left Panel Sidebar Shortcuts (GTK Bookmarks)
  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file://${config.home.homeDirectory}/Documents Documents
    file://${config.home.homeDirectory}/Pictures Pictures
    file://${config.home.homeDirectory}/Music Music
    file://${config.home.homeDirectory}/Videos Videos
    file://${config.home.homeDirectory}/Downloads Downloads
  '';
}
