{
  lib,
  pkgs,
  nixosOptionsDoc,
  stdenvNoCC,
  mdbook,
  writeShellScriptBin,
  python3Minimal,
  ...
}:
let

  # Replace file:// hyperlinks to Nix Store with github urls
  toURL =
    decl:
    let
      declStr = toString decl;
      root = toString ./.;
      subpath = lib.removePrefix "/" (lib.removePrefix root declStr);
    in
    if lib.hasPrefix root declStr then
      {
        url = "https://codeberg.org/adtya/recipes.nix/src/branch/main/${subpath}";
        name = "${subpath}";
      }
    else
      decl;

  mapURLs = opt: opt // { declarations = map toURL opt.declarations; };

  eval = lib.evalModules {
    modules = [
      (_: { _module.check = false; })
      ./modules/nixos/module.nix
    ];
    specialArgs = { inherit pkgs; };
    class = "recipesConfig";
  };

  # https://github.com/NixOS/nixpkgs/issues/293510
  cleanEval = lib.filterAttrsRecursive (n: _v: n != "_module") eval;

  optionsDoc = nixosOptionsDoc {
    inherit (cleanEval) options;
    transformOptions = mapURLs;
  };

  site = stdenvNoCC.mkDerivation {
    name = "recipe-docs";
    src = ./.;

    nativeBuildInputs = [ mdbook ];

    buildPhase = ''
      cp ${optionsDoc.optionsCommonMark} ./docs/nixos-options.md
      mdbook build
    '';

    installPhase = ''
      cp -r book $out
    '';

  };
in
{
  inherit site;
  devserver = writeShellScriptBin "app" ''
    trap 'kill "''${child_pid}"; wait "''${child_pid}";' SIGINT SIGTERM
    ${lib.getExe python3Minimal} -m http.server -d ${site} -b 127.0.0.1 8080 &
    child_pid="$!"
    wait "''${child_pid}"
  '';
}
