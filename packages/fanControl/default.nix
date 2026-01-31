# default.nix
{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "fanControl";
  version = "0.0.2";
  src = ./tempChecker.c;
  # system = "x86_64-linux";
  nativeBuildInputs = [ ];
  buildInputs = [
    pkgs.ipmitool
    pkgs.lm_sensors
    pkgs.gcc
  ];
  dontUnpack = true;
  buildPhase = ''gcc -DIPMITOOL_PATH='"${pkgs.ipmitool}/bin/ipmitool"' -DSENSORS_PATH='"${pkgs.lm_sensors}/bin/sensors"' $src -o tempChecker'';
  installPhase = ''
    mkdir -p $out/bin
    cp tempChecker $out/bin
  '';
}
