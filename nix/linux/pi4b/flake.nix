{
  description = "pi4b Linux user environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    dto-linux-base.url = "path:../base";
    dto-linux-base.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, dto-linux-base, ... }:
    let
      supportedSystems = [
        "armv7l-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      extraPackages = pkgs: [
      ];
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.buildEnv {
            name = "dto-linux-pi4b";
            paths = [
              dto-linux-base.packages.${system}.default
            ] ++ extraPackages pkgs;
          };
        });
    };
}
