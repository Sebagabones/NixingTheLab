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
  notToBeTrustedDefaultsContent = {
    type = "gpt";
    partitions = {
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "zdonttrust";
        };
      };
    };
  };
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      # Boot SSD's
      bootssd1 = {
        device = "/dev/disk/by-id/ata-CT250MX500SSD1_2402E88CBFC0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
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

      bootssd2 = {
        device = "/dev/disk/by-id/ata-CT250MX500SSD1_2402E88CC199";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
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

      # Scratch SSD
      scratch_ssd = {
        device = "/dev/disk/by-id/ata-PLEXTOR_PX-256S3G_P02812106309";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/scratch";
                mountOptions = [
                  "defaults"
                  "pquota"
                  "logbufs=8"
                  "logbsize=256k"
                ];
              };
            };
          };
        };
      };

      ##########################
      ## 3TB Drives: -> zdata ##
      ##########################
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

      ###############################
      ## 2TB Drives: -> zdonttrust ##
      ## These are not numbered in ##
      ## any particular order      ##
      ###############################
      notToBeTrusted1 = {
        # /dev/sdc
        type = "disk";
        device = "/dev/disk/by-id/ata-Hitachi_HDS722020ALA330_JK1174YAHNRW1W";
        content = notToBeTrustedDefaultsContent;

      };
      notToBeTrusted2 = {
        # /dev/sde
        type = "disk";
        device = "/dev/disk/by-id/ata-Hitachi_HDS722020ALA330_JK1174YAHNSE8W";
        content = notToBeTrustedDefaultsContent;
      };
      notToBeTrusted3 = {
        # /dev/sdg
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000c500e4a3cd99";
        content = notToBeTrustedDefaultsContent;
      };
      notToBeTrusted4 = {
        # /dev/sdi
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x50014ee059b2c2b2";
        content = notToBeTrustedDefaultsContent;
      };
    };

    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        extraArgs = [ "--bitmap=internal" ];
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
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
            vdev = [
              {
                mode = "mirror";
                members = [
                  "hardDrive1"
                  "hardDrive2"
                ];
              }
              {
                mode = "mirror";
                members = [
                  "hardDrive3"
                  "hardDrive4"
                ];
              }
            ];
          };
        };
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          mountpoint = "none";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          mainStorage = {
            type = "zfs_fs";
            options = {
              mountpoint = "/storage/main";
              compression = "zstd";
            };
          };
          immich = {
            type = "zfs_fs";
            options = {
              mountpoint = "/storage/immich";
              compression = "zstd";
            };
          };
          git = {
            type = "zfs_fs";
            options = {
              mountpoint = "/storage/git";
              compression = "zstd";
            };
          };
        };
      };

      zdonttrust = {
        type = "zpool";
        mountpoint = "/donttrust";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "mirror";
                members = [
                  "notToBeTrusted1"
                  "notToBeTrusted2"
                ];
              }
              {
                mode = "mirror";
                members = [
                  "notToBeTrusted3"
                  "notToBeTrusted4"
                ];
              }
            ];
          };
        };
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          mountpoint = "/donttrust";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
      };
    };
  };
}
