# EasyEffects is managed by the app itself; its live config lives in
# ~/.config/easyeffects/db and is not declared here.
#
# Sane mic default for the Volt on spike / desktop:
#
#   rnnoise  -> gate      -> autogain
#   VAD on      curve -36    outputGain -16
#               attack 5ms
#               release 150ms
#               reduction 4dB
{config, ...}: let
  inherit (config.flake.meta.owner) username;
  hm = config.flake.modules.homeManager;
in {
  flake.modules = {
    nixos.easyeffects = _: {
      home-manager.users.${username}.imports = [hm.easyeffects];
    };

    homeManager.easyeffects = {pkgs, ...}: {
      home.packages = [pkgs.easyeffects];
    };
  };
}
