{ ... }:
let
  unstable = import ../common/unstable.nix {};
in
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
        "browser.urlbar.suggest.topsites" = false;

        # Tab behavior
        "browser.tabs.showAudioPlayingIcon" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.warnOnOpen" = false;
      };

      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}
