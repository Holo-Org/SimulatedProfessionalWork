{
  description = "Emacs add-on for this project (generated, not tracked)";

  inputs = {
    # Emacs-side packages must match the Emacs binary: use the registry entry
    # that the dotfiles pin to their own nixpkgs.
    emacs-nixpkgs.url = "nixpkgs";
    # Tools (LSP servers, debuggers) must match the project: the skill replaces
    # this URL with the owner/repo/rev found in the project's lock file.
    project-nixpkgs.url = "github:cachix/devenv-nixpkgs/d97234e58d4e90e3bf77c082fc3b546e51200938";
  };

  outputs = { self, emacs-nixpkgs, project-nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAll = f: emacs-nixpkgs.lib.genAttrs systems f;
    in {
      devShells = forAll (system:
        let
          pkgs = emacs-nixpkgs.legacyPackages.${system};
          epkgs = pkgs.emacs-macport.pkgs;
          tools = project-nixpkgs.legacyPackages.${system};

          # --- the part the skill edits --------------------------------------
          elisp    = e: [ e.tuareg e.merlin e.dune ];         # extra Emacs packages
          grammars = g: [ ];                                  # tree-sitter grammars
          packages = [ ];                                     # LSP, debugger, ...
          # -------------------------------------------------------------------

          lisp = pkgs.buildEnv {
            name = "addon-elisp";
            paths = elisp epkgs;
            pathsToLink = [ "/share/emacs" ];
            # keep the directories present even when elisp is empty
            postBuild = "mkdir -p $out/share/emacs/site-lisp $out/share/emacs/native-lisp";
          };
          gram = epkgs.treesit-grammars.with-grammars grammars;

          # nixpkgs installs each Emacs package in site-lisp/elpa/<name>-<version>/,
          # which EMACSLOADPATH does not reach: put those directories on load-path,
          # load their autoloads, then load the add-on's own addon.el.
          init = pkgs.writeText "addon-init.el" ''
            ;;; addon-init.el --- load the add-on's packages, then addon.el  -*- lexical-binding: t; -*-
            (dolist (dir (file-expand-wildcards "${lisp}/share/emacs/site-lisp/elpa/*/"))
              (add-to-list 'load-path (directory-file-name dir))
              (dolist (autoloads (file-expand-wildcards (expand-file-name "*-autoloads.el" dir)))
                (load autoloads nil t)))
            (load (expand-file-name "addon.el" (getenv "EMACS_ADDON_DIR")) nil t)
          '';
        in {
          default = pkgs.mkShell {
            inherit packages;
            shellHook = ''
              export EMACSLOADPATH="${lisp}/share/emacs/site-lisp:''${EMACSLOADPATH-}"
              export EMACSNATIVELOADPATH="${lisp}/share/emacs/native-lisp:''${EMACSNATIVELOADPATH-}"
              export EMACS_ADDON_TREESIT_DIR="${gram}/lib"
              export EMACS_ADDON_DIR="$PWD"
              export EMACS_ADDON_INIT="${init}"
            '';
          };
        });
    };
}
