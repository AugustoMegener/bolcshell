import Quickshell
import Quickshell.Wayland
import QtQuick
import "../Theme"
import "./TopBarLeft"
import "./TopBarRight"
import "../SideBar"
import "../Components/TrayList"

PanelWindow { 
  id: topbar
  aboveWindows: false
  WlrLayershell.layer: WlrLayershell.Layer.Bottom
  WlrLayershell.namespace: "topbar"
  anchors { top: true; left: true; right: true }

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

  implicitHeight: snapInt(50)
  color: "transparent"

  Component.onCompleted: {
    Quickshell.execDetached(["hyprctl", "eval", "hl.curve('Linear', { type = 'bezier', points = { {0, 0}, {1, 1} } })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'windows', enabled = false, speed = 0, curve = 'Linear' })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'windowsMove', enabled = false, speed = 0, curve = 'Linear' })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.layer_rule({ name = 'noanim_topbar', match = { namespace = 'topbar' } })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.layer_rule({ name = 'noanim_topbar', no_anim = true })"])
  }

  

  Rectangle {

    anchors.fill: parent
    color: Theme.background
    Item {
      x: 10
      y: 10
      width: parent.width - 20
      height: parent.height - 10

      TopBarLeft {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
      }

      TopBarRight {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }
}
