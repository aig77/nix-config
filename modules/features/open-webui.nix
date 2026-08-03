_: {
  flake.modules.nixos.open-webui = {config, ...}: {
    var.services.open-webui = {
      subdomain = "chat";
      port = config.ports.open-webui;
      public = false;
      auth = false;
      backup.paths = ["/var/lib/open-webui"];
    };

    sops = {
      secrets = {
        "open-webui/openrouter-api-key" = {};
        "open-webui/secret-key" = {}; # maintain account persistence across restarts
      };

      templates."open-webui.env" = {
        mode = "0444";
        content = ''
          OPENAI_API_KEY=${config.sops.placeholder."open-webui/openrouter-api-key"}
          WEBUI_SECRET_KEY=${config.sops.placeholder."open-webui/secret-key"}
          OPENAI_API_BASE_URL=https://openrouter.ai/api/v1
          ENABLE_OLLAMA_API=false
          ENABLE_SIGNUP=false
          ANONYMIZED_TELEMETRY=false
          SCARF_NO_ANALYTICS=true
          ENABLE_COMMUNITY_SHARING=false
        '';
      };
    };

    services.open-webui = {
      enable = true;
      port = config.ports.open-webui;
      environmentFile = config.sops.templates."open-webui.env".path;
    };
  };
}
