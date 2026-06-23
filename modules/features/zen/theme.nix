_: {
  flake.modules.homeManager.zen = {
    config,
    lib,
    ...
  }: let
    c = config.lib.stylix.colors.withHashtag;

    # Accent/highlight color for the browser chrome.
    # Mirrors catppuccin's per-variant accent. Options:
    #   base0D = blue (default, catppuccin "Blue")
    #   base0E = mauve/purple
    #   base0B = green
    #   base08 = red
    #   base09 = orange/peach
    #   base0A = yellow
    #   base0C = teal/sky
    highlight = c.base0D;

    # Set to null to leave the new tab logo untouched.
    # When set to true, injects a Stylix-themed Zen logo on the new tab page.
    icon = true;

    # Domains excluded from the Stylus global dark theme (regexp fragments, escape dots).
    # Example: [ "github\\.com" "reddit\\.com" ]
    styluxExclude = [
      "monkeytype\\.com"
      "cloudflare\\.com"
      "youtube\\.com"
      ".*\\.gov"
    ];
    styluxExcludeRegexp = lib.concatStringsSep "|" styluxExclude;
  in {
    # Themed after https://github.com/catppuccin/zen-browser using Stylix base16 colors.
    # base00 covers Base/Mantle/Crust since base16 has no sub-base shades.
    programs.zen-browser.profiles.default = {
      userChrome = ''
        @media (prefers-color-scheme: dark) {
          :root {
            --zen-colors-primary: ${c.base01} !important;
            --zen-primary-color: ${highlight} !important;
            --zen-colors-secondary: ${c.base01} !important;
            --zen-colors-tertiary: ${c.base00} !important;
            --zen-colors-border: ${highlight} !important;
            --toolbarbutton-icon-fill: ${highlight} !important;
            --lwt-text-color: ${c.base05} !important;
            --toolbar-field-color: ${c.base05} !important;
            --tab-selected-textcolor: ${highlight} !important;
            --toolbar-field-focus-color: ${c.base05} !important;
            --toolbar-color: ${c.base05} !important;
            --newtab-text-primary-color: ${c.base05} !important;
            --arrowpanel-color: ${c.base05} !important;
            --arrowpanel-background: ${c.base00} !important;
            --sidebar-text-color: ${c.base05} !important;
            --lwt-sidebar-text-color: ${c.base05} !important;
            --lwt-sidebar-background-color: ${c.base00} !important;
            --toolbar-bgcolor: ${c.base01} !important;
            --newtab-background-color: ${c.base00} !important;
            --zen-themed-toolbar-bg: ${c.base00} !important;
            --zen-main-browser-background: ${c.base00} !important;
            --toolbox-bgcolor-inactive: ${c.base00} !important;
          }

          #permissions-granted-icon {
            color: ${c.base00} !important;
          }

          .sidebar-placesTree {
            background-color: ${c.base00} !important;
          }

          #zen-workspaces-button {
            background-color: ${c.base00} !important;
          }

          #TabsToolbar {
            background-color: ${c.base00} !important;
          }

          .urlbar-background {
            background-color: ${c.base00} !important;
          }

          .content-shortcuts {
            background-color: ${c.base00} !important;
            border-color: ${highlight} !important;
          }

          .urlbarView-url {
            color: ${highlight} !important;
          }

          #zenEditBookmarkPanelFaviconContainer {
            background: ${c.base00} !important;
          }

          #zen-media-controls-toolbar {
            & #zen-media-progress-bar {
              &::-moz-range-track {
                background: ${c.base01} !important;
              }
            }
          }

          toolbar .toolbarbutton-1 {
            &:not([disabled]) {
              &:is([open], [checked])
                > :is(
                  .toolbarbutton-icon,
                  .toolbarbutton-text,
                  .toolbarbutton-badge-stack
                ) {
                fill: ${c.base00};
              }
            }
          }

          .identity-color-blue {
            --identity-tab-color: ${c.base0D} !important;
            --identity-icon-color: ${c.base0D} !important;
          }

          .identity-color-turquoise {
            --identity-tab-color: ${c.base0C} !important;
            --identity-icon-color: ${c.base0C} !important;
          }

          .identity-color-green {
            --identity-tab-color: ${c.base0B} !important;
            --identity-icon-color: ${c.base0B} !important;
          }

          .identity-color-yellow {
            --identity-tab-color: ${c.base0A} !important;
            --identity-icon-color: ${c.base0A} !important;
          }

          .identity-color-orange {
            --identity-tab-color: ${c.base09} !important;
            --identity-icon-color: ${c.base09} !important;
          }

          .identity-color-red {
            --identity-tab-color: ${c.base08} !important;
            --identity-icon-color: ${c.base08} !important;
          }

          .identity-color-pink {
            --identity-tab-color: ${c.base0F} !important;
            --identity-icon-color: ${c.base0F} !important;
          }

          .identity-color-purple {
            --identity-tab-color: ${c.base0E} !important;
            --identity-icon-color: ${c.base0E} !important;
          }

          hbox#titlebar {
            background-color: ${c.base00} !important;
          }

          browser[type="content"]:not([transparent="true"]) {
            background: ${c.base00} !important;
          }

          #urlbar:not([usertyping], [searchmode]) > .urlbarView {
            display: none !important;
          }

          #urlbar-results div.urlbarView-row[row-selectable][type="top_site"] {
            display: none !important;
          }

          #zen-appcontent-navbar-container {
            background-color: ${c.base00} !important;
            border-bottom: 1px solid ${c.base02} !important;

            .toolbarbutton-icon,
            toolbarbutton > image,
            toolbarbutton > .toolbarbutton-badge-stack > .toolbarbutton-icon {
              fill: ${highlight} !important;
              color: ${highlight} !important;
            }
          }
        }
      '';

      # Stylix palette as CSS custom properties for Stylus styles to reference.
      # One-time setup: open file:///home/arturo/.local/share/bebop/stylix-global.user.css in Zen,
      # install via the Stylus popup, then enable it in the Stylus extension manager.
      # CSS uses var(--sz-*) so it stays theme-aware without reinstalling when Stylix changes.
      userContent = ''
        :root {
          --sz-base00: ${c.base00};
          --sz-base01: ${c.base01};
          --sz-base02: ${c.base02};
          --sz-base03: ${c.base03};
          --sz-base04: ${c.base04};
          --sz-base05: ${c.base05};
          --sz-base06: ${c.base06};
          --sz-base07: ${c.base07};
          --sz-base08: ${c.base08};
          --sz-base09: ${c.base09};
          --sz-base0A: ${c.base0A};
          --sz-base0B: ${c.base0B};
          --sz-base0C: ${c.base0C};
          --sz-base0D: ${c.base0D};
          --sz-base0E: ${c.base0E};
          --sz-base0F: ${c.base0F};
        }

        @media (prefers-color-scheme: dark) {
          @-moz-document url-prefix("about:") {
            :root {
              --in-content-page-color: ${c.base05} !important;
              --color-accent-primary: ${highlight} !important;
              --color-accent-primary-hover: ${highlight} !important;
              --color-accent-primary-active: ${highlight} !important;
              background-color: ${c.base00} !important;
              --in-content-page-background: ${c.base00} !important;
            }
          }

          @-moz-document url("about:newtab"), url("about:home") {
            :root {
              --newtab-background-color: ${c.base00} !important;
              --newtab-background-color-secondary: ${c.base01} !important;
              --newtab-element-hover-color: ${c.base01} !important;
              --newtab-text-primary-color: ${c.base05} !important;
              --newtab-wordmark-color: ${c.base05} !important;
              --newtab-primary-action-background: ${highlight} !important;
            }

            .icon {
              color: ${highlight} !important;
            }

            ${lib.optionalString (icon != null) ''
          .search-wrapper .logo-and-wordmark .logo {
            background: url("zen-logo.svg") no-repeat center !important;
            display: inline-block !important;
            height: 82px !important;
            width: 82px !important;
            background-size: 82px !important;
          }

          @media (max-width: 609px) {
            .search-wrapper .logo-and-wordmark .logo {
              background-size: 64px !important;
              height: 64px !important;
              width: 64px !important;
            }
          }
        ''}

            .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title {
              color: ${highlight} !important;
            }

            .compact-cards .card-outer .card-context .card-context-icon.icon-download {
              fill: ${c.base0B} !important;
            }
          }

          @-moz-document url-prefix("about:preferences") {
            :root {
              --zen-colors-tertiary: ${c.base00} !important;
              --in-content-text-color: ${c.base05} !important;
              --link-color: ${highlight} !important;
              --link-color-hover: ${highlight} !important;
              --zen-colors-primary: ${c.base01} !important;
              --in-content-box-background: ${c.base01} !important;
              --zen-primary-color: ${highlight} !important;
            }

            groupbox, moz-card {
              background: ${c.base00} !important;
            }

            button,
            groupbox menulist {
              background: ${c.base01} !important;
              color: ${c.base05} !important;
            }

            .main-content {
              background-color: ${c.base00} !important;
            }

            .identity-color-blue { --identity-tab-color: ${c.base0D} !important; --identity-icon-color: ${c.base0D} !important; }
            .identity-color-turquoise { --identity-tab-color: ${c.base0C} !important; --identity-icon-color: ${c.base0C} !important; }
            .identity-color-green { --identity-tab-color: ${c.base0B} !important; --identity-icon-color: ${c.base0B} !important; }
            .identity-color-yellow { --identity-tab-color: ${c.base0A} !important; --identity-icon-color: ${c.base0A} !important; }
            .identity-color-orange { --identity-tab-color: ${c.base09} !important; --identity-icon-color: ${c.base09} !important; }
            .identity-color-red { --identity-tab-color: ${c.base08} !important; --identity-icon-color: ${c.base08} !important; }
            .identity-color-pink { --identity-tab-color: ${c.base0F} !important; --identity-icon-color: ${c.base0F} !important; }
            .identity-color-purple { --identity-tab-color: ${c.base0E} !important; --identity-icon-color: ${c.base0E} !important; }
          }

          @-moz-document url-prefix("about:addons") {
            :root {
              --zen-dark-color-mix-base: ${c.base00} !important;
              --background-color-box: ${c.base00} !important;
            }
          }

          @-moz-document url-prefix("about:protections") {
            :root {
              --zen-primary-color: ${c.base00} !important;
              --social-color: ${c.base0E} !important;
              --coockie-color: ${c.base0C} !important;
              --fingerprinter-color: ${c.base0A} !important;
              --cryptominer-color: ${c.base07} !important;
              --tracker-color: ${c.base0B} !important;
              --in-content-primary-button-background-hover: ${c.base02} !important;
              --in-content-primary-button-text-color-hover: ${c.base05} !important;
              --in-content-primary-button-background: ${c.base01} !important;
              --in-content-primary-button-text-color: ${c.base05} !important;
            }

            .card {
              background-color: ${c.base01} !important;
            }
          }
        }
      '';
    };

    home.file =
      lib.optionalAttrs (icon != null) {
        ".config/zen/default/chrome/zen-logo.svg".text = ''
          <svg width="1024" height="1024" viewBox="0 0 1024 1024" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g clip-path="url(#clip0_15_9)">
              <rect width="1024" height="1024" rx="225" fill="${c.base00}"/>
              <circle cx="512" cy="512" r="340" stroke="${c.base05}" stroke-width="70"/>
              <circle cx="512" cy="512" r="224.915" stroke="${c.base05}" stroke-width="51"/>
              <circle cx="512" cy="512" r="129.018" stroke="${c.base05}" stroke-width="31"/>
            </g>
            <defs>
              <clipPath id="clip0_15_9">
                <rect width="1024" height="1024" fill="white"/>
              </clipPath>
            </defs>
          </svg>
        '';
      }
      // {
        ".local/share/bebop/stylix-global.user.css".text = ''
          /* ==UserStyle==
          @name         Stylix Global Theme
          @description  Global dark theme using Stylix palette. Requires userContent.css --sz-* variables.
          @version      1.0.0
          @namespace    bebop
          ==/UserStyle== */

          @-moz-document regexp("${
            if styluxExclude == []
            then ".*"
            else "^(?!https?://([^/]*(${styluxExcludeRegexp}))).*"
          }") {
            :root, body {
              background-color: var(--sz-base00) !important;
              color: var(--sz-base05) !important;
              border-color: var(--sz-base02) !important;
            }

            a:not(:visited) { color: var(--sz-base0D) !important; }
            a:visited { color: var(--sz-base0E) !important; }

            input, textarea, select {
              background-color: var(--sz-base01) !important;
              color: var(--sz-base05) !important;
              border-color: var(--sz-base03) !important;
            }

            button {
              background-color: var(--sz-base02) !important;
              color: var(--sz-base05) !important;
            }

            /* Normalize card/container borders that become prominent after background override */
            [class*="card"], [class*="Card"],
            [class*="box"], [class*="Box"],
            [class*="container"], [class*="Container"],
            article, section, aside {
              border-color: var(--sz-base02) !important;
              outline-color: var(--sz-base02) !important;
            }
          }
        '';
      };
  };
}
