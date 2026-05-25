{ config, pkgs, ... }:

{
  xdg.configFile."obs-studio/themes/custom.obt".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/matugen/output/obs.obt";

  xdg.configFile."obs-studio/global.ini".text = ''
    [General]
    Theme=custom
  '';

  programs.obs-studio = {
    enable = true;

    package = pkgs.obs-studio.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obs \
          --unset QT_STYLE_OVERRIDE \
          --unset QT_QPA_PLATFORMTHEME
      '';
    });

    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture
    ];
  };
}
