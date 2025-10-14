let
  nixpkgsFn = import ./nixpkgs.nix;

  pkgs = nixpkgsFn {
    overlays = [
      (import ./overlay.nix)
    ];
  };

  toolDeps = with pkgs; [
    ffmpeg
    sox-with-mp3
    yt-dlp
    python3Packages.demucs
    python3Packages.python
    gnumake
  ];

  toolEnv = with pkgs; {
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [
        freefont_ttf
      ];
    };
  };

in rec {
  inherit
    pkgs
  ;

  tool = pkgs.callPackage ./tool.nix {
    inherit toolDeps toolEnv;
  };

  shell = pkgs.callPackage ./shell.nix {
    inherit toolDeps toolEnv;
  };
}
