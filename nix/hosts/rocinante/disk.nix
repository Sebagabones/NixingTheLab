# { inputs, ... }: {
#   imports = [ inputs.disko.nixosModules.disko ];
#   disko.devices = {
#     disk = {
#       vdb = {
#         device = "/dev/disk/by-id/ata-CT250MX500SSD1_2402E88CC199";
#         type = "disk";
#         content = {
#           type = "gpt";
#           partitions = {
#             ESP = {
#               type = "EF00";
#               size = "1024M";
#               content = {
#                 type = "filesystem";
#                 format = "vfat";
#                 mountpoint = "/boot";
#                 mountOptions = [ "umask=0077" ];
#               };
#             };
#             root = {
#               size = "100%";
#               content = {
#                 type = "filesystem";
#                 format = "xfs";
#                 mountpoint = "/";
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }
# { inputs, ... }:
# let
#   hardDriveDefaultsContent = {
#     type = "gpt";
#     partitions = {
#       zfs = {
#         size = "100%";
#         content = {
#           type = "zfs";
#           pool = "zdata";
#         };
#       };
#     };
#   };
#   notToBeTrustedDefaultsContent = {
#     type = "gpt";
#     partitions = {
#       zfs = {
#         size = "100%";
#         content = {
#           type = "zfs";
#           pool = "zdonttrust";
#         };
#       };
#     };
#   };
# in {
#   imports = [ inputs.disko.nixosModules.disko ];
#   disko.devices = {
#     disk = {
#       bootssd = {
#         device = "/dev/disk/by-id/ata-CT250MX500SSD1_2402E88CC199";
#         type = "disk";
#         content = {
#           type = "gpt";
#           partitions = {
#             ESP = {
#               type = "EF00";
#               size = "1024M";
#               content = {
#                 type = "filesystem";
#                 format = "vfat";
#                 mountpoint = "/boot";
#                 mountOptions = [ "umask=0077" ];
#               };
#             };
#             zfs = {
#               size = "100%";
#               content = {
#                 type = "zfs";
#                 pool = "zroot";
#               };
#             };
#           };
#         };
#       };
#       ##########################
#       ## 3TB Drives: -> zdata ##
#       ##########################
#       hardDrive1 = {
#         type = "disk";
#         device = "/dev/disk/by-id/scsi-35000c50056bc3e4f";
#         content = hardDriveDefaultsContent;
#
#       };
#       hardDrive2 = {
#         type = "disk";
#         device = "/dev/disk/by-id/scsi-35000c50085f1ccbf";
#         content = hardDriveDefaultsContent;
#       };
#       hardDrive3 = {
#         type = "disk";
#         device = "/dev/disk/by-id/scsi-35000cca027c69d98";
#         content = hardDriveDefaultsContent;
#       };
#       hardDrive4 = {
#         type = "disk";
#         device = "/dev/disk/by-id/scsi-35000cca0461efe20";
#         content = hardDriveDefaultsContent;
#       };
#       ###############################
#       ## 2TB Drives: -> zdonttrust ##
#       ## These are not numbered in ##
#       ## any particular order      ##
#       ###############################
#       notToBeTrusted1 = { # /dev/sdc
#         type = "disk";
#         device = "/dev/disk/by-id/ata-Hitachi_HDS722020ALA330_JK1174YAHNRW1W";
#         content = notToBeTrustedDefaultsContent;
#
#       };
#       notToBeTrusted2 = { # /dev/sde
#         type = "disk";
#         device = "/dev/disk/by-id/ata-Hitachi_HDS722020ALA330_JK1174YAHNSE8W";
#         content = notToBeTrustedDefaultsContent;
#       };
#       notToBeTrusted3 = { # /dev/sdg
#         type = "disk";
#         device = "/dev/disk/by-id/wwn-0x5000c500e4a3cd99";
#         content = notToBeTrustedDefaultsContent;
#       };
#       notToBeTrusted4 = { # /dev/sdi
#         type = "disk";
#         device = "/dev/disk/by-id/wwn-0x50014ee059b2c2b2";
#         content = notToBeTrustedDefaultsContent;
#       };
#     };
#     zpool = {
#       zroot = {
#         type = "zpool";
#         rootFsOptions = {
#           acltype = "posixacl";
#           compression = "zstd";
#           mountpoint = "none";
#           relatime = "on";
#           xattr = "sa";
#           "com.sun:auto-snapshot" = "false";
#         };
#         options = {
#           ashift = "12";
#           autotrim = "on";
#         };
#         datasets = {
#           root = {
#             type = "zfs_fs";
#             mountpoint = "/";
#           };
#         };
#       };
#       zdata = {
#         type = "zpool";
#         mountpoint = "/storage";
#         mode = {
#           topology = {
#             type = "topology";
#             vdev = [
#               {
#                 mode = "mirror";
#                 members = [
#                   "/dev/disk/by-partlabel/disk-hardDrive1-zfs"
#                   "/dev/disk/by-partlabel/disk-hardDrive2-zfs"
#                 ];
#               }
#               {
#                 mode = "mirror";
#                 members = [
#                   "/dev/disk/by-partlabel/disk-hardDrive3-zfs"
#                   "/dev/disk/by-partlabel/disk-hardDrive4-zfs"
#                 ];
#               }
#             ];
#           };
#         };
#         rootFsOptions = {
#           acltype = "posixacl";
#           compression = "zstd";
#           mountpoint = "none";
#           relatime = "on";
#           xattr = "sa";
#           "com.sun:auto-snapshot" = "false";
#         };
#         options = {
#           ashift = "12";
#           autotrim = "on";
#         };
#         datasets = {
#           mainStorage = {
#             type = "zfs_fs";
#             mountpoint = "/storage/main";
#             options = { compression = "zstd"; };
#           };
#           immich = {
#             type = "zfs_fs";
#             mountpoint = "/storage/immich";
#             options = { compression = "zstd"; };
#           };
#           git = {
#             type = "zfs_fs";
#             mountpoint = "/storage/git";
#             options = { compression = "zstd"; };
#           };
#         };
#       };
#       zdonttrust = {
#         type = "zpool";
#         mountpoint = "/donttrust";
#         mode = {
#           topology = {
#             type = "topology";
#             vdev = [
#               {
#                 mode = "mirror";
#                 members = [
#                   "/dev/disk/by-partlabel/disk-notToBeTrusted1-zfs"
#                   "/dev/disk/by-partlabel/disk-notToBeTrusted2-zfs"
#                 ];
#               }
#               {
#                 mode = "mirror";
#                 members = [
#                   "/dev/disk/by-partlabel/disk-notToBeTrusted3-zfs"
#                   "/dev/disk/by-partlabel/disk-notToBeTrusted4-zfs"
#                 ];
#               }
#             ];
#           };
#         };
#         rootFsOptions = {
#           acltype = "posixacl";
#           compression = "zstd";
#           mountpoint = "/donttrust";
#           relatime = "on";
#           xattr = "sa";
#           "com.sun:auto-snapshot" = "false";
#         };
#         options = {
#           ashift = "12";
#           autotrim = "on";
#         };
#         # datasets = {
#         #   mainStorage = {
#         #     type = "zfs_fs";
#         #     mountpoint = "/storage/main";
#         #     options = { compression = "zstd"; };
#         #   };
#         #   immich = {
#         #     type = "zfs_fs";
#         #     mountpoint = "/storage/immich";
#         #     options = { compression = "zstd"; };
#         #   };
#         #   git = {
#         #     type = "zfs_fs";
#         #     mountpoint = "/storage/git";
#         #     options = { compression = "zstd"; };
#         #   };
#         # };
#       };
#     };
#   };
# }
