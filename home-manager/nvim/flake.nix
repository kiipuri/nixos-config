#{
#description = "A very basic flake";
#
#inputs = {
#nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
#nixvim = {
#url = "github:pta2002/nixvim/9fd431366acf7a6cb8e38c9b19a70b6376b16014";
##url = "/home/traxys/Documents/nixvim";
##url = "github:traxys/nixvim?ref=dev";
#inputs.nixpkgs.follows = "nixpkgs";
#};
#neovim-flake = {
#url = "github:neovim/neovim?dir=contrib";
#inputs.nixpkgs.follows = "nixpkgs";
#};
#nixfiles = {
#url = "github:traxys/Nixfiles";
#inputs.nvim-traxys.follows = "/";
#};
#flake-utils.url = "github:numtide/flake-utils";
##nix-colors.url = "github:misterio77/nix-colors";
#
## Plugins in nixpkgs
#"plugin:cmp-buffer" = {
#url = "github:hrsh7th/cmp-buffer";
#flake = false;
#};
#"plugin:cmp-calc" = {
#url = "github:hrsh7th/cmp-calc";
#flake = false;
#};
#"plugin:cmp-nvim-lsp" = {
#url = "github:hrsh7th/cmp-nvim-lsp";
#flake = false;
#};
#"plugin:cmp-path" = {
#url = "github:hrsh7th/cmp-path";
#flake = false;
#};
#"plugin:cmp_luasnip" = {
#url = "github:saadparwaiz1/cmp_luasnip";
#flake = false;
#};
#"plugin:comment-nvim" = {
#url = "github:numtostr/comment.nvim";
#flake = false;
#};
#"plugin:indent-blankline-nvim" = {
#url = "github:lukas-reineke/indent-blankline.nvim";
#flake = false;
#};
#"plugin:lspkind-nvim" = {
#url = "github:onsails/lspkind.nvim";
#flake = false;
#};
#"plugin:lualine-nvim" = {
#url = "github:nvim-lualine/lualine.nvim";
#flake = false;
#};
#"plugin:noice-nvim" = {
#url = "github:folke/noice.nvim";
#flake = false;
#};
##"plugin:nui-nvim" = {
##url = "github:MunifTanjim/nui.nvim";
##flake = false;
##};
#"plugin:null-ls-nvim" = {
#url = "github:jose-elias-alvarez/null-ls.nvim";
#flake = false;
#};
#"plugin:nvim-cmp" = {
#url = "github:hrsh7th/nvim-cmp";
#flake = false;
#};
#"plugin:nvim-lightbulb" = {
#url = "github:kosayoda/nvim-lightbulb";
#flake = false;
#};
#"plugin:nvim-lspconfig" = {
#url = "github:neovim/nvim-lspconfig";
#flake = false;
#};
#"plugin:nvim-notify" = {
#url = "github:rcarriga/nvim-notify";
#flake = false;
#};
#"plugin:nvim-tree-lua" = {
#url = "github:nvim-tree/nvim-tree.lua";
#flake = false;
#};
#"plugin:nvim-treesitter-context" = {
#url = "github:nvim-treesitter/nvim-treesitter-context";
#flake = false;
#};
#"plugin:nvim-treesitter-refactor" = {
#url = "github:nvim-treesitter/nvim-treesitter-refactor";
#flake = false;
#};
#"plugin:plenary-nvim" = {
#url = "github:nvim-lua/plenary.nvim";
#flake = false;
#};
#"plugin:rust-tools-nvim" = {
#url = "github:simrat39/rust-tools.nvim";
#flake = false;
#};
#"plugin:telescope-nvim" = {
#url = "github:nvim-telescope/telescope.nvim";
#flake = false;
#};
#"plugin:telescope-ui-select-nvim" = {
#url = "github:nvim-telescope/telescope-ui-select.nvim";
#flake = false;
#};
#"plugin:trouble-nvim" = {
#url = "github:folke/trouble.nvim";
#flake = false;
#};
#"plugin:vim-matchup" = {
#url = "github:andymass/vim-matchup";
#flake = false;
#};
#"plugin:luasnip" = {
#url = "github:L3MON4D3/LuaSnip";
#flake = false;
#};
#"plugin:nvim-treesitter" = {
#url = "github:nvim-treesitter/nvim-treesitter";
#flake = false;
#};
#"plugin:neo-tree-nvim" = {
#url = "github:nvim-neo-tree/neo-tree.nvim";
#flake = false;
#};
#"plugin:nvim-web-devicons" = {
#url = "github:nvim-tree/nvim-web-devicons";
#flake = false;
#};
#"plugin:popup-nvim" = {
#url = "github:nvim-lua/popup.nvim";
#flake = false;
#};
#"plugin:skim-vim" = {
#url = "github:lotabout/skim.vim";
#flake = false;
#};
#"plugin:tokyonight-nvim" = {
#url = "github:folke/tokyonight.nvim";
#flake = false;
#};
#"plugin:vim-snippets" = {
#url = "github:honza/vim-snippets";
#flake = false;
#};
#"plugin:markdown-preview-nvim" = {
#url = "github:iamcco/markdown-preview.nvim";
#flake = false;
#};
#"plugin:which-key-nvim" = {
#url = "github:folke/which-key.nvim";
#flake = false;
#};
#
## Plugins that are not in nixpkgs
##"new-plugin:vim-headerguard" = {
##url = "github:drmikehenry/vim-headerguard";
##flake = false;
##};
#};
#
#outputs = {
#self,
#nixpkgs,
#nixvim,
#neovim-flake,
#flake-utils,
#...
#} @ inputs:
#flake-utils.lib.eachDefaultSystem (system:
#with builtins; let
#module = {
#imports = [
#./default.nix
#./plugins/lsp-signature.nix
#];
#package = neovim-flake.packages."${system}".neovim.overrideAttrs (oa: {
#patches = builtins.filter (v:
#if pkgs.lib.attrsets.isDerivation v
#then v.name != "use-the-correct-replacement-args-for-gsub-directive.patch"
#else true)
#oa.patches;
#});
#};
#
#inputsMatching = prefix:
#pkgs.lib.mapAttrs'
#(prefixedName: value: {
#name = substring (stringLength "${prefix}:") (stringLength prefixedName) prefixedName;
#inherit value;
#})
#(pkgs.lib.filterAttrs
#(name: _: (match "${prefix}:.*" name) != null)
#inputs);
#
#pkgs = import nixpkgs {
#inherit system;
#overlays = [
#(final: prev: {
#inherit (inputs.nixfiles.packages."${system}") lemminx-bin;
#vimPlugins =
#prev.vimPlugins
#// (pkgs.lib.mapAttrs (
#pname: src:
#prev.vimPlugins."${pname}".overrideAttrs (old: {
#version = src.shortRev;
#src = src;
#})
#) (inputsMatching "plugin"))
#// (
#pkgs.lib.mapAttrs (
#pname: src:
#prev.vimUtils.buildVimPluginFrom2Nix {
#inherit pname src;
#version = src.shortRev;
#}
#) (inputsMatching "new-plugin")
#);
#})
#
#(final: prev: {
#vimPlugins =
#prev.vimPlugins
#// {
#openscad-nvim = prev.vimPlugins.openscad-nvim.overrideAttrs (_: {
#patches = [./patches/openscad_program_paths.patch];
#});
#nvim-treesitter = prev.vimPlugins.nvim-treesitter.overrideAttrs (old: {
#passthru =
#old.passthru
#// {
#withPlugins = f:
#final.vimPlugins.nvim-treesitter.overrideAttrs (_: {
#passthru.dependencies =
#map
#(
#grammar: let
#lib = pkgs.lib;
#name = lib.pipe grammar [
#lib.getName
#
## added in buildGrammar
#(lib.removeSuffix "-grammar")
#
## grammars from tree-sitter.builtGrammars
#(lib.removePrefix "tree-sitter-")
#(lib.replaceStrings ["-"] ["_"])
#];
#in
#pkgs.runCommand "nvim-treesitter-${name}-grammar" {} ''
#mkdir -p $out/parser
#ln -s ${grammar}/parser $out/parser/${name}.so
#''
#)
#(f (tree-sitter.builtGrammars // builtGrammars));
#});
#};
#});
#};
#})
#];
#};
#
#nixvim' = nixvim.legacyPackages."${system}";
#nvim = nixvim'.makeNixvimWithModule {inherit module pkgs;};
#in {
#checks.launch = nixvim.lib."${system}".check.mkTestDerivationFromNvim {
#inherit nvim;
#name = "Neovim Configuration";
#};
#formatter = pkgs.alejandra;
#
#devShells.default = pkgs.mkShell {
#packages = [nvim];
#};
#packages = {
#inherit nvim;
#default = nvim;
#};
#});
#}
{
  description = "neovim flake";

  inputs.nixvim.url = "github:pta2002/nixvim/9fd431366acf7a6cb8e38c9b19a70b6376b16014";
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
