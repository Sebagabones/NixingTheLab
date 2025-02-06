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
      ExecStart=''${fanControl}/bin/tempChecker'';
      Restart="always";
      RuntimeMaxSec="30m";
      RestartSec="1s";
      SyslogIdentifier="fanControl";
      User="root";
      Group="root";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
