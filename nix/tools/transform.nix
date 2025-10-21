{ lib
, writeShellApplication
, makeFontsConf
, ffmpeg
, sox
, yt-dlp
, python3Packages
, gnumake
, freefont_ttf

, toolsDir
}:

let
  srcDir = toolsDir + "/transform";

in
writeShellApplication {
  name = "tt-transform";
  runtimeInputs = [
    gnumake
    ffmpeg
    sox
    yt-dlp
    python3Packages.demucs
    python3Packages.python
  ];
  runtimeEnv = {
    __TT_TRANSFORM_MAKEFILE = "${srcDir + "/transform.mk"}";
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [
        freefont_ttf
      ];
    };
  };
  text = ''
    exec python3 ${srcDir + "/transform.py"} "$@"
  '';
}
