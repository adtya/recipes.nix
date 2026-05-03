_final: prev: {
  caddy-hetzner = prev.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/hetzner/v2@v2.0.0-preview-3" ];
    hash = "sha256-b2lDSYMUT+3jA0xaQGkcgeAbRFbDnVwa2za5lOuWuIc=";
  };

  # https://github.com/NixOS/nixpkgs/issues/514113
  openldap = prev.openldap.overrideAttrs (_: {
    doCheck = !prev.stdenv.hostPlatform.isi686;
  });
}
