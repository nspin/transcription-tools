{ lib
, makeFontsConf
, buildLua
, materialDesignIconicFont

, toolsDir
}:

buildLua {
  pname = "mpv-tt-loop";
  version = "0.0.1";

  dontUnpack = true;
  scriptPath = "${toolsDir + "/mpv-loop"}";

  passthru.extraWrapperArgs = [
    "--set"
      "FONTCONFIG_FILE"
      (toString (makeFontsConf {
        fontDirectories = [
          "${materialDesignIconicFont}/share/fonts"
        ];
      }))
  ];
}
