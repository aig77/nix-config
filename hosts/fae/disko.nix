/*
Disko configuration for fae desktop - FRESH INSTALLATION ONLY

This file is used ONLY for fresh NixOS installations. It automates disk
partitioning, formatting, and mounting during the initial install.

After installation, the system will have your full flake configuration applied.
For subsequent updates, just use: sudo nixos-rebuild switch --flake .#fae

INSTALLATION STEPS:

  1. Boot NixOS installer ISO

  2. Identify your disk device:
     lsblk
     (common examples: /dev/nvme0n1, /dev/sda, /dev/vda)

  3. Clone this repository:
     git clone <your-repo-url> ~/nix-config
     cd ~/nix-config

  4. Run disko to partition, format, and mount (DESTROYS ALL DATA):
     sudo nix --extra-experimental-features "nix-command flakes" run \
       github:nix-community/disko -- \
       --mode disko \
       ./hosts/fae/disko.nix \
       --arg device '"/dev/nvme0n1"'

  5. Install NixOS from your flake:
     sudo nixos-install --flake .#fae

  6. Set root password when prompted, then reboot:
     reboot

Your system will boot with the full configuration from this flake already applied!

WARNING: Step 4 will DESTROY ALL DATA on the specified device!
*/
{device, ...}: {
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
