{ modulesPath, microvm, self, nixpkgs, lib, pkgs, ... }: {

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
