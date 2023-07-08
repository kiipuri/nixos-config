{
  pkgs,
  lib,
  ...
}: let
  rofi-shutdown = pkgs.writeShellScript "rofi-shutdown" (builtins.readFile ./scripts/rofi-shutdown);
in
  pkgs.stdenv.mkDerivation rec {
    name = "rofi-shutdown-${version}";
    version = "1.0";

    nativeBuildInputs = [pkgs.makeWrapper];

    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/bin
      cp ${rofi-shutdown} $out/bin/rofi-shutdown
      wrapProgram $out/bin/rofi-shutdown --prefix PATH : ${lib.makeBinPath [pkgs.rofi]} ;
    '';
  }
