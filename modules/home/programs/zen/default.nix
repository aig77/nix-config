{
  config,
  inputs,
  ...
}: {
  imports = [inputs.zen-browser.homeModules.twilight];

  programs.zen-browser = {
    enable = true;
    profiles.${config.var.username}.isDefault = true;

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;

      DNSOverHTTPS = {
        Enabled = true;
        Value = "increased";
        ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
      };

      Preferences = {
        "browser.contentblocking.category" = {Value = "strict";};
        "dom.security.https_only_mode" = {Value = true;};
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      SearchEngines = {
        Default = "Brave";
        PreventInstalls = false;
        Remove = ["Google" "Bing" "Yahoo"];
        Add = [
          {
            Name = "Brave";
            Method = "GET";
            URLTemplate = "https://search.brave.com/search?q={searchTerms}";
          }
        ];
      };
    };
  };

  stylix.targets.zen-browser.profileNames = ["${config.var.username}"];
}
