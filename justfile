switch:
    doas nixos-rebuild switch --flake .#nixos

hm:
    nh home switch .

theme:
    nix run 'github:fore-stun/flakes#home-manager-specialisation'

hm-update:
    just update-userscripts && just hm ; just theme

update-userscripts:
    update-nix-fetchgit --only-commented ./home-manager/browser/qutebrowser.nix 
