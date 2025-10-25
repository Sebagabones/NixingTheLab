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
      bootSSD = {
        vdb = {
          device = "/dev/disk/by-id/usb-SABRENT_SABRENT_DB9876543214E-0:0";
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
      zdata = {
        type = "zpool";
        mode = "mirror";
        mountpoint = "/storage";
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
