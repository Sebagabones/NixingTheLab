# fanControl.nix
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
      WorkingDirectory=/home/bones/Storage/Software/IBM-xSeries-server-fan-control;
      ExecStart="fanControl";
      Restart="on-failure";
      RestartSec="1s";
      SyslogIdentifier="fanControl";
      User="root";
      Group="root";
      Environment="PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin";
    };
  };
}
