{ flake, inputs, lib, perSystem, pkgs, nixpkgs, ... }: {
  networking.hostName = "insanity";
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelModules = [ "kvm_intel" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  programs.xwayland.enable = true;
  # programs.wayland.miracle-wm.enable = true;
  # Packages

  # environment.systemPackages = with pkgs; [ miracle-wm ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.graphics.extraPackages = with pkgs; [ amdvlk ];
  hardware.bluetooth.enable = true;

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.dbus.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.xserver = {
    enable = true;
    videoDrivers = [ "amd" ];
    desktopManager = { xterm.enable = false; };
  };
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
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
  services.libinput.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;

  lollypops.deployment.group = "Personal";
  home-manager.backupFileExtension = "backup";

  stylix.enable = true;
}
