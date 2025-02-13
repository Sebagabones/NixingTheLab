{ microvm, nixpkgs, ... }: {
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
        networking.hostName = "boneswebhome";
        microvm = {
          hypervisor = "qemu";
          vcpu = 4;
          mem = 8192;
          # volumes = [{
          #   label = "boneswebhome";
          #   mountPoint = "/tmp";
          #   size = "15360";
          # }];
        };
        # Any other configuration for your MicroVM
        # [...]
      };
    };
  };
}
