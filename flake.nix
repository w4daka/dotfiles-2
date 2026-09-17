{
  description = "Home Manager configuration of w4daka";

  inputs = {
    # 以下では、どのNixpkgsを参照するか定義する。
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # 以下の部分でHome Managerのソースをどこから取得するかを定義する
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."w4daka" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # moduleとして./home-manager/home.nixを読みこむ
        modules = [
          ./home-manager/home.nix
        ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
