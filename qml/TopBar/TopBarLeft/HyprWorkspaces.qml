pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick
import Qt5Compat.GraphicalEffects
import "../../Theme"

Repeater {
  model: Math.max(4, ...Hyprland.workspaces.values.map((it) => { return it.id }))

  anchors.verticalCenter: parent.verticalCenter

  Item { 
    id: workspace

    anchors.verticalCenter: parent.verticalCenter

    required property int modelData 
    readonly property int index: modelData + 1
    readonly property var value: Hyprland.workspaces.values.find(ws => ws.id === workspace.index)
    readonly property bool isFocused: workspace.value ? workspace.value.focused : false
    readonly property bool isUrgent: workspace.value ? workspace.value.urgent : false

    property bool blink: false

    width: 33
    height: 33

    Rectangle { 
      id: wsContent

      anchors.fill: parent
      radius: 8
      border.width: 1
      border.color: workspace.isFocused ? Theme.altColor(workspace.modelData) : Theme.transparent

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
        source: "../../" + Theme.altIcon(workspace.modelData);
        width: 11;
        height: 11;

        anchors.centerIn: parent
      }

      Timer {
        interval: 450; 
        running: workspace.isUrgent; 
        repeat: true
        onTriggered: workspace.blink = !workspace.blink      
      }

      ColorOverlay { 
        anchors.fill: icon
        source: icon
        color: workspace.isFocused || (workspace.isUrgent && workspace.blink)? Theme.altColor(workspace.modelData) : Theme.dim
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch(`workspace ${workspace.index}`)
        z: 2
      }
    }
  }
}
