{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
    term = {
      url = "github:haennes/term";
      flake = false;
    };
    # Example of downloading icons from a non-flake source
    # font-awesome = {
    #   url = "github:FortAwesome/Font-Awesome";
    #   flake = false;
    # };
  };

  outputs = inputs@{ nixpkgs, typix, flake-utils, font-awesome, term, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        typstPackagesSrc = pkgs.symlinkJoin {
          name = "typst-packages-src";
          paths = [
            "${inputs.typst-packages}/packages"
          ];
        };
        # You can use this if you only need to use official packages
        # typstPackagesSrc = "${inputs.typst-packages}/packages";

        typstPackagesCache = pkgs.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = typstPackagesSrc;
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out/typst/packages"
            cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
          '';
        };

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
        #typstDest = "main.pdf";
        commonArgs = {
          typstSource = "main.typ";
          typstOutput = "main.pdf";

          fontPaths = [
            # Add paths to fonts here
            # "${pkgs.roboto}/share/fonts/truetype"
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

        # Compile a Typst project, *without* copying the result
        # to the current directory
        build-drv = typixLib.buildTypstProject (commonArgs // {
          inherit src;
          XDG_CACHE_HOME = typstPackagesCache;
        });

        # Compile a Typst project, and then copy the result
        # to the current directory
        build-script = typixLib.buildTypstProjectLocal (commonArgs // {
          inherit src;
          XDG_CACHE_HOME = typstPackagesCache;
        });

        # Watch a project and recompile on changes
        watch-script = typixLib.watchTypstProject (commonArgs // {
          #typstWatchCommand = "${pkgs.typst-live}/bin/typst-live";
          typstWatchCommand = pkgs.writeShellScript "typst-live.sh" ''
          ${pkgs.typst-live}/bin/typst-live ${commonArgs.typstSource} --port 6001
          '';
        });

         present-script = typixLib.watchTypstProject (commonArgs // {
          #typstWatchCommand = "${pkgs.typst-live}/bin/typst-live";
          typstWatchCommand = pkgs.writeShellScript "typst-present.sh" ''
          ${pkgs.typst}/bin/typst compile ${commonArgs.typstSource}
          ${pkgs.pdfpc}/bin/pdfpc -s ${commonArgs.typstOutput}
          '';
          });
         present-script-multi-monitor = typixLib.watchTypstProject (commonArgs // {
          #typstWatchCommand = "${pkgs.typst-live}/bin/typst-live";
          typstWatchCommand = pkgs.writeShellScript "typst-present.sh" ''
          ${pkgs.typst}/bin/typst compile ${commonArgs.typstSource}
          ${pkgs.pdfpc}/bin/pdfpc ${commonArgs.typstOutput}
          '';
          });


      in {
        checks = { inherit build-drv build-script watch-script; };

        packages.default = build-drv;

        apps = rec {
          default = present;
          build = flake-utils.lib.mkApp { drv = build-script; };
          watch = flake-utils.lib.mkApp { drv = watch-script; };
          present = flake-utils.lib.mkApp {drv = present-script;};
          present-mm = flake-utils.lib.mkApp {drv = present-script-multi-monitor;};
        };

        devShells.default = typixLib.devShell {
          inherit (commonArgs) fontPaths virtualPaths;
          packages = [
            # WARNING: Don't run `typst-build` directly, instead use `nix run .#build`
            # See https://github.com/loqusion/typix/issues/2
            # build-script
            watch-script
            present-script
            # More packages can be added here, like typstfmt
            # pkgs.typstfmt
          ];
        };
      });
}
