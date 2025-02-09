{ config, pkgs, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
    komacv xstring;
  });
in
{
  home.packages = with pkgs; [
    tex
  ];
}
