final: prev: with final;

{

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

}
