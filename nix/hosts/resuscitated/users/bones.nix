{ inputs, flake, config, lib, pkgs, ... }:

{
  imports = [ inputs.self.homeModules.bones inputs.self.homeModules.nonserver ];
}
