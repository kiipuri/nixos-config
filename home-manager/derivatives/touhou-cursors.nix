{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "touhou-cursors";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "mabequinho";
    repo = "touhou-cursors";
    rev = "3b6c885b210e2406d33f3f5c1352a7dfe8b1d75b";
    sha256 = "ND9D395vE/+0UkAto3H+LXCqeLKFpbXtLtNA/cr4/1I=";
  };

  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/share/icons
    cp -rf $src/* $out/share/icons/
  '';
}
