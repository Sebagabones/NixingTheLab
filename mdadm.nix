{ config, lib, pkgs, ... }:

{

    #   # MDADM Array
    #   disk1 = {
    #     device = "/dev/disk/by-id/wwn-0x5000c5005ee8ea37";
    #     type = "disk";
    #     content = {
    #       type = "gpt";
    #       partitions = {
    #         mdadm = {
    #           size = "100%";
    #           content = {
    #             type = "mdraid";
    #             name = "raid10";
    #           };
    #         };
    #       };
    #     };
    #   };

    #   disk2 = {
    #     device = "/dev/disk/by-id/wwn-0x50000394f81b0044";
    #     type = "disk";
    #     content = {
    #       type = "gpt";
    #       partitions = {
    #         mdadm = {
    #           size = "100%";
    #           content = {
    #             type = "mdraid";
    #             name = "raid10";
    #           };
    #         };
    #       };
    #     };
    #   };

    #   disk3 = {
    #     device = "/dev/disk/by-id/wwn-0x5000cca0362a4dd4";
    #     type = "disk";
    #     content = {
    #       type = "gpt";
    #       partitions = {
    #         mdadm = {
    #           size = "100%";
    #           content = {
    #             type = "mdraid";
    #             name = "raid10";
    #           };
    #         };
    #       };
    #     };
    #   };

    #   disk4 = {
    #     device = "/dev/disk/by-id/wwn-0x5000cca07f333d18";
    #     type = "disk";
    #     content = {
    #       type = "gpt";
    #       partitions = {
    #         mdadm = {
    #           size = "100%";
    #           content = {
    #             type = "mdraid";
    #             name = "raid10";
    #           };
    #         };
    #       };
    #     };
    #   };
    };
    # mdadm = {
    #   raid10 = {
    #     level = 10;
    #     content = {
    #       type = "gpt";
    #       partitions = {
    #         primary = {
    #           size = "100%";
    #           content = {
    #             type = "filesystem";
    #             format = "ext4";
    #             mountpoint = "/raid";
    #           };
    #         };
    #       };
    #     };
    #   };
    # };
}
