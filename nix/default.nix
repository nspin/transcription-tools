let

  nixpkgsFn = import ./nixpkgs.nix;

  pkgs = nixpkgsFn {
    overlays = [
      (import ./overlay.nix)
    ];
  };

in rec {

  inherit pkgs;

  shell = pkgs.callPackage ./shell.nix {};

  # abbreviations
  tt = pkgs.transcriptionTools;
  t = pkgs.ttTransform;
  m = pkgs.ttMpv;

}
