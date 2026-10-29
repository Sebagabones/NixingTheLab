{
  pkgs,
}:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "opentmux";
  version = "0.1";

  outputs = [
    "out"
    "man"
  ];

  src = pkgs.fetchFromCodeberg {
    owner = "opentmux";
    repo = "opentmux";
    rev = "0eb3d7e523405977e5ec0ff496c93ce74eefd838";
    hash = "sha256-OgNIXaa2hGfdNyM2iq3OasyYIDioT8k1SKOjuXfKCJU=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    autoreconfHook
    bison
    lowdown
  ];

  buildInputs = with pkgs; [
    ncurses
    libevent
    systemdLibs
    utf8proc
    libutempter
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-systemd"
    "--enable-sixel"
    "--enable-utempter"
    "--enable-utf8proc"
  ];

  enableParallelBuilding = true;

  # postInstall = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
  #   mkdir $out/nix-support
  #   echo "${finalAttrs.passthru.terminfo}" >> $out/nix-support/propagated-user-env-packages
  # '';

  nativeInstallCheckInputs = [ ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  passthru = {
    terminfo = pkgs.runCommand "opentmux-terminfo" { nativeBuildInputs = [ pkgs.ncurses ]; } (

      ''
        mkdir -p $out/share/terminfo/t
        ln -sv ${pkgs.ncurses}/share/terminfo/t/{tmux,tmux-256color,tmux-direct} $out/share/terminfo/t
      ''
    );
  };

  meta = {
    homepage = "https://codeberg.org/opentmux/opentmux";
    downloadPage = "https://codeberg.org/opentmux/opentmux";
    description = "Terminal multiplexer";
    longDescription = ''
      This is a fork of tmux-3.6a before any AI was introduced into the project.
    '';
    changelog = "https://codeberg.org/opentmux/opentmux/releases/tag/v${finalAttrs.version}";
    license = pkgs.lib.licenses.bsd3;
    platforms = pkgs.lib.platforms.unix;
    mainProgram = "opentmux";
    maintainers = with pkgs.lib.maintainers; [
      sebagabones
    ];
  };
})
