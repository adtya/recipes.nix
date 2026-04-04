_final: prev: {
  caddy-hetzner = prev.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/hetzner/v2@v2.0.0-preview-3" ];
    hash = "sha256-qLsfK9zaZMGVtpHHmsAkK3dgXR+4NKKz2vk9h+1G/64=";
  };
}
