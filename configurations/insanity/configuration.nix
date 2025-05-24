{ modulesPath, lib, pkgs, nixpkgs, disko, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./initialInstall/diskConfig.nix
    ./../defaults/defaultsLaptops.nix
  ];
  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nixpkgs.config.allowUnfree = true;
    networking.hostName = "insanity";

  };
}
