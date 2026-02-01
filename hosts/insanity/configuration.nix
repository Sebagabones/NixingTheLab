{
  flake,
  inputs,
  lib,
  perSystem,
  pkgs,
  nixpkgs,
  config,
  ...
}:
let
  hostname = "insanity";

in
{

  networking.hostName = "${hostname}";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [
    flake.nixosModules.base
    flake.nixosModules.gui
    ./disk.nix
    "${inputs.nixos-hardware}/common/cpu/intel/alder-lake"
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/common/gpu/amd"
    "${inputs.nixos-hardware}/common/pc"
  ];

  services.hardware.openrgb = {
    enable = true;
    startupProfile = "Fans";
    package = pkgs.openrgb-with-all-plugins;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # boot.kernelModules = [ "kvm_intel" ];
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
  };
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaWtBEVSXHRwujQDE0mgFwtTDNAU+rIlyt3HCGCKn2q";
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets";
  };

  age.secrets = { };
  # programs.xwayland.enable = true;
  # programs.wayland.miracle-wm.enable = true;
  # Packages
  networking.interfaces.enp6s0.wakeOnLan.enable = true;
  # environment.systemPackages = with pkgs; [ miracle-wm ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # hardware.graphics = {
  #   enable = true;
  #   enable32Bit = true;
  # };
  # hardware.graphics.extraPackages = with pkgs; [ ];
  # hardware.bluetooth.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    protonup-qt
    wineWowPackages.waylandFull
  ];

  # environment.pathsToLink =
  #   [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  # security.rtkit.enable = true;
  # security.polkit.enable = true;
  # services.dbus.enable = true;

  # services.pulseaudio.enable = false;
  # services.pipewire = {
  #   enable = true;
  #   audio.enable = true;
  #   alsa.enable = true;
  #   pulse.enable = true;
  # };
  # services.xserver = {
  #   enable = true;
  #   videoDrivers = [ "amd" ];
  #   desktopManager = { xterm.enable = false; };
  # };
  # services.xserver.displayManager.gdm.enable = true;
  services.displayManager.gdm.autoSuspend = false;
  services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  systemd.targets.sleep.enable = true;
  systemd.targets.suspend.enable = true;
  systemd.targets.hibernate.enable = true;
  systemd.targets.hybrid-sleep.enable = true;

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command =
  #         "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd miracle-wm-session";
  #       user = "greeter";
  #     };
  #   };
  # };
  # services.libinput.enable = true;

  lollypops.deployment.group = "Personal";

  stylix.enable = true;
}
