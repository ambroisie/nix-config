# A simple, in-kernel VPN service
#
# Strongly inspired by [1].
# [1]: https://github.com/delroth/infra.delroth.net/blob/master/roles/wireguard-peer.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.wireguard;
  hostName = config.networking.hostName;

  peers = config.my.secrets.wireguard.peers;
  thisPeer = peers."${hostName}";
  otherPeers = lib.filterAttrs (name: _: name != hostName) peers;
in
{
  options.my.services.wireguard = with lib; {
    enable = mkEnableOption "Wireguard VPN service";

    iface = mkOption {
      type = types.str;
      default = "wg";
      example = "wg0";
      description = "Name of the interface to configure";
    };

    port = mkOption {
      type = types.port;
      default = 51820;
      example = 55555;
      description = "Port to configure for Wireguard";
    };

    net = {
      v4 = {
        subnet = mkOption {
          type = types.str;
          default = "10.0.0";
          example = "10.100.0";
          description = "Which prefix to use for internal IPs";
        };
        mask = mkOption {
          type = types.int;
          default = 24;
          example = 28;
          description = "The CIDR mask to use on internal IPs";
        };
      };
      v6 = {
        subnet = mkOption {
          type = types.str;
          default = "fd42:42:42";
          example = "fdc9:281f:04d7:9ee9";
          description = "Which prefix to use for internal IPs";
        };
        mask = mkOption {
          type = types.int;
          default = 64;
          example = 68;
          description = "The CIDR mask to use on internal IPs";
        };
      };
    };
  };


  config.networking = lib.mkIf cfg.enable {
    wireguard.interfaces."${cfg.iface}" = {
      listenPort = cfg.port;
      ips = with cfg.net; with lib; [
        "${v4.subnet}.${toString thisPeer.clientNum}/${toString v4.mask}"
        "${v6.subnet}::${toString thisPeer.clientNum}/${toHexString v6.mask}"
      ];
      # Insecure, I don't care
      privateKey = thisPeer.privateKey;

      peers = lib.mapAttrsToList
        (_: peer: {
          inherit (peer) publicKey;
        } // lib.optionalAttrs (thisPeer ? externalIp) {
          # Only forward from server to clients
          allowedIPs = with cfg.net; [
            "${v4.subnet}.${toString peer.clientNum}/32"
            "${v6.subnet}::${toString peer.clientNum}/128"
          ];
        } // lib.optionalAttrs (peer ? externalIp) {
          # Known addresses
          endpoint = "${peer.externalIp}:${toString cfg.port}";
        } // lib.optionalAttrs (!(thisPeer ? externalIp)) {
          # Forward all traffic to server
          allowedIPs = with cfg.net; [
            "0.0.0.0/0"
            "::/0"
          ];
          # Roaming clients need to keep NAT-ing active
          persistentKeepalive = 10;
        })
        otherPeers;
    } // lib.optionalAttrs (thisPeer ? externalIp) {
      # Setup forwarding on server
      # FIXME: 'eth0' should not hard-coded
      postSetup = with cfg.net; ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${v4.subnet}.0/${toString v4.mask} -o eth0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s ${v6.subnet}::0/${toString v6.mask} -o eth0 -j MASQUERADE
      '';
      postShutdown = with cfg.net; ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${v4.subnet}.0/${toString v4.mask} -o eth0 -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s ${v6.subnet}::0/${toString v6.mask} -o eth0 -j MASQUERADE
      '';
    };

    nat = lib.optionalAttrs (thisPeer ? externalIp) {
      enable = true;
      externalInterface = "eth0"; # FIXME: should not hard-coded
      internalInterfaces = [ cfg.iface ];
    };

    firewall.allowedUDPPorts = lib.optional (thisPeer ? externalIp) cfg.port;
  };
}
