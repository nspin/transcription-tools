{ fetchFromGitHub
, lame-static
}:

final: prev: with final;

{

  demucs = buildPythonPackage rec {
    name = "demucs";
    src = fetchFromGitHub {
      repo = name;
      owner = "adefossez";
      rev = "b9ab48cad45976ba42b2ff17b229c071f0df9390";
      hash = "sha256-FkN7wIiO6xSYoAQBQHdxY92fV+1q3dvUPQu//oqhRhc=";
    };
    postPatch = ''
      substituteInPlace requirements_minimal.txt \
        --replace-fail 'torchaudio>=0.8,<2.2' 'torchaudio>=0.8'
    '';
    pyproject = true;
    dependencies = [
      dora-search
      einops
      julius
      lameenc
      openunmix
      pyyaml
      torch
      torchaudio
      tqdm
    ];
  };

  dora-search = buildPythonPackage rec {
    pname = "dora_search";
    version = "0.1.12";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-KVb9LEx+S5pIMOg/DUz5Yb5Fz7oaLwVwKB6R0VrFFvs=";
    };
    pyproject = true;
    dependencies = [
      hydra-core
      pytorch-lightning
      submitit
      torch
      retrying
      treetable
    ];
  };

  submitit = buildPythonPackage rec {
    pname = "submitit";
    version = "1.5.3";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-0cvF2IWbUZseR63EqqYAHc7+ioNfMDKxUcs959KEEGg=";
    };
    pyproject = true;
    build-system = [ setuptools wheel ];
    dependencies = [
      cloudpickle
      typing-extensions
      flit
    ];
  };

  treetable = buildPythonPackage rec {
    pname = "treetable";
    version = "0.2.6";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-fh1i285QP78kVhruFGG4+8wsIy/0VmHDudDCCBx5W98=";
    };
    pyproject = true;
    build-system = [ setuptools ];
  };

  openunmix = buildPythonPackage rec {
    pname = "openunmix";
    version = "1.3.0";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-zJJFznKHAPXQtyxn8BvkFid35hfNxH+bA1ljr6wYD8g=";
    };
    pyproject = true;
    dependencies = [
      numpy
      torchaudio
      torch
      tqdm
    ];
  };

  lameenc = buildPythonPackage rec {
    pname = "lameenc";
    version = "1.8.1";
    src = fetchFromGitHub {
      repo = pname;
      owner = "chrisstaite";
      rev = "v${version}";
      hash = "sha256-/GV18mPcru1raFfFQGSAHgNwpmwN4oVFKcBL4JjZkC8=";
    };
    postPatch = ''
      substituteInPlace setup.py \
        --replace-fail 'libdir = None' 'libdir = "--libdir=${lame-static.lib}/lib"' \
        --replace-fail 'incdir = None' 'incdir = "--incdir=${lame-static}/include/lame"' \
        --replace-fail 'sys.argv.remove(libdir)' "" \
        --replace-fail 'sys.argv.remove(incdir)' ""
    '';
    pyproject = true;
    build-system = [ setuptools-scm wheel ];
  };

}
