{ lib
, makeFontsConf
, buildLua
, materialDesignIconicFont

, uosc

, toolsDir
}:

buildLua {
  pname = "mpv-tt-loop";
  version = "0.0.1";

  dontUnpack = true;
  # scriptPath = "${toolsDir + "/mpv-loop"}";
  scriptPath = "${toolsDir + "/mpv-loop-uosc"}";

  passthru.extraWrapperArgs = [
    "--set"
      "FONTCONFIG_FILE"
      (toString (makeFontsConf {
        fontDirectories = [
          "${materialDesignIconicFont}/share/fonts"
          "${uosc}/share/fonts"
        ];
      }))
    "--set"
      "MPV_UOSC_ZIGGY"
      (lib.getExe' uosc.tools "ziggy")
  ];
}
