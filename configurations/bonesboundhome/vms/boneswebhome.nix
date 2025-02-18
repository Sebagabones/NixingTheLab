{ microvm, nixpkgs, ... }: {
  imports = [ ./../../defaults.nix ];

  microvm.vms = {
    boneswebhome = {
      # The package set to use for the microvm. This also determines the microvm's architecture.
      # Defaults to the host system's package set if not given.

      # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
      #specialArgs = {};

      # The configuration for the MicroVM.
      # Multiple definitions will be merged as expected.

      config = {
        # It is highly recommended to share the host's nix-store
        # with the VMs to prevent building huge images.
        microvm.shares = [{
          tag = "ro-store";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }];

        microvm = {
          hypervisor = "qemu";
          vcpu = 4;
          mem = 8192;
          # volumes = [{
          #   label = "boneswebhome";
          #   mountPoint = "/tmp";
          #   size = "15360";
          # }];
          interfaces = [{
            type = "tap";
            id = "boneswebhome";
            mac = "02:00:00:00:00:01";
          }];
        };

        system.stateVersion = "24.11";

        networking.hostName = "boneswebhome";
        networking.firewall.enable = false;

        systemd.network.enable = true;
        systemd.network.networks."10-lan" = {
          matchConfig.Type = "ether";
          networkConfig = {
            Address = [ "192.168.1.151/24" ];
            Gateway = "192.168.1.1";
            DNS = [ "192.168.1.2" ];
            IPv6AcceptRA = true;
            DHCP = "no";
          };
        };
      };
      # Any other configuration for your MicroVM
      # [...]
      
    };
  };
}
