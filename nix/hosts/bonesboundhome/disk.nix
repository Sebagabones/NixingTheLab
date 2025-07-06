{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices = {
    disk = {
      vdb = {
        device = "/dev/disk/by-id/ata-CT250MX500SSD1_2402E88CC199";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1024M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
