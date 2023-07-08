{
  pkgs,
  lib,
  ...
}: let
  screenshot = pkgs.writeShellScript "screenshot" (builtins.readFile ./scripts/screenshot);
in
  pkgs.stdenv.mkDerivation rec {
    name = "screenshot-${version}";
    version = "1.0";

    nativeBuildInputs = [pkgs.makeWrapper];

    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/bin
      cp ${screenshot} $out/bin/screenshot
      wrapProgram $out/bin/screenshot --prefix PATH : ${lib.makeBinPath [pkgs.maim pkgs.copyq]} ;
    '';
  }
