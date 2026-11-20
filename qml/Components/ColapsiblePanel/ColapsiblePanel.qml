import QtQuick
import Quickshell


PanelWindow {
  id: root;

  required property real openWidth;

  default property alias content: content.data

  property bool isOpen: false
  onIsOpenChanged: {
    enableHyprAnimation(true)
    openDelay.running = true
  }

  property bool canOpen: false

  property int animationSpeedSec: 5
  property real targetWidth: canOpen? openWidth : 0;

  property real popoutWidth: targetWidth

  property color backgroundColor: "white"

  color: "transparent";
  exclusiveZone: targetWidth;
  implicitWidth: openWidth;
  aboveWindows: false


  Component.onCompleted: Quickshell.execDetached(["hyprctl", "eval", `
    hl.curve("Linear", { type = "bezier", points = {{ 0, 0}, {1, 1}} })
    hl.animation({ leaf = "windows", enabled = true, speed = ${root.animationSpeedSec}, bezier = "Linear" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = ${root.animationSpeedSec}, bezier = "Linear" })
  `])

  Behavior on popoutWidth {
    NumberAnimation {
      duration: root.animationSpeedSec * 100;
      easing.type: Easing.Linear

      onRunningChanged: if (!running) root.enableHyprAnimation(false)
    }
  }

  Rectangle {
    id: content
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;
    anchors.left: parent.left;
    color: root.backgroundColor;
    implicitWidth: root.popoutWidth;
  }

  Timer {
    id: openDelay
    interval: 20
    onTriggered: root.canOpen = root.isOpen
  }

  function enableHyprAnimation(enabled) {
    Quickshell.execDetached(["hyprctl", "eval", `
    hl.config({
      animations = {
        enabled = ${enabled},
      },
    })
    `])
  }
}
