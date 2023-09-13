{
  description = "neovim flake";

  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-utils,
  }: let
    module = {
      imports = [
        ./default.nix
        ./autocmd.nix
        ./plugins/lsp-signature.nix
      ];
    };
  in
    flake-utils.lib.eachDefaultSystem (system: let
      nixvim' = nixvim.legacyPackages."${system}";
      nvim = nixvim'.makeNixvimWithModule {inherit module;};
    in {
      packages = {
        inherit nvim;
        default = nvim;
      };
    });
}
