switch:
    doas nixos-rebuild switch --flake .#nixos

hm:
    nh home switch .

theme:
    nix run 'github:fore-stun/flakes#home-manager-specialisation'

hm-update:
    nh home switch . ; nix run 'github:fore-stun/flakes#home-manager-specialisation'

