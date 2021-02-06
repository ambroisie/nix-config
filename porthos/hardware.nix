# Hardware configuration
{ lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d89efc61-6b03-4190-b488-301c919e2431";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/1a261204-2e78-496f-8a8d-d29bfa770306"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
