# default.nix
{ pkgs, config, lib, ... }:

let fanControl = pkgs.callPackage ./package.nix { inherit pkgs lib; };
in rec {

  environment.systemPackages = [ fanControl ];
  systemd.services."fanControl" = {
    enable = true;
    after = ["network.target"];
    description = "Fan Speed Service";
    serviceConfig = {
      Type="simple";
      ExecStart="fanControl";
      Restart="on-failure";
      RestartSec="1s";
      SyslogIdentifier="fanControl";
      User="root";
      Group="root";
    };
  };
}
