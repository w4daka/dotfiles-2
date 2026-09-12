# packages/markdown-reader.nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "markdown-reader";
  version = "1.35.1+186698caba1f6c4f9932296da03c5599b35408d0";

  src = fetchFromGitHub {
    owner = "leboiko";
    repo = "markdown-reader";
    rev = "186698caba1f6c4f9932296da03c5599b35408d0";
    hash = "sha256-x5aobkVwfXEi71kB6utwyIXrSXRSYTGqqf4ZxKSEpxI";
  };

  cargoHash = "sha256-Ujck42v7CPW2mT5Sa8LKwFc8sHOF8XFl0l68gUmQbw8";

  meta = {
    homepage = "https://github.com/leboiko/markdown-reader";
    license = lib.licenses.mit;
    mainProgram = "markdown-reader";
  };

}
