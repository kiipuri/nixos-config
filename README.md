# nixos-config

Installation instructions for my nixos config.

First create hardware-configuration.nix:

```
sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix
```

Then install home-manager:

```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

Finally switch to nixos and home-manager configs:

```
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#kiipuri@nixos
```
