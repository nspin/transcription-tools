let
  path =
    let
      rev = "9357541098275892a21076628192b9ab0081f423"; # release-25.05
    in
      builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
        sha256 = "sha256:09vd97lbjqb4l2cpjin1ijh2z1bwyhl2in6ax44hrzskwmm3byr5";
      };
in

# let
#   path = ../nixpkgs;
# in

import path
