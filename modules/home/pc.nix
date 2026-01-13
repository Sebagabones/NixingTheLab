{ lib, config, pkgs, inputs, ... }: {
  imports = [
    # ./pcSpecifics/dconfPc.nix

    inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma = {
    overrideConfig = true;
    powerdevil.AC = lib.mkForce {
      powerButtonAction = "shutDown";
      autoSuspend.action = "nothing";
    };
  };
}
