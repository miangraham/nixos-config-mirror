{ unstable, ... }:
{
  enable = true;
  package = unstable.firefox-wayland;
  profiles = {
    ian = {
      id = 0;
      settings = {
        "app.update.auto" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "signon.rememberSignons" = false;
        "extensions.pocket.enabled" = false;
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
        "browser.urlbar.suggest.topsites" = false;

        # Tab behavior
        "browser.tabs.showAudioPlayingIcon" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.warnOnOpen" = false;
        "browser.warnOnQuit" = false;

        # Sync defaults
        "services.sync.engine.addresses" = false;
        "services.sync.engine.creditcards" = false;
        "services.sync.engine.history" = false;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.tabs" = false;
      };

      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}
