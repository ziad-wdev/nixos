{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.default ];

  home.packages = [ pkgs.pywalfox-native ];

  xdg.cacheFile."wal/colors.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/matugen/output/pywalfox.json";

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    package = inputs.zen-browser.packages.${pkgs.system}.default.override {
      nativeMessagingHosts = [ pkgs.pywalfox-native ];
    };

    policies = {
      ExtensionSettings = {
        "pywalfox@frewacom.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      userChrome = ''
        @import "${pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/Axenide/PywalZen/main/chrome.css";
          sha256 = "sha256-7IQOzepLG80qf40imKgLHk4jaA6enm/9eiYoLSzNyzY=";
        }}";
      '';

      settings = {
        # Pywalzen (darkness mode)
        "uc-pywalzen-darkness" = "default";

        # Enable custom CSS and SVG properties for the theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.theme.dark-private-windows" = false;
        "browser.uidensity" = 0;

        # Privacy & Security
        "privacy.donate.urls" = "";
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # Telemetry & Pocket (Bloatware removal)
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.unified" = false;
        "extensions.pocket.enabled" = false;

        # UI & Quality of Life
        "browser.shell.checkDefaultBrowser" = false;
        "signon.rememberSignons" = false;
      };
    };
  };
}
