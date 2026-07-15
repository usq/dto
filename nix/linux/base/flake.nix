{
  description = "Base Linux user environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "armv7l-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      linuxPackages = pkgs: with pkgs; [
        zsh
        bat
        moor
        delta
        git
        tmux
        neovim
      ];
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.buildEnv {
            name = "dto-linux-base";
            paths = linuxPackages pkgs;
          };
        });
    };
}
