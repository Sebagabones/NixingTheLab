{ modulesPath, microvm, self, nixpkgs, lib, pkgs, ... }: {

    microvm.vms = {
      boneswebhome = {
        config = {
          microvm.shares = [{
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
          }];

          microvm = {
            hypervisor = "qemu";
            vcpu = 4;
            mem = 8192;
            interfaces = [ {
              type = "tap";
              id = "vm-boneswebhome";
              mac = "02:00:00:00:00:01";
            } ];
          };

          networking.hostName = "boneswebhome";
          networking.firewall.enable = false;

          systemd.network.enable = true;

          systemd.network.networks."20-eth0" = {
            matchConfig.Name = ["eth0"];
            networkConfig.DHCP = "yes";
          };

          users.users.root.password = "test";

          # SSH
          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = true;
              PermitRootLogin =
                "yes";
            };
          };
        };
      };
    };
  # };
}
