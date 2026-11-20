import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import "./../Misc/CRTFilter"
import "../Theme"
import "../ShellState"

Scope {
  required property ShellScreen screen

  function snapInt(target) {
    var dpr = screen.devicePixelRatio
    for (var i = 0; i < 8; i++) {
      var up = Math.round(target) + i
      var down = Math.round(target) - i
      if (Math.abs((up * dpr) - Math.round(up * dpr)) < 0.01) return up
      if (down > 0 && Math.abs((down * dpr) - Math.round(down * dpr)) < 0.01) return down
    }
    return Math.round(target)
  }


  PanelWindow {
    id: borderWindow

    Connections {
      target: Hyprland
      function onRawEvent(event) {
        console.log("raw", event.name, Date.now())
        if (event.name === "openwindow" || event.name === "closewindow"
        || event.name === "changefloatingmode" || event.name === "movewindow") {
          Hyprland.refreshToplevels()
        }
      }
    }


    WlrLayershell.namespace: "border"
    aboveWindows: false
    WlrLayershell.exclusionMode: ExclusionMode.Normal
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    screen: parent.screen
    color: "transparent"
    surfaceFormat.opaque: false
    anchors { top: true; bottom: true; left: true; right: true }

    mask: Region {}
    Component.onCompleted: {
      Hyprland.refreshToplevels()
      /*Quickshell.execDetached(["hyprctl", "eval", "hl.curve('Linear', { type = 'bezier', points = { {0, 0}, {1, 1} } })"])
       Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'windows', enabled = false, speed = 0, curve = 'Linear' })"])
       Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'windowsMove', enabled = false, speed = 0, curve = 'Linear' })"])
       Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'layers', enabled = false, speed = 0, curve = 'Linear' })"])
       Quickshell.execDetached(["hyprctl", "eval", "hl.layer_rule({ name = 'noanim_sidebar_left', match = { namespace = 'border' }, no_anim = true })"])*/
     }


     property bool hasTiledWindow: {
       const ws = Hyprland.focusedMonitor?.activeWorkspace
       if (!ws) return false
       return ws.toplevels.values.some(w => !w.lastIpcObject?.floating)
     }

     onHasTiledWindowChanged: console.log("hasTiled", hasTiledWindow, Date.now())

     ShaderEffect {
       id: shader
       anchors.fill: parent
       fragmentShader: Qt.resolvedUrl("../assets/shaders/border.frag.qsb")


       visible: !borderWindow.hasTiledWindow

       property real thickness: borderWindow.width / 2
       property real innerRadius: borderWindow.height / 2
       property real w: width
       property real h: height
       property color borderColor: Theme.background
       property real innerThickness: 1
       property color innerColor: borderWindow.hasTiledWindow? "#2b2622" : "#3d332a"
       property real shadowSize: 15
       property color shadowColor: "#BF1f1910"

       states: State {
         name: "open"
         when: !borderWindow.hasTiledWindow && ShellState.started

         PropertyChanges {
           target: shader
           thickness: 10.5
           innerRadius: 12
         }
       }

       transitions: Transition {
         from: ""
         to: "open"

         NumberAnimation {
           property: "thickness"
           duration: 500
           easing.type: Easing.InOutCubic
         }

         NumberAnimation {
           property: "innerRadius"
           duration: 1000
           easing.type: Easing.InOutCubic
         }
       }
     }

     Rectangle {

       anchors.fill: parent
       color: Theme.background

       visible: borderWindow.hasTiledWindow
     }

     CRTFilter {}
   }

   /*PanelWindow {
      WlrLayershell.namespace: "border-exclusion-top"
      WlrLayershell.exclusionMode: ExclusionMode.Normal
      screen: parent.screen
      color: "transparent"
      anchors { top: true; left: true; right: true }
      implicitHeight: snapInt(3)
      mask: Region {}
    }

    PanelWindow {
      WlrLayershell.namespace: "border-exclusion-bottom"
      WlrLayershell.exclusionMode: ExclusionMode.Normal
      screen: parent.screen
      color: "transparent"
      anchors { bottom: true; left: true; right: true }
      implicitHeight: snapInt(3)
      mask: Region {}
    }

    PanelWindow {
      WlrLayershell.namespace: "border-exclusion-left"
      WlrLayershell.exclusionMode: ExclusionMode.Normal
      screen: parent.screen
      color: "transparent"
      anchors { top: true; bottom: true; left: true }
      implicitWidth: snapInt(3)
      mask: Region {}
    }

    PanelWindow {
      WlrLayershell.namespace: "border-exclusion-right"
      WlrLayershell.exclusionMode: ExclusionMode.Normal
      screen: parent.screen
      color: "transparent"
      anchors { top: true; bottom: true; right: true }
      implicitWidth: snapInt(3)
      mask: Region {}
    }*/
  }
