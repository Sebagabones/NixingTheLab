{ modulesPath, lib, pkgs, microvm, ... }:

{
    outputs = { self, nixpkgs, microvm }: {
      nixosConfigurations.boneswebhome = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        microvm.nixosModules.microvm
        {
          networking.hostName = "boneswebhome";
          microvm = {
            hypervisor = "stratovirt";
            vcpu = 4;
            mem = 8192;
            volumes = [{
              label = "boneswebhome";
            }];
          };
        }
      ];
    };
    };

}
