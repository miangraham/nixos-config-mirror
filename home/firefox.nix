{ unstable, ... }:
{
  enable = true;
  package = unstable.firefox-wayland;
  profiles = {
    ian = {
      id = 0;
      userChrome = builtins.readFile ./userChrome.css;
      settings = {
        # Important
        "app.update.auto" = false;
        "browser.contentblocking.category" = "standard";
        "browser.startup.homepage" = "about:blank";
        "signon.rememberSignons" = false;

        # Allow userChrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Adjust UI
        "browser.compactmode.show" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.uidensity" = 1;

        # Search, URL bar
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.hiddenOneOffs" = "Amazon.com,Bing,eBay,Wikipedia (en)";
        "browser.search.region" = "US";
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
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
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Sync defaults
        "services.sync.engine.addresses" = false;
        "services.sync.engine.creditcards" = false;
        "services.sync.engine.history" = false;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.tabs" = false;

        # Remove noise
        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.topsites.contile.enabled" = false;
        "browser.uitour.enabled" = false;
        "browser.warnOnQuit" = false;
        "browser.warnOnQuitShortcut" = false;
        "devtools.everOpened" = true;
        "extensions.pocket.enabled" = false;
      };
    };
  };
}
