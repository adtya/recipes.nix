{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host = config.xyz.adtya.recipes.hostinfo.tailscale-ip;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "128000";
    };
  };

  systemd.services.ollama = lib.mkIf config.services.ollama.enable {
    after = [
      "tailscaled.service"
      "tailscaled-autoconnect.service"
    ];
    unitConfig.Requires = [
      "tailscaled.service"
      "tailscaled-autoconnect.service"
    ];
    wantedBy = lib.mkForce [ ];
  };
}
