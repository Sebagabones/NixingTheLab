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
  outputs = { self, nixpkgs, disko, nixos-hardware, lollypops, microvm
    , home-manager, ... }:
    let
      # Define hosts and configurations
      hosts = {
        bonesboundhome = {
          system = "x86_64-linux";
          hardware = [ "${nixos-hardware}/common/cpu/intel/sandy-bridge" ];
          microvm = true;
        };
        dudeWheresMySkin = {
          system = "x86_64-linux";
          hardware = [
            "${nixos-hardware}/common/cpu/intel/default.nix"
            "${nixos-hardware}/common/pc/laptop/hdd"
          ];
          microvm = false;
        };
        vmtesting = {
          system = "x86_64-linux";
          microvm = false;
        };
      };

      mkSystem = hostname: cfg:
        nixpkgs.lib.nixosSystem {
          system = cfg.system;
          modules = [
            lollypops.nixosModules.lollypops
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ./configurations/${hostname}/configuration.nix
            {
              networking.hostName = hostname;
              imports = cfg.hardware;
            }
          ] ++ (if cfg.microvm then [ microvm.nixosModules.host ] else [ ]);
        };
    in {
      # Generate nixosConfigurations for all hosts
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem hosts;

      # Default app
      apps."x86_64-linux".default =
        lollypops.apps."x86_64-linux".default { configFlake = self; };

      # Generate lollypops deployment configurations for all hosts
      lollypops.deployment = nixpkgs.lib.mapAttrs (hostname: cfg: {
        config-dir = "/var/src/lollypops";
        deploy-method = "copy";
        ssh.host = hostname;
        ssh.user = "root";
        ssh.command = "ssh";
        ssh.opts = [ "-p" "22" ];
        sudo.enable = false;
      }) hosts;
    };
}
