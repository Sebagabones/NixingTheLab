## It had to happen one day

Well, another person has fallen to Nix I guess. This is my attempt at setting up the homelab with NixOS, what could go wrong. 

#### Commands to build:
`nix run github:nix-community/nixos-anywhere -- --flake .#<flakeName> <user>@<hostname>`

`nix run '.' --show-trace -- --list-all` (pretty self explanatory)

