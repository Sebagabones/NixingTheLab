{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  # inputs.microvm.url = "github:astro/microvm.nix";
  # inputs.microvm.inputs.nixpkgs.follows = "nixpkgs";


  outputs =
    {
      self,
      nixpkgs,
      disko,
      nixos-hardware,
      deploy-rs,
      # microvm,
      ...
    }:

    {
      nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          disko.nixosModules.disko
          ./configuration.nix
          # microvm.nixosModules.microvm

          {
            imports = [
              "${nixos-hardware}/common/cpu/intel/sandy-bridge"
            ];
          }
        ];
      };
      deploy.nodes.generic = {
        hostname = "mahoosively.gay";

      profiles.deploy = {
        user = "root";
        sshUser = "root";
        sshOpts = ["-p" "8909" ];
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.generic;

      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };

}
