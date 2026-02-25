{
  description = "ROS2 template";
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs"; # IMPORTANT!!!
  };
  outputs =
    {
      nix-ros-overlay,
      nixpkgs,
    }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.permittedInsecurePackages = [ "freeimage-3.18.0-unstable-2024-04-18" ];

          overlays = [
            nix-ros-overlay.overlays.default
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Example project";

          # NOTE: These two enviroment variables are set for gazebo, as it hates wayland
          QT_QPA_PLATFORM = "xcb";
          WAYLAND_DISPLAY = "";

          packages = [
            pkgs.colcon # for some reason this like, isn't inside of the ros overlay??
            # NOTE: Regular packages go here
            (
              with pkgs.rosPackages.jazzy;
              buildEnv {
                paths =
                  let
                    wrapped-rqt-robot-steering = rqt-robot-steering.overrideAttrs (old: {
                      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.qt5.wrapQtAppsHook ];
                      dontWrapQtApps = false;
                      postFixup = ''
                        wrapQtApp "$out/lib/rqt_robot_steering/rqt_robot_steering"
                      '';
                    });

                  in
                  [
                    # NOTE: packages from ros overlay go here
                    ros-core
                    ur
                    urdf
                    ros-core
                    ament-cmake-core
                    python-cmake-module

                    # Gazebo/Rviz
                    gz-sim-vendor
                    rviz2
                    ros-gz-bridge
                    ros-gz
                    gz-launch-vendor

                    nav2-minimal-tb4-sim
                    nav2-minimal-tb3-sim

                    # rqt metapackages
                    rqt-common-plugins
                    rqt-tf-tree
                    tf2-tools

                    # packages used in this project
                    example-interfaces
                    sensor-msgs
                    slam-toolbox
                    wrapped-rqt-robot-steering
                  ];
              }
            )
          ];
        };
      }
    );
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
