{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    nvim.url = "./home-manager/nvim";

    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    sops-nix.url = "github:Mic92/sops-nix";

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    stylix.url = "github:danth/stylix";
    waybar-git.url = "github:Alexays/Waybar";

    nixpkgs-kitty.url = "github:nixos/nixpkgs/0169fd142d9bb36449e432660f0fd9e8d98ecc2c";
  };

  outputs = {
    sops-nix,
    nixpkgs,
    home-manager,
    hyprland,
    nixpkgs-f2k,
    split-monitor-workspaces,
    waybar-git,
    stylix,
    nixpkgs-kitty,
    nixpkgs-stable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    hostname = "nixos";
    timezone = "Europe/Helsinki";
    locale = "en_US.UTF-8";
    username = "kiipuri";
    themeName = "catppuccin-mocha";
    # theme = "gruvbox-light-hard";
    # theme = "uwunicorn";
    # theme = "rose-pine";
    # theme = "rose-pine-moon";
    # theme = "rose-pine-dawn";
    # theme = "sakura";
    # theme = "blueforest";
    # theme = "3024";

    # font = "JetBrainsMono Nerd Font";
    # fontPkg = pkgs.jetbrains-mono;
    font = "Maple Mono";
    fontPkg = pkgs.maple-mono;

    # cursor = "Reimu";
    # cursorPkg = pkgs.callPackage ./home-manager/derivatives/touhou-cursors.nix {};

    cursor = "Bibata-Modern-Ice";
    cursorPkg = pkgs.bibata-cursors;

    pkgs = import nixpkgs {inherit system;};
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      ${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit hostname;
          inherit timezone;
          inherit locale;

          inherit username;
          inherit themeName;
          inherit font;
          inherit fontPkg;
          inherit (inputs) stylix;
          inherit (inputs) nixpkgs-f2k;
        }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [
          ./nixos/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs;
          inherit themeName;
          inherit font;
          inherit fontPkg;
          inherit cursor;
          inherit cursorPkg;
          inherit username;
          inherit hostname;
          inherit (inputs) stylix;
          inherit (inputs) nix-colors;
          inherit (inputs) hyprland;
          inherit (inputs) split-monitor-workspaces;
          pkgs-kitty = import nixpkgs-kitty {inherit system;};
          pkgs-stable = import nixpkgs-stable {inherit system;};
        }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/home.nix
          stylix.homeManagerModules.stylix
          sops-nix.homeManagerModules.sops
        ];
      };
    };
  };
}
