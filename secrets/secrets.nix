let
  system-home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZ7OXf1FWTVDvUWTZToqhjnzi/UvH7y02Gkcc9EXp/x root@nixos";
  systems = [ system-home ];
in
{
  "blahaj-bot-token.age".publicKeys = [ system-home ];
  "surfshark-user-pass.age".publicKeys = [ system-home ];
}
