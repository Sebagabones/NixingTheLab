_:

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
  # Remote builder keys
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8jRqCL02AT+TDvYx+8uHp6/RtMM8kn7Yl+wx6V21qO root@deposition"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4xk7qmEk3SZN7JdpgMij3znkkXCfdDWvSjBf3VtZU3 root@insanity"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1f+t3EE9CqHLUQobR32c7m8ReuKPRNZNuK5hD1g0ko root@pandemonium"
    ];
  };

}
