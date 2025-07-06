{ config, lib, pkgs, inputs, ...}:
{

    environment.systemPackages = with pkgs; [
      lightdm
    ];
    programs.niri = {
      enable = true;
    };

}
