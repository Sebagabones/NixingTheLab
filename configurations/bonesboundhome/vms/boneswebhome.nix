{ modulesPath, microvm, self, nixpkgs, lib, pkgs, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
        ./boneswebhomeconfig.nix
  ];
  # The package set to use for the microvm. This also determines the microvm's architecture.
  # Defaults to the host system's package set if not given.

  # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
  #specialArgs = {};

  # The configuration for the MicroVM.
  # Multiple definitions will be merged as expected.
  config = {
    microvm.vms = {
      boneswebhome = {

      };
    };
  };
}
