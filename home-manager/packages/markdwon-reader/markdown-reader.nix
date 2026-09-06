# packages/markdown-reader.nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "markdown-reader";
  version = "master";

  src = fetchFromGitHub {
    owner = "leboiko";
    repo = "markdown-reader";
    rev = "186698caba1f6c4f9932296da03c5599b35408d0";
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;

  meta = {
    homepage = "https://github.com/leboiko/markdown-reader";
    license = lib.licenses.mit;
    mainProgram = "markdown-reader";
  };

}
