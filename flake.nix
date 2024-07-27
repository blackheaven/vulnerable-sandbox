{
  description = "dummy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskellPackages;
      in
      rec
      {
        packages.dummy = haskellPackages.callCabal2nix "dummy" ./. { };

        defaultPackage = packages.dummy;

        devShell =
          pkgs.mkShell {
            buildInputs = with haskellPackages; [
              cabal-install
            ];
            inputsFrom = [
              self.defaultPackage.${system}.env
            ];
          };
      });
}
