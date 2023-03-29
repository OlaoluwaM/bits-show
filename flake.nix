{
  description = "bits-show";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    let packageName = "bits-show";
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkgsUnstable = import nixpkgs-unstable { inherit system; };

        project = pkgs.haskellPackages.developPackage {
          root = ./bits-show;
          name = packageName;
        };

        inherit (pkgs.lib) fold composeExtensions concatMap attrValues;

        combineOverrides = old:
          fold composeExtensions (old.overrides or (_: _: { }));

      in {
        defaultPackage = self.packages.${system}.${packageName};

        packages = {
          "${packageName}" = project;

          testConfigurations = let

            inherit (pkgs.haskell.lib) dontCheck;
            makeTestConfiguration = let defaultPkgs = pkgs;
            in { pkgs ? defaultPkgs, ghcVersion, overrides ? new: old: { } }:
            let inherit (pkgs.haskell.lib) dontCheck packageSourceOverrides;
            in (pkgs.haskell.packages.${ghcVersion}.override (old: {
              overrides = combineOverrides old [
                (packageSourceOverrides { bits-show = ./bits-show; })
                overrides
              ];
            })).bits-show;
          in rec {
            ghc-9-2 = makeTestConfiguration { ghcVersion = "ghc92"; };
            ghc-9-4 = makeTestConfiguration { ghcVersion = "ghc94"; };
            ghc-9-6 = makeTestConfiguration {
              ghcVersion = "ghc96";
              pkgs = pkgsUnstable;
              overrides = new: old: {
                primitive = dontCheck (new.callPackage ./nix/primitive.nix { });
                quickcheck-classes-base = dontCheck
                  (new.callPackage ./nix/quickcheck-classes-base.nix { });
                tagged = dontCheck (new.callPackage ./nix/tagged.nix { });
              };
            };
            all = pkgs.symlinkJoin {
              name = "bits-show";
              paths = [ ghc-9-2 ghc-9-4 ghc-9-6 ];
            };
          };
        };
      });
}
