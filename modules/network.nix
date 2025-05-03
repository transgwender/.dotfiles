
{ pkgs, ... }:

{

  # Enable tailscale
  services.tailscale.enable = true;
  networking.nftables.enable = true;

  # WireGuard
  # Enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "wlp4s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o wlp4s0 -j MASQUERADE
      '';

      # Path to the private key file.
      privateKeyFile = "/etc/nixos/modules/wireguard-keys/private";
      
      peers = [
        # List of allowed peers.
        { # Gwen Phone
          publicKey = "O6pL3ZbCV+5dJfiZ3WbRbO9yEFvnsZvf7hbjj92Cxlw=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { # Gwen Laptop
          publicKey = "rrSRffjzM2sy3BAMMFUJx0XIBu6evQwvLcOZOzRcBGA=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
}
