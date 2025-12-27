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
  cleanEval = lib.filterAttrsRecursive (n: _v: n != "_module") eval; # https://github.com/NixOS/nixpkgs/issues/293510

  optionsDoc = nixosOptionsDoc {
    inherit (cleanEval) options;
    transformOptions = mapURLs;
  };
in
rec {
  site = stdenvNoCC.mkDerivation {
    src = ./.;
    name = "docs";

    nativeBuildInputs = [
      mkdocs
      python3Packages.mkdocs-material
    ];

    buildPhase = ''
      cp ${optionsDoc.optionsCommonMark} ./docs/index.md
      mkdocs build
    '';

    installPhase = ''
      cp -r site $out
    '';

  };
  webserver = writeShellScriptBin "app" ''
    trap 'kill "''${child_pid}"; wait "''${child_pid}";' SIGINT SIGTERM
    ${merecat}/bin/merecat -n -p 8080 ${site} &
    child_pid="$!"
    wait "''${child_pid}"
  '';
}
