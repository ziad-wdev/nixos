{ username, stateVersion, config, lib, ... }:

let
  loadModules = import ../lib/loadModules.nix;
  modulePaths = loadModules ./modules [ "shell" "desktop" "apps" ];
in
{
  imports = modulePaths;

  home = {
    homeDirectory = "/home/${username}";
    stateVersion = stateVersion;
    username = "${username}";
  };

  programs.home-manager.enable = true;

  # OBS Studio theme & output configuration (only if OBS is installed as a Flatpak)
  home.file = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/.var/app/com.obsproject.Studio") {
    ".var/app/com.obsproject.Studio/config/obs-studio" = {
      "themes/custom.obt".source =
        config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/matugen/output/obs.obt";
      "global.ini".text = ''
        [General]
        Theme=custom

        [AdvOut]
        RecRecordingPath=${config.home.homeDirectory}/Videos/obs
      '';
    };
  };
}
