# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include my services
      ./services
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "porthos"; # Define your hostname.
  networking.domain = "test.belanyi.fr"; # Define your domain.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.bond0.useDHCP = true;
  networking.interfaces.bonding_masters.useDHCP = true;
  networking.interfaces.dummy0.useDHCP = true;
  networking.interfaces.erspan0.useDHCP = true;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.eth1.useDHCP = true;
  networking.interfaces.gre0.useDHCP = true;
  networking.interfaces.gretap0.useDHCP = true;
  networking.interfaces.ifb0.useDHCP = true;
  networking.interfaces.ifb1.useDHCP = true;
  networking.interfaces.ip6tnl0.useDHCP = true;
  networking.interfaces.sit0.useDHCP = true;
  networking.interfaces.teql0.useDHCP = true;
  networking.interfaces.tunl0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ambroisie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+lrntygUjRA7X6AXRXoV0BMbmZI9bzxR7M++temU1N1WQ7sEGu4zHNIeWaqCKtVbdjvuN5nC8IqC5iV+8KBdT2d+iH165yeEh9mYqSOS9wn0oPr6cSvOZOGqWi7twl0/lrkUxuFl3Qr4gr3Y04PDBK/7JM6+KAS00OOaxhlD9M57TO1lE2Wk6KQWsiyCZe3lczz6MNWUSSRfHOXCCMoiN588hBfdCikNy7Js7+Uz0R/8c86Yn8iu4EpRGpGMJi06KOJi8EPyUvolaeUFpn51IeoD2QcW7Hc3MDyZ+DJj5GV4NQPq46RkMZ7vqEMT+Ix5dJi5kFvnQH3KhJuvNuiXHNbWYqd/o/MbANMRoS2IfRN2jA/NtcFXYXBsRYpKpHhCgzTacY8YxqSJepFOx3vLMVKTXjTrO2IDIjie1y2nhicnzBzglEa3TP2S1FJZdwJzeBfIOWZiMcoIBrxYXdufOpHPjEfQiGETchHJHUxMPX64LxU2bCYfOK36zX8MKCYE1eyt0lRuZZ8s44aQHSIvyYTSnuvgPSAG6Il32J+vnumeTu16ory+WrONO4x395T+OFp0EGXZ4SovVP0mF2ZCxpJX1Vdw0GWkIwsz64E01kGLcYn0bPo+ltAF1tCJ77DvjQS+X92dXIGYKohueT/+A+rfpcB4sW4x57RZZv+gQww== ambroisie@aramis"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8Zns4/86+oz1tdM5E+GKUHcxPuShqcxCrqxCGJ9qgeVkefvnEsRFCbTysjYYUz5d1wPHgazjzyTWQYFrKUOEFbqFhs5vnxEezokGrCPhE61sZ7wIM3gx2S/aCxk7hPmBtdBi624qxa0QdrrKF04ZGDGBvO/bEAuJLqBs9xagS7e0jzwcuOKZVTB9VA15n8aLvC/HuaHTG7SWfMYlD+HfbCBSo8UNjsrTWOFyakHP8zEJEzXD83SBp5q5V7JNiCyYxlTmNLKzCdSBFjoUaqxuiGb4O8YaUh9ttsrhj3CaJUrCqNyY6mvIAXIcyLow+o3h9iWApI1LBEQgP3A9nBTktdOJlv2UUFIb4tjiu6as1dLVJ/iQuym885irIVYHcUaWFVCtIREUU3NMwXGxnAm9E6S/zk2O8hY6QT+YU+03Ll+ctrLLMHrw0Ow/6ryi63trBMN5xl97SHkl2K0XkC2rNgaSiVoziVBi8CKgc2FENkprpJTlHwTQeXAP09m8+bhqpwjhKG1dI/t1y4adr+yvChnOAaAFrMAIP7uXaX8xt/LjYNeZ7+w6O7+kwA2XOE3Ucus+a8AUt+bS8JXmh3Vpwg2SfCmn/AmLsNXrwynelVpYO/t0cZIp1uS3OcUQYxuSO++DI6SiKazE47yP0qxK0qIi9Pm9gX1w6SnE0oQcQ6w== ambroisie@shared-key"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    git-crypt
    mosh
    vim
    wget
  ];

  # List services that you want to enable:
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.mosh.enable = true; # Opens the relevant UDP ports.

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
