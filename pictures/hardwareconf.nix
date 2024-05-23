{config, lib, ...}:{
boot.initrd.availableKernelModules = [ "nvme" "xhci_pci"];
boot.kernelModules = [ "kvm-amd" "amdgpu"]; 
fileSystems."/" =
{ device = "/dev/disk/by-uuid/c4a7f0..4b389";
  fsType = "ext4";
};
fileSystems."/boot" =
{ device = "/dev/disk/by-uuid/80..77";
  fsType = "vfat";
};
networking.useDHCP = lib.mkDefault true;
nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
