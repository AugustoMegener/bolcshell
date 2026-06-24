import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland

Scope {
  required property ShellScreen screen

  PanelWindow {
    id: borderWindow

    property bool hasTiledWindow: {
      const ws = Hyprland.focusedMonitor?.activeWorkspace
      if (!ws) return false
      return ws.toplevels.values.some(w => !w.floating && !w.fullscreen)
    }

    WlrLayershell.namespace: "border"
    aboveWindows: false
    WlrLayershell.layer: WlrLayershell.Layer.Bottom
    WlrLayershell.exclusionMode: ExclusionMode.Normal
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    screen: parent.screen
    color: "transparent"
    surfaceFormat.opaque: false
    anchors { top: true; bottom: true; left: true; right: true }

    mask: Region {}
Component.onCompleted: {
    Quickshell.execDetached(["hyprctl", "keyword", "layerrule[noanim_border]:no_anim on"])
    Quickshell.execDetached(["hyprctl", "keyword", "layerrule[noanim_border]:match:namespace border"])
}
    ShaderEffect {
      anchors.fill: parent
      enabled: false
      fragmentShader: Qt.resolvedUrl("../assets/shaders/border.frag.qsb")
      property real thickness: borderWindow.hasTiledWindow? 9999 : 10.5
      property real innerRadius: 15
      property real w: width
      property real h: height
      property color borderColor: "#2b2622"
      property real innerThickness: 1
      property color innerColor: borderWindow.hasTiledWindow? "#2b2622" : "#3d332a"
      property real shadowSize: 35
      property color shadowColor: "#BF1f1914"
    }
  }

  PanelWindow {
    WlrLayershell.namespace: "border-exclusion-top"
    WlrLayershell.exclusionMode: ExclusionMode.Normal
    screen: parent.screen
    color: "transparent"
    anchors { top: true; left: true; right: true }
    implicitHeight: 3
    mask: Region {}
  }

  PanelWindow {
    WlrLayershell.namespace: "border-exclusion-bottom"
    WlrLayershell.exclusionMode: ExclusionMode.Normal
    screen: parent.screen
    color: "transparent"
    anchors { bottom: true; left: true; right: true }
    implicitHeight: 3
    mask: Region {}
  }

  PanelWindow {
    WlrLayershell.namespace: "border-exclusion-left"
    WlrLayershell.exclusionMode: ExclusionMode.Normal
    screen: parent.screen
    color: "transparent"
    anchors { top: true; bottom: true; left: true }
    implicitWidth: 3
    mask: Region {}
  }

  PanelWindow {
    WlrLayershell.namespace: "border-exclusion-right"
    WlrLayershell.exclusionMode: ExclusionMode.Normal
    screen: parent.screen
    color: "transparent"
    anchors { top: true; bottom: true; right: true }
    implicitWidth: 3
    mask: Region {}
  }
}
