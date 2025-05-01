{pkgs, ...}: {environment.systemPackages = with pkgs; [gcc wget curl];}
