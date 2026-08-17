import Quickshell
import Quickshell.Wayland
import QtQuick

import "../Theme"
import "../SideBar"

PanelWindow {
  id: sidebar
  required property string side
  WlrLayershell.namespace: "sidebar-" + side
  WlrLayershell.layer: WlrLayershell.Layer.Bottom
  aboveWindows: false
  color: "transparent"
  anchors {
      top: true
      bottom: true
      left: side == "left"
      right: side == "right"
  }
  Component.onCompleted: {
    Quickshell.execDetached(["hyprctl", "eval", "hl.curve('Linear', { type = 'bezier', points = { {0, 0}, {1, 1} } })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'windows', enabled = false, speed = 0, curve = 'Linear' })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'windowsMove', enabled = false, speed = 0, curve = 'Linear' })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.animation({ leaf = 'layers', enabled = false, speed = 0, curve = 'Linear' })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.layer_rule({ name = 'noanim_sidebar_left', match = { namespace = 'sidebar-left' }, no_anim = true })"])
    Quickshell.execDetached(["hyprctl", "eval", "hl.layer_rule({ name = 'noanim_sidebar_right', match = { namespace = 'sidebar-right' }, no_anim = true })"])
  }
  function snap(px) {
      var dpr = screen.devicePixelRatio
      for (var i = 0; i < 8; i++) {
          var up = Math.round(px) + i
          var down = Math.round(px) - i
          if (Math.abs((up * dpr) - Math.round(up * dpr)) < 0.01) return up
          if (down > 0 && Math.abs((down * dpr) - Math.round(down * dpr)) < 0.01) return down
      }
      return Math.round(px)
  }

  property real targetZone: side == "left"
      ? (SideBarState.leftOpen ? snap(SideBarState.leftWidth) : snap(52))
      : (SideBarState.rightOpen ? snap(SideBarState.rightWidth) : 0)

  property real animatedZone: targetZone


  implicitWidth: side == "left" ? snap(SideBarState.leftWidth) : snap(SideBarState.rightWidth)
  exclusiveZone: animatedZone
  Rectangle {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: side == "left" ? parent.left : undefined
      anchors.right: side == "right" ? parent.right : undefined
      implicitWidth: sidebar.animatedZone
      color: Theme.background
    }
}
