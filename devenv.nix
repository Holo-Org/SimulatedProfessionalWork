{
  pkgs,
  inputs,
  ...
}:

let
  oxcamlPackages = inputs.oxcaml.packages.${pkgs.stdenv.system};

  # Upstream ocamlformat cannot parse OxCaml's syntax extensions.
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_4;
  src = inputs.ocamlformat-oxcaml;
  version = "jane";
  ocamlformat-lib = ocamlPackages.buildDunePackage {
    pname = "ocamlformat-lib";
    inherit src version;
    nativeBuildInputs = [ ocamlPackages.menhir ];
    propagatedBuildInputs = with ocamlPackages; [
      astring
      base
      camlp-streams
      cmdliner
      csexp
      dune-build-info
      either
      fix
      fpath
      menhirLib
      menhirSdk
      ocaml-version
      ocp-indent
      stdio
      uuseg
      uutf
    ];
  };
  ocamlformat = ocamlPackages.buildDunePackage {
    pname = "ocamlformat";
    inherit src version;
    # OCaml 5.4 added out_width to Format.formatter_out_functions.
    postPatch = ''
      substituteInPlace lib/bin_conf/Bin_conf.ml --replace-fail \
        "out_indent= (fun _ -> ()) }" \
        "out_indent= (fun _ -> ()); out_width= (fun _ ~pos:_ ~len -> len) }"
    '';
    buildInputs = [
      ocamlformat-lib
      ocamlPackages.cmdliner
      ocamlPackages.re
    ];
    meta.mainProgram = "ocamlformat";
  };
in
{
  packages = [
    oxcamlPackages.oxcaml
    oxcamlPackages.merlin
    pkgs.opam
    pkgs.dune_3
    ocamlformat
    # camlzip binds the system zlib (opam's conf-zlib) when it is built.
    pkgs.zlib
    pkgs.pkg-config
  ];

  enterTest = ''
    ocamlopt -version | grep --color=auto '+ox'
    dune --version
    command -v ocamlmerlin
    echo 'let f (local_ x) = x' | ocamlformat --enable-outside-detected-project --impl -
    opam --version
    pkg-config --modversion zlib
    # make and gzip come from devenv's stdenv, not from `packages`.
    make --version
    gzip --version | head -n 1 | grep --color=auto '^gzip '
  '';
}
