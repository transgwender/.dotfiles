
{ config, pkgs, ... }:

{
  networking.nat.enable = true;

  networking.nftables = {
    ruleset = ''
      table inet vpn-nat {
        chain postrouting {
          type nat hook postrouting priority 100; policy accept;
          iifname "ve-vpn" oifname "mv0" counter masquerade
        }
      }
    '';
  };

  containers.vpn = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.13";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::4";

    config = { config, pkgs, lib, ... }: {
      system.stateVersion = "24.11";

      networking = {
        enableIPv6 = true;
        nameservers = [ "10.64.0.1" ];
      };
    };
  };
}
