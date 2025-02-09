{ modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./../../diskConfig.nix
    ./../../pkgs/fanControl/default.nix
    ./../defaults.nix
    # ./mdadm.nix
  ];

  config = {

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    # efiInstallAsRemovable = true;
  };

  # SSH
  services.openssh.ports = [ 8909 ];

  environment.systemPackages = with pkgs; [
    lazygit                     # This is here to make sure defaults works as expected, at some point move to default install packages for dev machines probably
  ];

  # Networking
  networking.hostName = "bonesboundhome";

  system.stateVersion = "24.11";
  };

}
