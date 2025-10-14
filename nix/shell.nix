{ lib
, pkgs
, mkShell

, toolDeps
, toolEnv
}:

mkShell (toolEnv // {
  nativeBuildInputs = toolDeps ++ (with pkgs; [
    vlc
    mpv
    audacity
    blender
  ]);
})
