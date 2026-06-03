{ inputs, pkgs, ... }:

let
  qylock-theme = pkgs.stdenv.mkDerivation {
    pname = "qylock-theme";
    version = "main";

    src = pkgs.fetchFromGitHub {
      owner = "Darkkal44";
      repo = "qylock";
      rev = "main";
      hash = "sha256-JnE2Jg991S7EpzlWHGGZVTZmzk3P3Ge/UL1RTppvjLo=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r themes/* $out/share/sddm/themes/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    bibata-cursors
    qylock-theme
  ];

  services.displayManager.sddm = let
    themes = [
      "clockwork"          # 0
      "dog-samurai"        # 1
      "elarun"             # 2
      "enfield"            # 3
      "field"              # 4
      "forest"             # 5
      "Genshin"            # 6
      "girl-coffee"        # 7
      "girl-pillow"        # 8
      "last-of-us"         # 9
      "maldives"           # 10
      "man-bicycle"        # 11
      "material-you"       # 12
      "maya"               # 13
      "minecraft"          # 14
      "nier-automata"      # 15
      "ninja_gaiden"       # 16
      "nothing"            # 17
      "osu"                # 18
      "osumania"           # 19
      "pixel-coffee"       # 20
      "pixel-cyberpunk"    # 21
      "pixel-dusk-city"    # 22
      "pixel-emerald"      # 23
      "pixel-hollowknight" # 24
      "pixel-night-city"   # 25
      "pixel-rainyroom"    # 26
      "pixel-sakura"       # 27
      "pixel-skyscrapers"  # 28
      "pixel-waterfall"    # 29
      "R1999_1"            # 30
      "R1999_2"            # 31
      "star-rail"          # 32
      "sword"              # 33
      "terraria"           # 34
      "windows_7"          # 35
      "winter"             # 36
      "women-umbrella"     # 37
      "wuwa"               # 38
    ];
    theme = builtins.elemAt themes 1;
  in {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };

    theme = theme;

    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
      };
    };

    extraPackages = with pkgs; [
      # Qt6 Dependencies
      kdePackages.qtsvg
      kdePackages.qt5compat
      kdePackages.qtmultimedia
      kdePackages.qtdeclarative

      # GStreamer Plugins
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
    ];
  };
}
