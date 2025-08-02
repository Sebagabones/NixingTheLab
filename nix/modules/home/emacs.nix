{ config, lib, pkgs, ... }:
let
  userCfg = config.users.bones;
  cfg = userCfg.programs.emacs;
  emacsInstallation = "${config.home.homeDirectory}/.emacs.d";

in {
  config = {
    # Automatically install Emacs config from here.
    home.mutableFile.${emacsInstallation} = {
      url = "https://github.com/Sebagabones/myEmacsConfig.git";
      type = "git";
    };
    # Enable Emacs server for them quicknotes.
    services.emacs = {
      enable = true;
      socketActivation.enable = true;
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
      extraPackages = epkgs:
        with epkgs; [
          org-noter-pdftools
          org-pdftools
          pdf-tools
          vterm
        ];
    };
    # Add org-protocol support.
    xdg.desktopEntries.org-protocol = {
      name = "org-protocol";
      exec = "emacsclient -- %u";
      mimeType = [ "x-scheme-handler/org-protocol" ];
      terminal = false;
      comment = "Intercept calls from emacsclient to trigger custom actions";
      noDisplay = true;
    };

    xdg.mimeApps.defaultApplications = {
      "application/json" = [ "emacs.desktop" ];
      "text/org" = [ "emacs.desktop" ];
      "text/plain" = [ "emacs.desktop" ];
      "x-scheme-handler/org-protocol" = [ "org-protocol.desktop" ];
    };
  };
}
