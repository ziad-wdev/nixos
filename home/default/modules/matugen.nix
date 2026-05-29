{ config, pkgs, ... }:

{
  home.packages = [ pkgs.matugen ];

  xdg.configFile."matugen/output/.keep".text = "";

  xdg.configFile."matugen/config.toml".text =
  let
    toPathStr = path: toString path;
  in ''
    [config]

    [config.wallpaper]
    command = "awww img --transition-type random --transition-fps 60 \"{{image}}\""

    [config.custom_colors]
    red     = { color = "#ff6467", blend = true }
    orange  = { color = "#ff8904", blend = true }
    amber   = { color = "#ffba00", blend = true }
    yellow  = { color = "#fcc800", blend = true }
    lime    = { color = "#9ae600", blend = true }
    green   = { color = "#05df72", blend = true }
    emerald = { color = "#00d492", blend = true }
    teal    = { color = "#00d5be", blend = true }
    cyan    = { color = "#00d3f2", blend = true }
    sky     = { color = "#00bcff", blend = true }
    blue    = { color = "#51a2ff", blend = true }
    indigo  = { color = "#7c86ff", blend = true }
    violet  = { color = "#a684ff", blend = true }
    purple  = { color = "#c27aff", blend = true }
    fuchsia = { color = "#ed6aff", blend = true }
    pink    = { color = "#fb64b6", blend = true }
    rose    = { color = "#ff637e", blend = true }
    navy    = { color = "#193cb8", blend = true }

    [templates.gtk]
    input_path = "${toPathStr ./templates/gtk.css}"
    output_path = "${config.xdg.configHome}/matugen/output/gtk.css"
    post_hook = "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme none; sleep 0.05; ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'"

    [templates.hyprland]
    input_path = "${toPathStr ./templates/hyprland.lua}"
    output_path = "${config.xdg.configHome}/matugen/output/hyprland.lua"
    post_hook = "hyprctl reload &> /dev/null"

    [templates.hyprlock]
    input_path = "${toPathStr ./templates/hyprlock.conf}"
    output_path = "${config.xdg.configHome}/matugen/output/hyprlock.conf"

    [templates.wlogout]
    input_path = "${toPathStr ./templates/colors.css}"
    output_path = "${config.xdg.configHome}/matugen/output/wlogout.css"

    [templates.waybar]
    input_path = "${toPathStr ./templates/colors.css}"
    output_path = "${config.xdg.configHome}/matugen/output/waybar.css"
    post_hook = "pkill -SIGUSR2 waybar"

    [templates.rofi]
    input_path = "${toPathStr ./templates/rofi.rasi}"
    output_path = "${config.xdg.configHome}/matugen/output/rofi.rasi"

    [templates.ghostty]
    input_path = "${toPathStr ./templates/ghostty}"
    output_path = "${config.xdg.configHome}/matugen/output/ghostty"
    post_hook = "pkill -SIGUSR2 ghostty"

    [templates.zed]
    input_path = "${toPathStr ./templates/zed.json}"
    output_path = "${config.xdg.configHome}/matugen/output/zed.json"

    [templates.spicetify]
    input_path = "${toPathStr ./templates/spicetify.ini}"
    output_path = "${config.xdg.configHome}/matugen/output/spicetify.ini"
    post_hook = "spicetify apply --no-restart || true"

    [templates.vesktop]
    input_path = "${toPathStr ./templates/vesktop.css}"
    output_path = "${config.xdg.configHome}/matugen/output/vesktop.css"

    [templates.firefox]
    input_path = "${toPathStr ./templates/firefox.css}"
    output_path = "${config.xdg.configHome}/matugen/output/firefox.css"

    [templates.pywalfox]
    input_path = "${toPathStr ./templates/pywalfox.json}"
    output_path = "${config.xdg.configHome}/matugen/output/pywalfox.json"
    post_hook = "pywalfox update || true"

    [templates.pywalzen]
    input_path = "${toPathStr ./templates/pywalzen.css}"
    output_path = "${config.xdg.configHome}/matugen/output/pywalzen.css"

    [templates.steam]
    input_path = "${toPathStr ./templates/steam.css}"
    output_path = "${config.xdg.configHome}/matugen/output/steam.css"

    [templates.obs]
    input_path = "${toPathStr ./templates/obs.obt}"
    output_path = "${config.xdg.configHome}/matugen/output/obs.obt"
  '';
}
