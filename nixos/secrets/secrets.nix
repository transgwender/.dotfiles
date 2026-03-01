let
  jasmine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvRKFAgEuo9LjBycUYgn5livHgS+MCcfrJLoDdwG1h9 jasmine@nixos";
  users = [ jasmine ];
  
  system-home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZ7OXf1FWTVDvUWTZToqhjnzi/UvH7y02Gkcc9EXp/x root@nixos";
  systems = [ system-home ];
in
{
  "surfshark-user-pass.age".publicKeys = [ system-home jasmine ];
  "wifi-pass.age".publicKeys = [ system-home jasmine ];
  "cloudflared-creds.age".publicKeys = [ system-home jasmine ];
  "matrix-registration-token.age".publicKeys = [ system-home jasmine ];
  "streemtech2obs-config.age".publicKeys = [ system-home jasmine ];
  "nextcloud-admin-pass.age".publicKeys = [ system-home jasmine ];
  "copyparty-jas-pass.age".publicKeys = [ system-home jasmine ];
  "copyparty-emb-pass.age".publicKeys = [ system-home jasmine ];
  "copyparty-ast-pass.age".publicKeys = [ system-home jasmine ];
  "colonH-token.age".publicKeys = [ system-home jasmine ];
  "git-credentials.age".publicKeys = [ system-home jasmine ];
  "robotgirl-server-interface-config.age".publicKeys = [ system-home jasmine ];
  "blahaj-bot-config.age".publicKeys = [ system-home jasmine ];
  "devhaj-bot-config.age".publicKeys = [ system-home jasmine ];
  "mullvad-key.age".publicKeys = [ system-home jasmine ];
}
