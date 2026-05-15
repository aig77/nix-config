# See docs/howto/deploying.md for fresh install instructions.
# WARNING: This will DESTROY ALL DATA on the specified devices!
{inputs, ...}: {
  configurations.nixos.jet.module = {
    imports = [inputs.disko.nixosModules.disko];

    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          timeout = 1;
          mirroredBoots = [
            {
              devices = ["nodev"];
              path = "/boot";
              efiSysMountPoint = "/boot";
            }
            {
              devices = ["nodev"];
              path = "/boot/efi-backup";
              efiSysMountPoint = "/boot/efi-backup";
            }
          ];
        };
      };
      initrd = {
        kernelModules = ["dm-mod" "md-mod" "raid1"];
        supportedFilesystems = ["btrfs"];
      };
      # Keep mdadm array config in sync so the initrd can assemble it at boot.
      swraid.mdadmConf = ''
        MAILADDR root
      '';
    };

    disko.devices = {
      disk = {
        nvme0 = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["fmask=0022" "dmask=0022"];
                };
              };
              raid = {
                size = "100%";
                content = {
                  type = "mdraid";
                  name = "data";
                };
              };
            };
          };
        };
        nvme1 = {
          type = "disk";
          device = "/dev/nvme1n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/efi-backup";
                  mountOptions = ["fmask=0022" "dmask=0022"];
                };
              };
              raid = {
                size = "100%";
                content = {
                  type = "mdraid";
                  name = "data";
                };
              };
            };
          };
        };
      };

      mdadm = {
        data = {
          type = "mdadm";
          level = 1;
          content = {
            type = "btrfs";
            extraArgs = ["-f" "-L nixos"];
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "@data" = {
                mountpoint = "/var/lib";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "@log" = {
                mountpoint = "/var/log";
                mountOptions = ["compress=zstd" "noatime"];
              };
            };
          };
        };
      };
    };
  };
}
