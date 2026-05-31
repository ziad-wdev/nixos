{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.default ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      SanitizeOnShutdown = {
        Cache = true;
        Downloads = true;
        FormData = true;
        OfflineApps = true;
        Cookies = false;
        History = false;
        Sessions = false;
        SiteSettings = false;
      };

      Preferences = {
        "browser.startup.homepage" = {
          Value = "about:blank";
          Status = "locked";
        };
        "zen.workspaces.continue-where-left-off" = false;
        "zen.urlbar.behavior" = "floating-on-type";
        "zen.welcome-screen.seen" = true;
        "zen.view.layout" = 2;
        "zen.view.compact.hide-tabbar" = true;
      };
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      mods = [
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
        "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
        "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better CtrlTab Panel
        "664c54f9-d97d-410b-a479-23dd8a08a628" # Better Tab Indicators
        "c5f7fb68-cc75-4df0-8b02-dc9ee13aa773" # Audio TabIcon Plus
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
        "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
        "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
        "a5f6a231-e3c8-4ce8-8a8e-3e93efd6adec" # Cleaned URL bar
        "642854b5-88b4-4c40-b256-e035532109df" # Transparent Zen
      ];

      settings = {
        # Custom CSS & Theme
        "browser.toolbars.bookmarks.visibility" = "always";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.theme.dark-private-windows" = false;
        "browser.uidensity" = 0;

        # Telemetry & Bloatware removal
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.unified" = false;
        "extensions.pocket.enabled" = false;
        "privacy.donate.urls" = "";

        # Privacy & Fingerprinting (FPP enabled, RFP disabled for Dark Mode websites)
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.resistFingerprinting" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";

        # Security & HTTPS
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # DNS over HTTPS (DoH) & Strict Cookies
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
        "network.cookie.cookieBehavior" = 5;

        # WebRTC Leak Prevention
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = true;
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

        # Disable Search Suggestions & Trending
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.trending.featureGate" = false;

        # UI & QoL
        "browser.shell.checkDefaultBrowser" = false;
        "signon.rememberSignons" = false;
      };
    };
  };
}
