{ inputs, pkgs, ... }:

{
  imports = [ inputs.qylock.nixosModules.default ];

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
      };
    };
  };

  environment.systemPackages = [ pkgs.bibata-cursors ];

  programs.qylock = {
      enable = true;
      theme = "pixel-hollowknight";
      sddmTheme = "pixel-hollowknight";
  };
}
