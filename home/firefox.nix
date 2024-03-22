{ pkgs, ... }:
let
  firefox = pkgs.wrapFirefox pkgs.firefox-esr-115-unwrapped {
    extraPolicies = {
      AppAutoUpdate = false;
      AppUpdatePin = "115.";
      BackgroundAppUpdate = false;
      DisableAppUpdate = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisableMasterPasswordCreation = true;
      DisablePasswordReveal = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = true;
      DontCheckDefaultBrowser = true;
      DownloadDirectory = "\$\{home\}/downloads";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      SearchSuggestEnabled = false;
      FirefoxHome = {
        Highlights = false;
        Locked = true;
        Pocket = false;
        Search = false;
        Snippets = false;
        SponsoredPocket = false;
        SponsoredTopSites = false;
        TopSites = false;
      };
      FirefoxSuggest = {
        ImproveSuggest = false;
        Locked = true;
        SponsoredSuggestions = false;
        WebSuggestions = false;
      };
      Permissions = {
        Notifications = {
          BlockNewRequests = true;
          Locked = true;
        };
        Autoplay = {
          Default = "block-audio-video";
          Block = [
            "https://youtube.com"
          ];
        };
      };
      PictureInPicture = {
        Enabled = false;
        Locked = true;
      };
      SearchEngines = {
        Remove = [
          "Bing"
          "eBay"
        ];
      };
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
    };
  };
in
{
  enable = true;
  package = firefox;
  profiles = {
    ian = {
      id = 0;
      userChrome = builtins.readFile ./userChrome.css;
      settings = {
        # Important
        "app.update.auto" = false;
        "app.update.silent" = true;
        "app.update.suppressPrompts" = true;
        "browser.contentblocking.category" = "standard";
        "browser.sessionstore.resume_from_crash" = false;
        "browser.sessionstore.resuming_after_os_restart" = false;
        "browser.startup.homepage" = "about:blank";
        "general.autoScroll" = false;
        "signon.rememberSignons" = false;

        # Allow userChrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Adjust UI
        "browser.compactmode.show" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.uidensity" = 1;
        "layout.testing.overlay-scrollbars.always-visible" = 1;
        "widget.non-native-theme.scrollbar.style" = 4;

        # Search, URL bar
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.hiddenOneOffs" = "Amazon.com,Wikipedia (en)";
        "browser.search.region" = "US";
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.sponsoredTopSites" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.quicksuggest" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.topsites" = false;

        # Tab behavior
        "browser.tabs.showAudioPlayingIcon" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.warnOnOpen" = false;

        # New tab spam overkill
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.aboutpreferences" = false;
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.favicon" = false;
        "browser.newtabpage.activity-stream.feeds.newtabinit" = false;
        "browser.newtabpage.activity-stream.feeds.places" = false;
        "browser.newtabpage.activity-stream.feeds.prefs" = false;
        "browser.newtabpage.activity-stream.feeds.recommendationprovider" = false;
        "browser.newtabpage.activity-stream.feeds.system.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Sync defaults
        "services.sync.engine.addresses" = false;
        "services.sync.engine.addresses.available" = false;
        "services.sync.engine.creditcards" = false;
        "services.sync.engine.creditcards.available" = false;
        "services.sync.engine.history" = false;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.tabs" = false;
        "services.sync.prefs.sync.general.autoScroll" = false;

        # Remove noise
        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.contentblocking.cfr-milestone.enabled" = false;
        "browser.contentblocking.report.hide_vpn_banner" = true;
        "browser.contentblocking.report.lockwise.enabled" = false;
        "browser.contentblocking.report.monitor.enabled" = false;
        "browser.contentblocking.report.proxy.enabled" = false;
        "browser.contentblocking.report.show_mobile_app" = false;
        "browser.contentblocking.report.vpn.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.preferences.experimental" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.promo.cookiebanners.enabled" = false;
        "browser.promo.focus.enabled" = false;
        "browser.promo.pin.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.topsites.contile.enabled" = false;
        "browser.uitour.enabled" = false;
        "browser.vpn_promo.enabled" = false;
        "browser.warnOnQuit" = false;
        "browser.warnOnQuitShortcut" = false;
        "cookiebanners.service.mode" = 1;
        "cookiebanners.service.mode.privateBrowsing" = 1;
        "devtools.everOpened" = true;
        "extensions.experiments.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.quarantinedDomains.enabled" = false;
        "extensions.unifiedExtensions.enabled" = false;

        # Dev
        "devtools.chrome.enabled" = true;
        "devtools.debugger.remote-enabled" = true;

        # DRM
        "media.gmp-widevinecdm.enabled" = true;

        # Misc safety
        "extensions.formautofill.available" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
      };
    };
  };
}
