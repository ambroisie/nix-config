# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  my = config.my;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include my secrets
      ./secrets
      # Include my services
      ./services
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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

  users.mutableUsers = false; # I want it to be declarative.

  # Define user accounts and passwords.
  users.users.root.hashedPassword = my.secrets.users.root.hashedPassword;
  users.users.ambroisie = {
    hashedPassword = my.secrets.users.ambroisie.hashedPassword;
    description = "Bruno BELANYI";
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = with builtins; let
      contents = readDir ./ssh;
      names = attrNames contents;
      files = filter (name: contents.${name} == "regular") names;
      keys = map (basename: readFile (./ssh + "/${basename}")) files;
    in
    keys;
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
  my.services = {
    # Gitea forge
    gitea.enable = true;
    # Meta-indexers
    indexers = {
      jackett.enable = true;
      nzbhydra.enable = true;
    };
    # Jellyfin media server
    jellyfin.enable = true;
    # Matrix backend and Element chat front-end
    matrix = {
      enable = true;
      secret = my.secrets.matrix.secret;
    };
    # Nextcloud self-hosted cloud
    nextcloud = {
      enable = true;
      password = my.secrets.nextcloud.password;
    };
    # The whole *arr software suite
    pirate.enable = true;
    # Regular backups
    postgresql-backup.enable = true;
    # An IRC client daemon
    quassel.enable = true;
    # RSS provider for websites that do not provide any feeds
    rss-bridge.enable = true;
    # Usenet client
    sabnzbd.enable = true;
    # Torrent client and webui
    transmission = {
      enable = true;
      username = "Ambroisie";
      password = my.secrets.transmission.password;
    };
  };

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

  nixpkgs.config.allowUnfree = true; # Because I don't care *that* much.
}
