{ inputs, ... }:
{
  imports = [
    inputs.rust-flake.flakeModules.default
    inputs.rust-flake.flakeModules.nixpkgs
  ];
  perSystem = { self', pkgs, ... }:
    let
      qs = inputs.quickshell.packages.${pkgs.system}.default.override {
        withWayland = true;
        withHyprland = true;
      };
    in
    {
      apps.default = {
        type = "app";
        program = "${pkgs.writeShellScript "run" ''
          export PATH="${self'.packages.bolcshell-server}/bin:$PATH"
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
      packages.bolcshell = pkgs.writeShellScriptBin "bolcshell" ''
        export PATH="${self'.packages.bolcshell-server}/bin:$PATH"
        exec ${qs}/bin/quickshell -p ${./../../qml} "$@"
      '';
      packages.default = self'.packages.bolcshell;
    };
}
