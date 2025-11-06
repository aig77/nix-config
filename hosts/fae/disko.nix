/*
Disko configuration for fae desktop - FRESH INSTALLATION ONLY

This file defines disk partitioning for fresh NixOS installations.
It's exposed as a separate 'diskoConfigurations.fae' output in flake.nix.

After installation, nixosConfigurations.fae uses hardware-configuration.nix,
so this file is only used during initial installation.

INSTALLATION STEPS:

  1. Boot NixOS installer ISO

  2. Identify your disk device:
     lsblk
     (common examples: /dev/nvme0n1, /dev/sda, /dev/vda)

  3. Clone this repository:
     git clone <your-repo-url> ~/nix-config
     cd ~/nix-config

  4. Partition, format, and mount (DESTROYS ALL DATA):
     sudo nix run github:nix-community/disko -- \
       --mode disko \
       --flake .#fae \
       --arg device '"/dev/nvme0n1"'

     NOTE: Replace /dev/nvme0n1 with your actual disk device from step 2
     The --arg device parameter is REQUIRED - defaults to /dev/null for safety

  5. Install NixOS with your flake:
     sudo nixos-install --flake .#fae --no-root-passwd

  6. Set root password:
     sudo nixos-enter --root /mnt -c 'passwd'

  7. Reboot:
     reboot

Your system will boot with hardware-configuration.nix for filesystem mounts.
Future rebuilds work normally - no device parameter needed!

WARNING: Step 4 will DESTROY ALL DATA on the specified device!
*/
{device ? "/dev/null", ...}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        inherit device;
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
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            root = {
              size = "100%";
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
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "@cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
