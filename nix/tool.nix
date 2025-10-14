{ lib
, writeShellApplication

, toolDeps
, toolEnv
}:

writeShellApplication {
  name = "foo-tool";
  runtimeInputs = toolDeps;
  runtimeEnv = toolEnv // {
    __FOO_MAKEFILE = ../tool.mk;
  };
  text = ''
    exec python3 ${../tool.py} "$@"
  '';
}
