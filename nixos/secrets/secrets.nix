let
  jasmine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvRKFAgEuo9LjBycUYgn5livHgS+MCcfrJLoDdwG1h9 jasmine@nixos";
  users = [ jasmine ];
  
  system-home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZ7OXf1FWTVDvUWTZToqhjnzi/UvH7y02Gkcc9EXp/x root@nixos";
  systems = [ system-home ];
in
{
  "blahaj-bot-token.age".publicKeys = [ system-home jasmine ];
  "devhaj-bot-token.age".publicKeys = [ system-home jasmine ];
  "surfshark-user-pass.age".publicKeys = [ system-home jasmine ];
  "wifi-pass.age".publicKeys = [ system-home jasmine ];
  "cloudflared-creds.age".publicKeys = [ system-home jasmine ];
  "matrix-registration-token.age".publicKeys = [ system-home jasmine ];
  "streemtech2obs-config.age".publicKeys = [ system-home jasmine ];
}
