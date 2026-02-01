{
  inputs,
  flake,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  imports = [
    inputs.self.homeModules.bones
    inputs.self.homeModules.gui
    inputs.agenix.homeManagerModules.default
    inputs.agenix-rekey.homeManagerModules.default
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

  # This allows me to copy .authinfo.gpg (mostly for forge) across machines - note that it is encrypted with gpg, and then age on top, which allows me to do slightly
  # more cursed things, don’t use this as an example for how to use agenix lmao.

  # You will need to add this into each machines user profile that you want it in.

  # In an ideal world, this would be in ~/modules/home/~, however, that didn’t work - no clue why.
  age.rekey = {
    masterIdentities = [ "/home/bones/.ssh/id_ed25519" ];
    storageMode = "local";
    localStorageDir =
      ../../../. + "/secrets/user-secrets/${config.home.username}-${osConfig.networking.hostName}"; # https://github.com/oddlama/agenix-rekey/issues/68#issuecomment-2624062990
    # NOTE: Update this with the ssh key of your user on this system
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbb35UUZb29bK6mv+LnHyfnhUtX9n7952K8RCpWxq1Q bones@resuscitated";
  };
  age.secrets = {
    authinfo = {
      rekeyFile = ../../../secrets/authinfo.age;
      path = "${config.home.homeDirectory}/.authinfo.gpg"; # WARN: *DO NOT DO THIS ANYWHERE ELSE!!!!*
      # Here I can get away with it soley because authinfo.gpg is still encrypted with my gpg key
      # Otherwise this is preetttttty sketchy
    };
  };
}
