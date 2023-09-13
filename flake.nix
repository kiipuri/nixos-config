{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    mynvim.url = "./home-manager/nvim";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "github:hyprwm/Hyprland";
    waybar-git.url = "github:Alexays/Waybar";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    hyprland,
    waybar-git,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    unstable = import nixpkgs-unstable {inherit system;};
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;}; # Pass flake inputs to our config
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
        extraSpecialArgs = {inherit inputs unstable;}; # Pass flake inputs to our config
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
