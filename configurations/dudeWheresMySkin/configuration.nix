{ modulesPath, lib, pkgs, nixpkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./initialInstall/diskConfig.nix
    ./../defaults.nix
  ];

}
