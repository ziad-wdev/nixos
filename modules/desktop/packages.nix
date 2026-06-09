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
      "com.github.tchx84.Flatseal" # Flatseal
      "com.rtosta.zapzap" # WhatsApp
      "org.telegram.desktop" # Telegram
      "com.obsproject.Studio" # OBS Studio
      "org.localsend.localsend_app" # Local file sharing
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: { doCheck = false; });
    })
  ];

  environment.systemPackages = with pkgs; [
    lutris # Game launcher

    gnome-disk-utility # Disk utility
    resources # Resource management
    baobab # Disk usage analyzer
    showtime # video player
    loupe # Image viewer

    # System utilities
    python3
    python3Packages.pip
    nodejs_24
    gh
    git
    curl
    _7zz-rar
    ouch # Archive extraction and compression utility
    imagemagick # Image processing
    wl-clipboard # Wayland clipboard utility
    brightnessctl # Brightness control
  ];

  # Enable Docker for containerization and NVIDIA container toolkit.
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  # Configure zsh shell.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable GVFS for file system access. (for nautilus)
  services.gvfs.enable = true;

  # Library for rendering SVG icons
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  # Enable Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Compatibility layer for unpatched dynamic binaries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libsecret
      glib
    ];
  };
}
