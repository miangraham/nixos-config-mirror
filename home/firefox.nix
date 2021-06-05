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
        "browser.search.hiddenOneOffs" = "Amazon.com,Bing,eBay,Wikipedia (en)";
        "browser.search.region" = "US";
        "browser.urlbar.suggest.topsites" = false;

        # Tab behavior
        "browser.tabs.warnOnClose" = false;
        "browser.tabs.warnOnOpen" = false;
      };

      userChrome = ''
/* Adjust tab corner shape, optionally remove space below tabs */

@media (-moz-proton) {
    .tab-background {
        border-radius: var(--user-tab-rounding) var(--user-tab-rounding) 0px 0px !important;
        margin-block: 1px 0 !important;
    }
}

/* Inactive tabs: Separator line style */

@media (-moz-proton) {
    .tab-background:not([selected=true]):not([multiselected=true]):not([beforeselected-visible="true"]) {
        border-right: 1px solid rgba(0, 0, 0, .20) !important;
    }
    /* For dark backgrounds */
    [brighttext="true"] .tab-background:not([selected=true]):not([multiselected=true]):not([beforeselected-visible="true"]) {
        border-right: 1px solid var(--lwt-selected-tab-background-color, rgba(255, 255, 255, .20)) !important;
    }
    .tab-background:not([selected=true]):not([multiselected=true]) {
        border-radius: 0 !important;
    }
    /* Remove padding between tabs */
    .tabbrowser-tab {
        padding-left: 0 !important;
        padding-right: 0 !important;
    }
}

@media (-moz-proton) {
    /* Close buttons */
    .tabbrowser-tab .tab-close-button {
      display:none !important;
    }

    /* MUTED */
    .tab-icon-sound-muted-label {
      display:none !important;
    }
}

#pageActionButton {
  display:none !important;
}
#context-navigation, #context-sep-navigation, #context-sendpagetodevice, #context-sep-sendpagetodevice,
#context-sendlinktodevice, #context-sep-sendlinktodevice {
  display: none !important;
}
      '';
    };
  };
}
