{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    nvim.url = "./home-manager/nvim";

    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    stylix.url = "github:danth/stylix";
    waybar-git.url = "github:Alexays/Waybar";
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    hyprland,
    nixpkgs-f2k,
    split-monitor-workspaces,
    waybar-git,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stable = import nixpkgs-stable {inherit system;};

    theme = "catppuccin-mocha";
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit stable;
          inherit theme;
          inherit (inputs) stylix;
          inherit (inputs) nixpkgs-f2k;
        }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "kiipuri@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
          inherit stable;
          inherit theme;
          inherit (inputs) stylix;
          inherit (inputs) nix-colors;
        }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/home.nix
          hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
        ];
      };
    };
  };
}
