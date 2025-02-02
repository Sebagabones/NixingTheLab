{
  pkgs, lib
}:

pkgs.stdenv.mkDerivation rec {

  name = "fancontrol";
  src = ./tempChecker.c;
  system = "x86_64-linux";
  nativeBuildInputs = [];
  buildInputs = [pkgs.ipmitool pkgs.lm_sensors];
  dontUnpack = true;
  buildPhase = ''gcc -DIPMITOOL_PATH='"${pkgs.ipmitool}/bin/ipmitool"' $src -o tempChecker'';
  installPhase = ''
  mkdir -p $out/bin
  cp tempChecker $out/bin
  '';
}
