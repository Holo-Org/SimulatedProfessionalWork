{
  description = "Bootstraps devenv, so that Nix alone is enough";

  # Same nixpkgs as devenv.yaml, so the devenv CLI and the environment it
  # builds come from one lineage.
  inputs.nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      # Nothing but devenv: the environment itself is devenv.nix, one directory
      # up. This flake lives in a subdirectory because Nix copies a flake's
      # whole directory into the store, .devenv included, unless it is inside
      # a Git repository.
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { packages = [ pkgs.devenv ]; };
      });
    };
}
