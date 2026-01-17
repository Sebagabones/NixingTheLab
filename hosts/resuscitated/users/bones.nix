{
  inputs,
  flake,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.self.homeModules.bones
    inputs.self.homeModules.gui
  ];
  programs.plasma.input = {
    touchpads = [
      {
        naturalScroll = true;
        name = "Synaptics TM3276-022";
        vendorId = "06cb";
        productId = "0000";
      }
    ];
  };
}
