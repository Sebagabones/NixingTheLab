{ modulesPath, lib, pkgs, nixpkgs, disko, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./initialInstall/diskConfig.nix
    ./../defaults/defaultsLaptops.nix
  ];
  config = {
    boot.loader.grub = {
      efiSupport = true;
    };

    nixpkgs.config.allowUnfree = true;
    networking.hostName = "dudeWheresMySkin";

  };
}
