#  This isn’t actually used rn
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  gpgFingerPrint = "9436F65232B1A8576F8E988614CFB56CDE807D15";
in
{
  imports = [
    inputs.agenix.homeManagerModules.default
    # inputs.agenix-rekey.homeManagerModules.default
    (import "${inputs.agenix-rekey}/modules/agenix-rekey.nix" inputs.nixpkgs)
  ];
  age.rekey = {
    hostPubkey = "";
    masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
    storageMode = "local";
    localStorageDir = ../../secrets + "/bones";

  };
  # age.rekey = {
  #   hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaWtBEVSXHRwujQDE0mgFwtTDNAU+rIlyt3HCGCKn2q"; # needs to be updated
  #   masterIdentities = [ "/home/bones/NixingTheLab/secrets/secret.key" ];
  #   storageMode = "local";
  #   localStorageDir = ./. + "/secrets";
  # };
  rekey.secrets = { };
  age.secrets.gpgkey.file = ../../secrets/private_gpg_key.age;

  systemd.user.services.gpg-import-keys = {
    Unit = {
      Description = "Auto import gpg keys";
      After = [ "gpg-agent.socket" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.gnupg}/bin/gpg --batch --import ${config.age.secrets.gpgkey.path} & ${pkgs.expect} -c 'spawn ${pkgs.gnupg}/bin/gpg --edit-key ${gpgFingerPrint} trust quit; send "5\ry\r"; expect eof'
      '';
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}
