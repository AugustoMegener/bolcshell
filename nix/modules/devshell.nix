{ inputs, ... }:
{
  perSystem = { config, self', pkgs, ... }:
    let
      quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        withCrashReporter = true;
        withHyprland = true;
        withI3 = true;
        withJemalloc = true;
        withNetworkManager = true;
        withPam = true;
        withPipewire = true;
        withPolkit = true;
        withQtSvg = true;
        withWayland = true;
      };
      wlr-protocols = pkgs.fetchurl {
        url = "https://gitlab.freedesktop.org/wlroots/wlr-protocols/-/raw/master/unstable/wlr-layer-shell-unstable-v1.xml";
        hash = "sha256-h+C5yDeuzWl39288R9cwiLcVmHH12XncGED2ytteLtg=";
      };

      xkb-monitor = pkgs.stdenv.mkDerivation {
        name = "xkb-monitor";
        src = inputs.xkb-monitor;
        buildInputs = with pkgs; [ wayland libxkbcommon wayland-protocols ];
        nativeBuildInputs = with pkgs; [ pkg-config wayland-scanner ];
        preBuild = ''
          cp ${wlr-protocols} wlr-layer-shell-unstable-v1.xml
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp xkb-monitor $out/bin/
        '';
      };
    in
    {
      devShells.default = pkgs.mkShell {
        name = "primary-shell";
        inputsFrom = [
          self'.devShells.rust
          config.pre-commit.devShell
        ];
        packages = with pkgs; [
          just
          nixd
          bacon
          quickshell
          libxkbcommon
          xkb-monitor
          qt6.qtdeclarative
          qt6.qt5compat
          qt6.qtshadertools
        ];
        shellHook = ''
          export QML2_IMPORT_PATH="${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${quickshell}/lib/qt-6/qml:${pkgs.qt6.qt5compat}/lib/qt-6/qml"
          export QML_IMPORT_PATH="$QML2_IMPORT_PATH"
          export PATH="$PWD/.bin:$PATH"
          export QMLLS_BUILD_DIRS=/nix/store/lwa1k7ni8d4ljj44mzzlagk4qnngrsr8-qtdeclarative-6.11.0/lib/qt-6/qml/
          mkdir -p $PWD/.bin
          printf '#!/bin/sh\nexec ${pkgs.qt6.qtdeclarative}/bin/qmlls -E "$@"\n' > $PWD/.bin/qmlls
          chmod +x $PWD/.bin/qmlls
        '';
      };
    };
}
