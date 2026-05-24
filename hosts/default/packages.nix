{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  # Enable Flatpak for system-wide package management
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
    packages = [
      "com.github.tchx84.Flatseal"
      "org.polymc.PolyMC"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # System utilities
    gh
    git
    curl
    unzip
    unrar
    protonup-ng # Proton Updater for steam

    resources # Resource management
    # Image utilities
    loupe # Image viewer
    imagemagick # Image processing
    # Wayland clipboard utility
    wl-clipboard
    # Brightness control
    brightnessctl
  ];

  # Configure zsh shell.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable AppImage support
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Enable Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;

  # Enable GVFS for file system access. (for nautilus)
  services.gvfs.enable = true;

  # Library for rendering SVG icons
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
}
