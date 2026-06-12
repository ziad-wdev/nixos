{ inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;

    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    packages = [
      "com.github.tchx84.Flatseal" # Flatseal
      "com.rtosta.zapzap" # WhatsApp
      "org.telegram.desktop" # Telegram
      "com.obsproject.Studio" # OBS Studio
      "org.localsend.localsend_app" # Local file sharing
    ];
  };
}
