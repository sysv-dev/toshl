{
  description = "toshl";

  inputs.flake-utils = { url = "github:numtide/flake-utils"; };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = with pkgs; [ (ruby_3_0.withPackages (ps: with ps; [ faraday ])) ];
        toshl = pkgs.stdenv.mkDerivation {
          name = "toshl";
          src = self;
          buildInputs = buildInputs;
          installPhase = "mkdir -p $out/bin; install -t $out/bin toshl";
        };
      in
      rec {
        packages = flake-utils.lib.flattenTree { toshl = toshl; };
        defaultPackage = packages.toshl;
        apps.toshl = flake-utils.lib.mkApp { drv = packages.toshl; };
        defaultApp = apps.toshl;
        devShell = pkgs.mkShell { buildInputs = buildInputs; };
      }
    );
}
