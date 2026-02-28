{
  pkgs,
  lib,
  version,
  hash,
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "EyeSim";
  version = "${version}";

  src = pkgs.fetchzip {
    url = "https://roblab.org/eyesim/ftp/EyeSim-${version}-Linux.tar.gz";
    hash = "${hash}";
  };

  installPhase = ''
    mkdir -p "$out"/{bin,libexec}
    cp -r . "$out/libexec/EyeSim"
    chmod -R u+w "$out/libexec/EyeSim"
    rm -rf "$out/libexec/EyeSim/__MACOSX"

    cat >"$out/bin/EyeSim" <<EOF
    #!${pkgs.stdenvNoCC.shell}
    set -euo pipefail
    cd "$out/libexec/EyeSim"
    exec ${pkgs.steam-run}/bin/steam-run "$out/libexec/EyeSim/EyeSim.x86_64" "\$@"
    EOF
    chmod +x "$out/bin/EyeSim"
  '';
}
