_final: prev: {
  gamemode = prev.gamemode.overrideAttrs (
    _finalAttrs: _prevAttrs: {
      version = "2025-09-04";
      src = prev.fetchFromGitHub {
        owner = "FeralInteractive";
        repo = "gamemode";
        rev = "f0a569a5199974751a4a75ebdc41c8f0b8e4c909";
        hash = "sha256-9DB8iWiyrM4EJ94ERC5SE9acrhqeI00BF1wU0umeNFg=";
      };
    }
  );
  caddy-hetzner = prev.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/hetzner/v2@v2.0.0-preview-3" ];
    hash = "sha256-qLsfK9zaZMGVtpHHmsAkK3dgXR+4NKKz2vk9h+1G/64=";
  };

  bolt = prev.bolt.overrideAttrs (
    finalAttrs: _prevAttrs: {
      version = "0.9.11";
      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "bolt";
        repo = "bolt";
        tag = finalAttrs.version;
        hash = "sha256-nm6Qme6alKVm4En3XqG08Bugu2/NjiP/F7z7iuzDGzA=";
      };
    }
  );
}
