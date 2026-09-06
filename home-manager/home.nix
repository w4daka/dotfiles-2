{
  config,
  pkgs,
  inputs,
  ...
}:
let
  markdown-render = pkgs.callPackge ./packages/markdown-render.nix { };
in
{
  home.username = "w4daka";
  home.homeDirectory = "/home/w4daka";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    starship
    zoxide
    fzf
    sheldon
    git

    ripgrep
    fd
    jq
    lazygit
    ghq
    lazydocker
    devcontainer
    eza
    vim-startuptime
    gh

    nixd
    nixfmt
    bat
    direnv
    nix-direnv
    repomix
    uv
    clang-tools
    just
    lldb

    lua-language-server
    stylua
    luaPackages.luacheck

    deno
    prettierd
    markdown-render
  ];

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
  programs.markdown-render = {
    enable = true;
    package = inputs.markdown-render.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  home.file = {
    ".gitconfig".source = ./git/.gitconfig;
  };

  xdg.configFile."nvim".source = ./nvim;

  programs.home-manager.enable = true;
}
