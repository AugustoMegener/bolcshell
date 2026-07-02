import QtQuick
import "../../Theme"

Rectangle { 
  id: island
  height: parent.height
  radius: 6
  color: "#1e1b18"
  border.color: Theme.activeAltColor

  layer.effect: ShaderEffect {
    property real w: parent.width - 5.0
    property real h: parent.height - 5.0
    property real offsetX: 1.0
    property real offsetY: 1.0

    fragmentShader:  "../../" + Theme.innershadowShader 
  }


}
