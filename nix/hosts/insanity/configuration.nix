{ flake, inputs, lib, perSystem, pkgs, nixpkgs, ... }: {
  networking.hostName = "insanity";
  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = [
    flake.nixosModules.base
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
  # Packages
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    lightdm
    kdePackages.konsole
    firefox
    spotify
    discord
    wezterm
    wlr-randr
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.graphics.extraPackages = with pkgs; [ amdvlk ];

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

    displayManager = {
      lightdm = {
        enable = true;

        greeters.slick = { enable = true; };
        # background = ../../assests/background.png;
      };
    };

    #   windowManager.i3 = {
    #     enable = true;
    #     extraPackages = with pkgs; [
    #       dmenu # application launcher most people use
    #       i3status # gives you the default i3 status bar
    #       i3lock # default i3 screen locker
    #       i3blocks # if you are planning on using i3blocks over i3status
    #     ];
    #   };
  };
  # services.displayManager.defaultSession = "niri";
  services.libinput.enable = true;
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${
  #           lib.getExe pkgs.niri
  #         }-session";
  #       user = "greeter";
  #     };
  #   };
  # };

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;

  lollypops.deployment.group = "Personal";
  # home-manager.backupFileExtension = "backup";

}
