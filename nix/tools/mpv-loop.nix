{ lib
, makeFontsConf
, buildLua
, materialDesignIconicFont

, uosc

, toolsDir

, runCommand
}:

let
  dir = "${toolsDir + "/from-uosc"}";

  copied = runCommand "x" {} ''
    mkdir $out
    cp -r ${dir} $out/uosc
  '';
in

buildLua (finalAttrs: {
  pname = "mpv-tt-loop";
  version = "0.0.1";

  dontUnpack = true;
  # scriptPath = "${toolsDir + "/mpv-loop"}";
  # scriptPath = "${toolsDir + "/from-uosc"}";
  # scriptPath = "${uosc}/share/mpv/scripts/uosc";
  scriptPath = "${copied}/uosc";

  postInstall = ''
    cp -r ${uosc}/share/fonts $out/share
  '';

  passthru.extraWrapperArgs = [
    "--set"
      "FONTCONFIG_FILE"
      (toString (makeFontsConf {
        fontDirectories = [
          # "${materialDesignIconicFont}/share/fonts"
          # "${uosc}/share/fonts"
          "${finalAttrs.finalPackage}/share/fonts"
        ];
      }))
    "--set"
      "MPV_UOSC_ZIGGY"
      (lib.getExe' uosc.tools "ziggy")
  ];
})
