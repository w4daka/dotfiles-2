{
  config,
  pkgs,
  inputs,
  ...
}:

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
    lldb-dap

    lua-language-server
    stylua
    luaPackages.luacheck

    deno
    prettierd
  ];

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  home.file = {
    ".gitconfig".source = ./git/.gitconfig;
  };

  xdg.configFile."nvim".source = ./nvim;

  programs.home-manager.enable = true;
}
