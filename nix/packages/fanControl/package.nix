{
  pkgs, lib
}:

pkgs.stdenv.mkDerivation rec {
  pname = "fancontrol";
  name = "fancontrol";
  src = ./tempChecker.c;
  system = "x86_64-linux";
  nativeBuildInputs = [];
  buildInputs = [pkgs.ipmitool pkgs.lm_sensors];
  dontUnpack = true;
  buildPhase = ''gcc -DIPMITOOL_PATH='"${pkgs.ipmitool}/bin/ipmitool"' -DSENSORS_PATH='"${pkgs.lm_sensors}/bin/sensors"' $src -o tempChecker'';
  installPhase = ''
  mkdir -p $out/bin
  cp tempChecker $out/bin
  '';
}
