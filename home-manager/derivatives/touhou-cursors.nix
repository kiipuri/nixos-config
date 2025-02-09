{
  stdenv,
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}: let
  xcur2png = import ./xcur2png.nix {inherit lib stdenv pkgs fetchFromGitHub;};
in
  pkgs.stdenv.mkDerivation rec {
    name = "touhou-cursors";
    version = "1.0";
    src = fetchFromGitHub {
      owner = "mabequinho";
      repo = "touhou-cursors";
      rev = "5a01773bbf74e72a19c0c80a36799127a69818d7";
      sha256 = "sha256-mzDFFF8+ayq0jYUK8lrcBvmy+Pp59aOpufTmds/259o=";
    };

    nativeBuildInputs = [pkgs.hyprcursor xcur2png];

    phases = "installPhase";

    installPhase = ''
      mkdir -p $out/share/icons
      cp -rf $src/* $out/share/icons/

      chmod -R +w $out
      rm $out/share/icons/README.md

      cd $out/share/icons
      for cursor in *; do
        hyprcursor-util -x $cursor > /dev/null
        rm -rf $cursor

        hyprcursor-util --create "extracted_$cursor" > /dev/null
        rm -rf "extracted_$cursor"
        mv "theme_Extracted Theme" "$cursor-hypr"
      done
    '';
  }
