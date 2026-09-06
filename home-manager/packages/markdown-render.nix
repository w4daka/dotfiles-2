# packages/markdown-reader.nix
{ pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "markdown-reader";
  version = "1.35.1";

  src = pkgs.fetchFromGitHub {
    owner = "leboiko";
    repo = "markdown-reader";
    rev = "v1";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    homepage = "https://github.com/leboiko/markdown-reader";
    license = pkgs.lib.licenses.mit;
    mainProgram = "markdown-reader";
  };
  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
  '';

}
