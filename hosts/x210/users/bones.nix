{
  inputs,
  flake,
  config,
  lib,
  pkgs,
  # osConfig,
  ...
}:

{
  imports = [
    inputs.self.homeModules.bones
    inputs.self.homeModules.gui
    # inputs.agenix.homeManagerModules.default
    # inputs.agenix-rekey.homeManagerModules.default
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

  # While i got the below to work, forge doesn’t seem to work with it being done through nix (my best bet is that because it is read only? idk):

  # # This allows me to copy .authinfo.gpg (mostly for forge) across machines - note that it is encrypted with gpg, and then age on top, which allows me to do slightly
  # # more cursed things, don’t use this as an example for how to use agenix lmao.
  #
  # # You will need to add this into each machines user profile that you want it in.
  #
  # # In an ideal world, this would be in ~/modules/home/~, however, that didn’t work - no clue why.
  # age.rekey = {
  #   masterIdentities = [ "/home/bones/.ssh/id_ed25519" ];
  #   storageMode = "local";
  #   localStorageDir =
  #     ../../../. + "/secrets/user-secrets/${config.home.username}-${osConfig.networking.hostName}"; # https://github.com/oddlama/agenix-rekey/issues/68#issuecomment-2624062990
  #   # NOTE: Update this with the ssh key of your user on this system
  #   hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0v56VlLL/6BNK8rNW+fIMIYSgTURqi2H9ZumDbudtL bones@x210";
  # };
  # age.secrets = {
  #   authinfo = {
  #     rekeyFile = ../../../secrets/authinfo.age;
  #     path = "${config.home.homeDirectory}/.authinfo.gpg"; # WARN: *DO NOT DO THIS ANYWHERE ELSE!!!!*
  #     # Here I can get away with it soley because authinfo.gpg is still encrypted with my gpg key
  #     # Otherwise this is preetttttty sketchy
  #   };
  # };
}
