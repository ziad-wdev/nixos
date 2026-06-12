{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    qt6.qt5compat
    qt6.qtwayland
  ];

  # systemd.user.services.quickshell = {
  #   Unit = {
  #     Description = "Quickshell Desktop Components";
  #     After = [ "graphical-session.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${pkgs.quickshell}/bin/quickshell";
  #     Restart = "on-failure";
  #   };
  #   Install = {
  #     WantedBy = [ "graphical-session.target" ];
  #   };
  # };

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink ../../assets/config/quickshell;
}
