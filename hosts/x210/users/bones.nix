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
        name = "SynPS/2 Synaptics TouchPad";
        vendorId = "0002";
        productId = "0007";
      }
    ];
  };
}
