
pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick

import Qt5Compat.GraphicalEffects
import "../../Theme"
import "../../ShellState/"

Item { 
  id: option

  anchors.verticalCenter: parent.verticalCenter

  required property int count 
  readonly property int index: count + 1

  readonly property bool isFocused: ShellState.systemSectionIndex == count
  required property bool isUrgent

  property bool blink: false

  required property color highlightColor
  required property string icon


  signal clicked()

  width: 33
  height: 33

  Rectangle { 
    id: wsContent

    anchors.fill: parent
    radius: 8
    border.width: 1
    border.color: option.isFocused ? option.highlightColor : Theme.transparent


    color: option.isFocused ? Theme.foreground : Theme.background

    layer.enabled: true
    layer.effect: ShaderEffect {
      property real w: wsContent.width - 2.0
      property real h: wsContent.height - 2.0
      property real offsetX: 1.0
      property real offsetY: 1.0
      property real radius: 8.0

      fragmentShader: option.isFocused ? "../../" + Theme.innershadowShader : ""
    }

    Image {
      id: icon
      source: option.icon
      width: 11;
      height: 11;

      anchors.centerIn: parent
    }

    Timer {
      interval: 450; 
      running: option.isUrgent; 
      repeat: true
      onTriggered: option.blink = !option.blink      
    }

    ColorOverlay { 
      anchors.fill: icon
      source: icon
      color: option.isFocused || (option.isUrgent && option.blink)? option.highlightColor : Theme.dim
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {

          ShellState.systemSectionIndex = option.count
        option.clicked()
      }

      z: 2
    }
  }
}
