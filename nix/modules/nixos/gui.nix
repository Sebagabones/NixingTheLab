{ flake, pkgs, ...}:

{
    environment.systemPackages = with pkgs; [
      lightdm
    ];
    programs.niri = {
      enabled = true;
    };

}
