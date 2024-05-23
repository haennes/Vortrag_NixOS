{ config, pkgs, ...}:{
  imports = [./hardware-configuration.nix ];
  bootl.loader.grub.enable = true;
  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  sound.enable = true;
  users.users.hannses = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
    ];
  };
  environment.systemPackages = with pkgs; [
    gcc
  ];
}
