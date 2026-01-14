{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "berkeley-mono-font";
  version = "20260114";

  src = builtins.fetchGit {
    url = "ssh://git@github.com/Sebagabones/BerkeleyMono.git";
    rev = "a983a6393d955ba5854f8479187bbf92e3f1a5ec";
    # publicKeys = [{
    #   type = "ssh-ed25519";
    #   key =
    #     "AAAAC3NzaC1lZDI1NTE5AAAAIArPKULJOid8eS6XETwUjO48/HKBWl7FTCK0Z//fplDi";
    # }];
  };

  # unpackPhase = ''
  #   runHook preUnpack
  #   # mkdir $src/
  #   ${pkgs.unzip}/bin/unzip $src
  #
  #   runHook postUnpack
  # '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts
    # mkdir $src/patched
    cp -R $src/ $out/share/fonts/opentype/
    cp -R $src/ $out/share/fonts/truetype/

    # install -Dm644 berkeley-mono-patched/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

}
