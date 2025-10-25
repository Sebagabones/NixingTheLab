{ inputs, ... }:
let
  hardDriveDefaultsContent = {
    type = "gpt";
    partitions = {
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "zdata";
        };
      };
    };
  };
in {
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices = {
    disk = {
      vdb = {
        device =
          "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S7BWNJ0WA34315L";
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
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      hardDrive1 = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-35000c50056bc3e4f";
        content = hardDriveDefaultsContent;

      };
      hardDrive2 = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-35000c50085f1ccbf";
        content = hardDriveDefaultsContent;
      };
      hardDrive3 = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-35000cca027c69d98";
        content = hardDriveDefaultsContent;
      };
      hardDrive4 = {
        type = "disk";
        device = "/dev/disk/by-id/scsi-35000cca0461efe20";
        content = hardDriveDefaultsContent;
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          mountpoint = "none";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
        };
      };
      zdata = {
        type = "zpool";

        mountpoint = "/storage";
        mode = {
          topology = {
            type = "topology";
            vdev = [{
              mode = "mirror";
              members = [ "hardDrive1" "hardDrive2" "hardDrive3" "hardDrive4" ];
            }];
          };
        };
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          mountpoint = "none";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          mainStorage = {
            type = "zfs_fs";
            mountpoint = "/storage/main";
            options = { compression = "zstd"; };
          };
          immich = {
            type = "zfs_fs";
            mountpoint = "/storage/immich";
            options = { compression = "zstd"; };
          };
          git = {
            type = "zfs_fs";
            mountpoint = "/storage/git";
            options = { compression = "zstd"; };
          };
        };
      };
    };
  };
}
