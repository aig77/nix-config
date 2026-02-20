{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.grub2-themes.nixosModules.default];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Latest stable kernel
    # kernelPackages = pkgs.linuxPackages_zen;

    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        devices = ["nodev"];
      };
      grub2-theme = {
        enable = true;
        theme = "vimix";
        screen = "2k";
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = "lone";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["lone"];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 3;

    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  stylix.targets.grub.enable = false;
  stylix.targets.plymouth.enable = false;
}
