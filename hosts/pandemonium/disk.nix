# { inputs, ... }: {
#   imports = [ inputs.disko.nixosModules.disko ];
#
#   disko.devices = {
#     disk = {
#       one = {
#         type = "disk";
#         device = "/dev/disk/by-id/wwn-0x5001b448b509ca15";
#         content = {
#           type = "gpt";
#           partitions = {
#             BOOT = {
#               size = "1M";
#               type = "EF02"; # for grub MBR
#             };
#             ESP = {
#               size = "1024M";
#               type = "EF00";
#               content = {
#                 type = "mdraid";
#                 name = "boot";
#               };
#             };
#             mdadm = {
#               size = "100%";
#               content = {
#                 type = "mdraid";
#                 name = "raid1";
#               };
#             };
#           };
#         };
#       };
#       two = {
#         type = "disk";
#         device = "/dev/disk/by-id/wwn-0x5001b448b576af07";
#         content = {
#           type = "gpt";
#           partitions = {
#             boot = {
#               size = "1M";
#               type = "EF02"; # for grub MBR
#             };
#             ESP = {
#               size = "1024M";
#               type = "EF00";
#               content = {
#                 type = "mdraid";
#                 name = "boot";
#               };
#             };
#             mdadm = {
#               size = "100%";
#               content = {
#                 type = "mdraid";
#                 name = "raid1";
#               };
#             };
#           };
#         };
#       };
#     };
#     mdadm = {
#       boot = {
#         type = "mdadm";
#         level = 1;
#         metadata = "1.0";
#         content = {
#           type = "filesystem";
#           format = "vfat";
#           mountpoint = "/boot";
#           mountOptions = [ "umask=0077" ];
#         };
#       };
#       raid1 = {
#         type = "mdadm";
#         level = 1;
#         content = {
#           type = "gpt";
#           partitions.primary = {
#             size = "100%";
#             content = {
#               type = "filesystem";
#               format = "ext4";
#               mountpoint = "/";
#             };
#           };
#         };
#       };
#     };
#   };
# }
{ inputs, ... }:

{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      root1 = {
        device = "/dev/disk/by-id/wwn-0x5001b448b509ca15";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
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
                pool = "zpool";
              };
            };
          };
        };
      };
      root2 = {
        device = "/dev/disk/by-id/wwn-0x5001b448b576af07";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zpool";
              };
            };
          };
        };
      };
    };
    zpool.zpool = {
      type = "zpool";
      mode = "mirror";
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
        var = {
          type = "zfs_fs";
          mountpoint = "/var";
        };
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        home = {
          type = "zfs_fs";
          mountpoint = "/home";
        };
      };
    };
  };

  services.zfs.autoScrub = {
    enable = true;
    pools = [ "zpool" ];
  };
}
