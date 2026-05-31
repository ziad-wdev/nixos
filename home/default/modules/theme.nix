{ config, pkgs, ... }:

{
  # Setup fonts system-wide
  home.packages = with pkgs; [
    inter
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Inter" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Setup GTK and Qt cursor themes
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Setup GTK theme
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraCss = ''
      @import url("file://${config.xdg.configHome}/matugen/output/gtk.css");
    '';
    gtk4.extraCss = ''
      @import url("file://${config.xdg.configHome}/matugen/output/gtk.css");
    '';
  };

  # Force GTK4 apps to use dark mode natively
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Setup Qt theme
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };
}
