                                                                            {
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    deploy-rs.url = "github:serokell/deploy-rs";
    lollypops.url = "github:pinpox/lollypops";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, nixos-hardware, lollypops, microvm, home-manager, ... }:

    {
      nixosConfigurations = {

        bonesboundhome = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lollypops.nixosModules.lollypops
            disko.nixosModules.disko
            microvm.nixosModules.host
            ./configurations/${self.networking.hostName}/configuration.nix
            { imports = [ "${nixos-hardware}/common/cpu/intel/sandy-bridge" ]; }
          ];
        };

      dudeWheresMySkin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lollypops.nixosModules.lollypops
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            # ./configurations/${self.networking.hostName}/home.nix
            ./configurations/${self.networking.hostName}/configuration.nix
            {
              imports = [ "${nixos-hardware}/common/cpu/intel/default.nix" "${nixos-hardware}/common/pc/laptop/hdd" ];
            }
          ];
        };
      };

      apps."x86_64-linux".default =
        lollypops.apps."x86_64-linux".default { configFlake = self; };

      lollypops.deployment = {
        # Where on the remote the configuration (system flake) is placed
        config-dir = "/var/src/lollypops";

        # Deployment Method
        deploy-method = "copy";

        # SSH connection parameters
        ssh.host = "${self.networking.hostName}"; # One day you should setup a ssh config so that the network hostname points to localhost
        ssh.user = "root";
        ssh.command = "ssh";
        ssh.opts = [ "-p" "${builtins.elemAt self.services.openssh.ports 0}" ];

        # sudo options
        sudo.enable = false;
      };
    };
}
