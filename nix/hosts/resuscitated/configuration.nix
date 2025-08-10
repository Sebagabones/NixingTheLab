{ flake, inputs, lib, perSystem, pkgs, nixpkgs, ... }: {
  networking.hostName = "resuscitated";
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
    flake.nixosModules.gui
    ./disk.nix
    "${inputs.nixos-hardware}/lenovo/thinkpad/t480"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm_intel" ];
  # boot.initrd.kernelModules = [ "amdgpu" ];
  programs.xwayland.enable = true;
  # programs.wayland.miracle-wm.enable = true;
  # Packages

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth.enable = true;
  # hardware.graphics.extraPackages = with pkgs; [
  #   vaapiIntel
  #   intel-media-driver
  # ];

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
    # videoDrivers = [ "intel" ];
    desktopManager = { xterm.enable = false; };
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  services.undervolt = {
    enable = true;
    useTimer = true;
    tempBat = 85;
    temp = 85;
    coreOffset = -100;
    p1 = {
      limit = 42;
      window = 28;
    };
    p2 = {
      limit = 44;
      window = 2.0e-3;
    };
  };
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #
  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     # CPU_MIN_PERF_ON_BAT = 0;
  #     # CPU_MAX_PERF_ON_BAT = 50;
  #     #Optional helps save long term battery health
  #     START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
  #     STOP_CHARGE_THRESH_BAT0 = 95; # 80 and above it stops charging
  #   };
  # };

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;

  lollypops.deployment.group = "Personal";
  home-manager.backupFileExtension = "backup";

  stylix.enable = true;
}
