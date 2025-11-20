{ inputs, ... }: {
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices = {
    disk = {
      vdb = {
        device =
          "/dev/disk/by-id/nvme-SAMSUNG_MZVLW256HEHP-000L7_S35ENX2JA86582";
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
                format = "xfs";
                mountpoint = "/";
                mountOptions =
                  [ "defaults" "pquota" "logbufs=8" "logbsize=256k" ];
              };
            };
          };
        };
      };
    };
  };
}
