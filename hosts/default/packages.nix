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
    protonup-ng # Proton Updater for steam
    lutris # Game launcher

    gnome-disk-utility # Disk utility
    resources # Resource management
    baobab # Disk usage analyzer
    showtime # video player
    loupe # Image viewer

    # System utilities
    nodejs
    gh
    git
    curl
    ouch # Archive extraction and compression utility
    imagemagick # Image processing
    wl-clipboard # Wayland clipboard utility
    brightnessctl # Brightness control
  ];

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
    package = pkgs.steam.override {
      extraEnv = {
        # Force Gamescope to use Wayland and proper rendering backends
        "SDL_VIDEODRIVER" = "wayland";
        "QT_QPA_PLATFORM" = "wayland";

        # Crucial for NVIDIA/Gamescope stability
        "WLR_DRM_NO_ATOMIC" = "1";
        "WLR_RENDERER" = "vulkan";

        # Ensure it tries to use the NVIDIA GPU specifically
        "__NV_PRIME_RENDER_OFFLOAD" = "1";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      };
    };
    gamescopeSession.enable = true;
    gamescopeSession.args = [
      "--rt"              # Use real-time scheduling to prevent lag
      "--expose-wayland"  # Better compatibility with modern games
      "--immediate-flips" # Helps reduce latency (test without this if you see tearing)
    ];
  };
  programs.gamemode.enable = true;
}
