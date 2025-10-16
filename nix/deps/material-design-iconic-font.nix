{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "material-design-iconic-font";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "zavoloklom";
    repo = pname;
    rev = version;
    hash = "sha256-YLhBzgTL6kDw6a8Gw2nOt2uP4/mb8EknxfNimGJQaQU=";
  };

  installPhase = ''
    d=$out/share/fonts
    mkdir -p $d
    cp dist/fonts/*.ttf $d
  '';
}
