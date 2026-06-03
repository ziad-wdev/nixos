{ inputs, pkgs, ... }:

let
  qylock-theme = pkgs.stdenv.mkDerivation {
    pname = "qylock-theme";
    version = "main";

    src = pkgs.fetchFromGitHub {
      owner = "Darkkal44";
      repo = "qylock";
      rev = "main";
      hash = "";
    };

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r sddm/* $out/share/sddm/themes/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    bibata-cursors
    qylock-theme

    # Qt6 Dependencies
    kdePackages.qtsvg
    kdePackages.qt5compat
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia

    # GStreamer Plugins
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  services.displayManager.sddm = let
    themes = {
      "Genshin Impact" = "Genshin";
      "Reverse: 1999 - I" = "R1999_1";
      "Reverse: 1999 - II" = "R1999_2";
      "Clockwork" = "clockwork";
      "Dog Samurai" = "dog-samurai";
      "Enfield" = "enfield";
      "Field" = "field";
      "Forest" = "forest";
      "Girl · Coffee" = "girl-coffee";
      "Girl · Pillow" = "girl-pillow";
      "The Last of Us" = "last-of-us";
      "Man · Bicycle" = "man-bicycle";
      "Material You" = "material-you";
      "Minecraft" = "minecraft";
      "NieR: Automata" = "nier-automata";
      "Ninja Gaiden" = "ninja_gaiden";
      "Nothing" = "nothing";
      "osu!" = "osu";
      "osu! mania" = "osumania";
      "Pixel · Coffee" = "pixel-coffee";
      "Pixel · Cyberpunk" = "pixel-cyberpunk";
      "Pixel · Dusk City" = "pixel-dusk-city";
      "Pixel · Emerald" = "pixel-emerald";
      "Pixel · Hollow Knight" = "pixel-hollowknight";
      "Pixel · Munchlax" = "pixel-munchlax";
      "Pixel · Night City" = "pixel-night-city";
      "Pixel · Rainy Room" = "pixel-rainyroom";
      "Pixel · Sakura" = "pixel-sakura";
      "Pixel · Skyscrapers" = "pixel-skyscrapers";
      "Pixel · Waterfall" = "pixel-waterfall";
      "Honkai: Star Rail" = "star-rail";
      "Sword" = "sword";
      "Terraria" = "terraria";
      "Windows 7" = "windows_7";
      "Winter" = "winter";
      "Women · Umbrella" = "women-umbrella";
      "Wuthering Waves" = "wuwa";
    };
    theme = themes."Dog Samurai";
  in {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    settings = {
      Theme = {
        Name = theme;
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
      };
    };
  };
}
