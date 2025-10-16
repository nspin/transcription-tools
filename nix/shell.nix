{ lib
, pkgs
, mkShell
, makeFontsConf

, ffmpeg
, sox-with-mp3
, yt-dlp
, python3Packages
, gnumake

, freefont_ttf

, vlc
, audacity
, blender

, ttTransform
, ttMpv
}:

mkShell {
  nativeBuildInputs = [
    gnumake
    ffmpeg
    sox-with-mp3
    yt-dlp
    python3Packages.demucs
    python3Packages.python

    vlc
    audacity
    blender

    ttTransform
    ttMpv
  ];
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      freefont_ttf
    ];
  };
}
