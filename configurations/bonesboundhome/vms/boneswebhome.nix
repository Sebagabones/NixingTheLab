{ modulesPath, microvm, config, self, nixpkgs, options, lib, pkgs, ... }:

let # Please do this better sometime - you should be able to use a custom module or something to import these - but for now urgh
  defaults = import ../../defaultsServer.nix;
in
{

    microvm.vms = {
      boneswebhome = {

        config = lib.mkMerge [
          {
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

          microvm.writableStoreOverlay = "/tmp/.boneswebhome-rw-store";

          microvm.volumes = [ {
            image = "boneswebhome-nix-store-overlay.img";
            mountPoint = "/tmp/.boneswebhome-rw-store";
            size = 2048;
          } ];

          system.switch.enable = true;

          networking.hostName = "boneswebhomenix";

          networking.firewall.enable = false;

          systemd.network.enable = true;

          systemd.network.networks."20-eth0" = {
            matchConfig.Name = ["eth0"];
            networkConfig.DHCP = "yes";
          };

          systemd.tmpfiles.settings = {
            "lollipops" = {
              "/var/src/lollypops" = {
                d = {
                  group = "root";
                  mode = "0755";
                  user = "root";
                };
              };
            };
          };

          }
          # Including the external default install
          defaults
        ];
      };
    };
  # };
}
