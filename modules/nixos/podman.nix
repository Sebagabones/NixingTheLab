{ pkgs, ... }:
{
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    libvirtd = {
      enable = false;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

    # Enable USB redirection
    spiceUSBRedirection.enable = true;

    podman = {
      enable = false;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.spice-vdagentd.enable = false; # enable copy and paste between host and guest
  services.qemuGuest.enable = false;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  programs.virt-manager.enable = false;

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    # docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
    distrobox
    dnsmasq
  ];
}
