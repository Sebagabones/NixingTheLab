{ config, pkgs, ... }:

{
  nix.buildMachines = [
    {
      hostName = "pandemonium";
      system = "x86_64-linux";
      protocol = "ssh";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = [ "x86_64-linux" "aarch64-linux" ];
      maxJobs = 80; # leave 8 threads free
      speedFactor = 2;
      # supportedFeatures = [ "big-parallel" ];
      # mandatoryFeatures = [ "big-parallel" ];
    }
  ];

}
