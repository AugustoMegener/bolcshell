pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick
import Qt5Compat.GraphicalEffects
import "../../Theme"

Repeater {
  model: Hyprland.workspaces

  anchors.verticalCenter: parent.verticalCenter
  

  Item { 
    id: workspace


    anchors.verticalCenter: parent.verticalCenter

    required property int index
    required property HyprlandWorkspace modelData
    readonly property bool isFocused: workspace.modelData.focused
    readonly property bool isUrgent: workspace.modelData.urgent

    property bool blink: false


    width: 33
    height: 33

    Rectangle { 
      id: wsContent

      anchors.fill: parent
      radius: 8
      border.width: 1
      border.color: workspace.isFocused ? Theme.altColor(workspace.index) : Theme.transparent

      color: workspace.isFocused ? "#312b24" : Theme.background

      layer.enabled: true
      layer.effect: ShaderEffect {

        property real w: wsContent.width - 2.0
        property real h: wsContent.height - 2.0
        property real offsetX: 1.0
        property real offsetY: 1.0

        fragmentShader: workspace.isFocused ? "../../" + Theme.innershadowShader : ""
      }

      Image {
        id: icon
        source: "../../" + Theme.altIcon(workspace.index);
        width: 11;
        height: 11;

        anchors.centerIn: parent
      }

      Timer {
        interval: 450; 
        running: true; 
        repeat: true
        onTriggered: workspace.blink = !workspace.blink      
      }

      ColorOverlay { 
        anchors.fill: icon
        source: icon
        color: workspace.isFocused || (workspace.isUrgent && workspace.blink)? Theme.altColor(workspace.index) : Theme.dim
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch(`workspace ${workspace.modelData.id}`)
        z: 2
      }
    }
  }
}

