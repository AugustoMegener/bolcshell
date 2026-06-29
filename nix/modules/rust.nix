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
          export PATH="${self'.packages.primary-shell}/bin:$PATH"
          exec ${qs}/bin/quickshell -p ${./../../qml}
        ''}";
      };
      rust-project.crates."primary-shell".crane.args = {
        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];
      };
      packages.default = self'.packages.primary-shell;
    };
}
