# Networking configuration
{ ... }:

{
  networking.hostName = "porthos"; # Define your hostname.
  networking.domain = "test.belanyi.fr"; # Define your domain.


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
}
