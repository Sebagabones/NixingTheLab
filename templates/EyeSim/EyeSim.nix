{
  pkgs,
  lib,
  version,
  hash,
  ...
}:
let
  pname = "EyeSim";
  EyeSim = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}";
    version = "${version}";

    src = pkgs.fetchzip {
      url = "https://roblab.org/eyesim/ftp/EyeSim-${version}-Linux.tar.gz";
      hash = "${hash}";
    };

    buildInputs = [
      pkgs.libx11
      pkgs.libxext
      pkgs.libxi
      pkgs.libxmu
      pkgs.libxrandr
      pkgs.libxcursor
      pkgs.hidapi
      pkgs.libunity
      # GL
      pkgs.libGL

      # Audio
      pkgs.alsa-lib
      pkgs.zlib
      # Wayland
      pkgs.wayland
      pkgs.libdecor

      # GTK stack
      pkgs.gtk3
      pkgs.glib
      pkgs.glib-networking
      pkgs.xdg-desktop-portal
      pkgs.gsettings-desktop-schemas
      pkgs.gtk4

      pkgs.cairo
      pkgs.pango

      # D-Bus
      pkgs.dbus
      pkgs.libxinerama
      # Misc common Unity deps
      pkgs.libxkbcommon
      pkgs.glib
      pkgs.libxscrnsaver
      pkgs.libxxf86vm
      pkgs.udev
      pkgs.libudev0-shim
      pkgs.mono
      pkgs.fontconfig
      pkgs.freetype
      pkgs.xdg-utils
      pkgs.libxcrypt
      pkgs.gnome.gvfs
      pkgs.gvfs
      pkgs.stdenv.cc.cc.lib
      pkgs.atk
    ];

    installPhase = ''
      mkdir -p $out/opt/EyeSim $out/lib

      # runHook preInstall
      cp -r . $out/opt/EyeSim
      cp -a install/lib/. $out/lib/
    '';

  });
in
(pkgs.buildFHSEnv {

  name = "EyeSim";

  targetPkgs =
    pkgs: with pkgs; [
      # IDK, I probably don't need alll of these but meh
      EyeSim
      libx11
      libxext
      libxi
      libxmu
      libxrandr
      libxcursor
      hidapi
      libunity

      libGL
      alsa-lib
      zlib

      wayland
      libdecor

      # GTK stack
      gtk3
      glib
      glib-networking
      xdg-desktop-portal
      gsettings-desktop-schemas
      gtk4
      cairo
      pango

      # D-Bus
      dbus
      libxinerama

      libxkbcommon
      glib
      libxscrnsaver
      libxxf86vm
      udev
      libudev0-shim
      mono
      fontconfig
      freetype
      xdg-utils
      libxcrypt
      stdenv.cc.cc.lib

    ];

  runScript = "${EyeSim}/opt/${pname}/EyeSim.x86_64";
})
