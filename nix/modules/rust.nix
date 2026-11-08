{ inputs, ... }:
{
  imports = [
    inputs.rust-flake.flakeModules.default
    inputs.rust-flake.flakeModules.nixpkgs
  ];
  perSystem = { self', pkgs, lib, ... }:
    let
      qs = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        withWayland = true;
        withHyprland = true;
      };
      qmlImportPath = pkgs.lib.makeSearchPath "lib/qt-6/qml" [
        pkgs.qt6.qt5compat
      ];
    in
    {
      apps.default = {
        type = "app";
        program = "${pkgs.writeShellScript "run" ''
          export PATH="${self'.packages.bolcshell-server}/bin:$PATH"
          export QML2_IMPORT_PATH="${qmlImportPath}:$QML2_IMPORT_PATH"
          exec ${qs}/bin/quickshell -p ${./../../qml}
        ''}";
      };
      rust-project.crates."primary-shell".crane.args = {
        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];
      };
      packages.bolcshell-server = pkgs.symlinkJoin {
        name = "bolcshell-server";
        paths = [ self'.packages.primary-shell ];
        postBuild = ''
          mv $out/bin/primary-shell $out/bin/bolcshell-server
        '';
      };
      packages.bolcshell-bin = pkgs.writeShellScriptBin "bolcshell" ''
        export PATH="${self'.packages.bolcshell-server}/bin:$PATH"
        export QML2_IMPORT_PATH="${qmlImportPath}:$QML2_IMPORT_PATH"
        exec ${qs}/bin/quickshell -p ${./../../qml} "$@"
      '';
      packages.bolcshell-greeter = pkgs.writeShellScriptBin "bolcshell-greeter" ''
        export PATH="${self'.packages.bolcshell-server}/bin:$PATH"
        export QML2_IMPORT_PATH="${qmlImportPath}:$QML2_IMPORT_PATH"
        exec ${qs}/bin/quickshell -p ${./../../qml}/greetd.qml "$@"
      '';
      packages.bolcshell = pkgs.symlinkJoin {
        name = "bolcshell";
        paths = [
          self'.packages.bolcshell-bin
          self'.packages.bolcshell-greeter
          self'.packages.bolcshell-server
        ];
      };
      packages.default = self'.packages.bolcshell;
      devShells.default = lib.mkForce (pkgs.mkShell {
        name = "primary-shell-env";
        inputsFrom = [ self'.devShells.rust ];
        packages = [ self'.packages.bolcshell ];
      });
    };
}
