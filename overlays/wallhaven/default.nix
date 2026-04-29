{
  lib,
  stdenvNoCC,
  makeWrapper,
  curl,
  envsubst,
  jq,
  libsecret,
  xdg-user-dirs,
}:
stdenvNoCC.mkDerivation {
  pname = "wallhaven";
  version = "0.1";
  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    curl
    envsubst
    jq
    libsecret
    xdg-user-dirs
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp wallhaven.sh $out/bin/wallhaven
    chmod +x $out/bin/wallhaven

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/wallhaven --prefix PATH : ${
      lib.makeBinPath [
        curl
        envsubst
        jq
        libsecret
        xdg-user-dirs
      ]
    }
  '';
}
