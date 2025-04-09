{
  description = "A Typst project that uses Typst packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    term = {
      url = "github:haennes/term";
      flake = false;
    };

    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    typix,
    flake-utils,
    font-awesome,
    term,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;

      typixLib = typix.lib.${system};

      src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
      (lib.fileset.fromSource (typixLib.cleanTypstSource ./.))
      ./pictures
      ];
      };
      commonArgs = {
        typstSource = "main.typ";

        fontPaths = [
          # Add paths to fonts here
          "${pkgs.roboto-mono}/share/fonts/truetype"
        ];

        virtualPaths = [
          # Add paths that must be locally accessible to typst here
           {
             dest = "icons";
             src = "${font-awesome}/svgs/regular";
           }
            {
               dest = "term";
               src = "${term}";
            }
        ];
      };
      unstable_typstPackages = [

{ name =  "codly";version = "1.3.0"; hash = "sha256-WcqvySmSYpWW+TmZT7TgPFtbEHA+bP5ggKPll0B8fHk=";}
{ name =  "polylux";version = "0.4.0"; hash = "sha256-4owP2KiyaaASS1YZ0Hs58k6UEVAqsRR3YdGF26ikosk=";}
{ name =  "cades";version="0.3.0"; hash = "sha256-2pXkUeY7PHp7Atstt7jK1X1/4wsFJ9uBygxXce/fGN0=";}


{ name =  "metropolis-polylux";version="0.1.0"; hash = "sha256-3ljITD4tYTrO777C/cyI/1KYdgcBQ+F0Ki1X4ze8zG8=";}
{ name =  "jogs";version="0.2.0"; hash = "sha256-hhp43vV9spT2GTGKd5jIPbfydSNLcZEip8xzVaztfss=";}
      ];

      # Compile a Typst project, *without* copying the result
      # to the current directory
      build-drv = typixLib.buildTypstProject (commonArgs
        // {
          inherit src unstable_typstPackages;
        });


      build-pdfpc = typixLib.mkTypstDerivation (commonArgs
        // {
          inherit src unstable_typstPackages;

          buildPhaseTypstCommand = pkgs.writeShellScript "t" ''
          set -xeu
          echo a: $src
          echo b: $out
          echo c: $(pwd)
          echo d: ${src}
          echo e: ${build-drv}
          cp -R ${term} term
          echo "$@"
          ${pkgs.polylux2pdfpc}/bin/polylux2pdfpc --root . ./main.typ
          cp main.pdfpc $out
          '';
        });
      # Compile a Typst project, and then copy the result
      # to the current directory
      build-script = typixLib.buildTypstProjectLocal (commonArgs
        // {
          inherit src unstable_typstPackages;
        });

      # Watch a project and recompile on changes
      watch-script = typixLib.watchTypstProject commonArgs;

      present_fn = opts: pkgs.writeShellScriptBin "typst-present.sh" ''
          ${pkgs.pdfpc}/bin/pdfpc ${opts} ${build-drv} -R ${build-pdfpc}
        '';
      present = present_fn "-s";
      present_mm = present_fn "";
    in {
      checks = {
        inherit build-drv build-script watch-script;
      };

      packages.default = present_mm;
      apps = {
        default = flake-utils.lib.mkApp{
          drv = present;
        };
        build = flake-utils.lib.mkApp {
          drv = build-script;
        };
        watch = flake-utils.lib.mkApp {
          drv = watch-script;
        };
      };

      devShells.default = typixLib.devShell {
        inherit (commonArgs) fontPaths virtualPaths;
        packages = [
          # WARNING: Don't run `typst-build` directly, instead use `nix run .#build`
          # See https://github.com/loqusion/typix/issues/2
          # build-script
          watch-script
          # More packages can be added here, like typstfmt
          # pkgs.typstfmt
        ];
      };
    });
}
