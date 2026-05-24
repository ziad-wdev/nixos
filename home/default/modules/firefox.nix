{ inputs, config, pkgs, ... }:

let
  firefoxGnomeTheme = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v149";
    hash = "sha256-9Q2NWp7rluN5BpAM6aQJ4LQWwzsJ+jDn2rhGc5MUzV8=";
  };
in
{
  home.file.".mozilla/native-messaging-hosts".enable = false;

  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        search = {
          default = "ddg";
          force = true;
        };

        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          stylus
          bitwarden
          clearurls
          sponsorblock
          ublock-origin
          search-by-image
          auto-tab-discard
        ];

        policies = {
          Preferences = {
            "browser.download.manager.retention" = {
              Value = 0;
              Status = "locked";
            };
          };
        };

        settings = {
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
          "signon.rememberSignons" = false; # Disable built-in password manager (use Bitwarden/1Pass instead)
        };

        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
          @import "file://${config.xdg.configHome}/matugen/output/firefox.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
          @import "file://${config.xdg.configHome}/matugen/output/firefox.css";
        '';
      };
    };
  };

  home.file."${config.xdg.configHome}/mozilla/firefox/default/chrome/firefox-gnome-theme".source = firefoxGnomeTheme;
}
