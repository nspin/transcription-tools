final: prev: with final;

let
  toolsDir = ../tools;

in {

  ttTransform = callPackage ./tools/transform.nix {
    inherit toolsDir;
  };

  ttMpvLoop = mpvScripts.callPackage ./tools/mpv-loop.nix {
    inherit toolsDir;
  };

  # TODO wrapper called bin/tt-mpv
  ttMpv = ttMpvUnwrapped;

  ttMpvUnwrapped =
    let
      config = writeText "x.conf" ''
      '';
    in
      mpv.override {
        scripts = [
          ttMpvLoop
        ] ++ (with mpvScripts; [
          # uosc
          # mpv-osc-modern
          # mpv-osc-tethys
          # modernx
          # modernx-zydezu
          # modernz
        ]);
        extraMakeWrapperArgs = [
          "--add-flags" "--include=${config}"
        ];
      };

  transcriptionTools = buildEnv {
    name = "transcription-tools";
    paths = [
      ttTransform
      ttMpv
    ];
  };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (callPackage ./python-overrides.nix {})
  ];

  lame-static = lame.overrideAttrs {
    configureFlags = (lame.configureFlags or []) ++ [
      "--enable-static"
    ];
  };

  sox-with-mp3 = sox.override {
    enableLame = true;
  };

  materialDesignIconicFont = callPackage ./deps/material-design-iconic-font.nix {};

}
