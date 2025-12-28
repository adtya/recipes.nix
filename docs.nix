{
  lib,
  nixosOptionsDoc,
  stdenvNoCC,
  mkdocs,
  python3Packages,
  writeShellScriptBin,
  merecat,
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
        url = "https://github.com/adtya/recipes.nix/blob/main/${subpath}";
        name = "recipes.nix/${subpath}";
      }
    else
      decl;

  mapURLs = opt: opt // { declarations = map toURL opt.declarations; };

  eval = lib.evalModules { modules = [ ./modules/nixos/options ]; };

  # https://github.com/NixOS/nixpkgs/issues/293510
  cleanEval = lib.filterAttrsRecursive (n: _v: n != "_module") eval;

  optionsDoc = nixosOptionsDoc {
    inherit (cleanEval) options;
    transformOptions = mapURLs;
  };

  site = stdenvNoCC.mkDerivation {
    src = ./.;
    name = "docs";

    nativeBuildInputs = [
      mkdocs
      python3Packages.mkdocs-material
      python3Packages.pygments
    ];

    buildPhase = ''
      cp ${optionsDoc.optionsCommonMark} ./docs/nixos-options.md
      mkdocs build
    '';

    installPhase = ''
      cp -r site $out
    '';

  };
in
{
  inherit site;
  devserver = writeShellScriptBin "app" ''
    trap 'kill "''${child_pid}"; wait "''${child_pid}";' SIGINT SIGTERM
    ${merecat}/bin/merecat -n -p 8080 ${site} &
    child_pid="$!"
    wait "''${child_pid}"
  '';
}
