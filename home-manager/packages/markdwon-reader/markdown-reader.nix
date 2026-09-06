# packages/markdown-reader.nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "markdown-reader";
  version = "1.35.1";

  src = fetchFromGitHub {
    owner = "leboiko";
    repo = "markdown-reader";
    rev = "1.34.75";
    hash = lib.fakeHash;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    homepage = "https://github.com/leboiko/markdown-reader";
    license = lib.licenses.mit;
    mainProgram = "markdown-reader";
  };

}
