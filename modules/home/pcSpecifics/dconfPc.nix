{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib.hm.gvariant;
{
  dconf.settings = {
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };
  };
}
