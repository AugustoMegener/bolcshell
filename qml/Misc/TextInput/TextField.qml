import QtQuick
import QtQuick.Controls.Basic
import "../../Theme/"

TextField {
  id: searchInput

  implicitHeight: 32
  color: "#d7c0a3"
  selectionColor: "#5A4533"
  font.pixelSize: 14
  verticalAlignment: TextInput.AlignVCenter

  placeholderTextColor: "#866F51"
  

  background: Rectangle {
    id: bg
    implicitWidth: searchInput.implicitWidth
    implicitHeight: searchInput.implicitHeight
    radius: 8
    color: searchInput.activeFocus ? "#1c1712" : "#211b17" 
    border.width: 1
    border.color: searchInput.activeFocus ? "#1c1712" : "#3b3026"


    ShaderEffect {
      id: activeShadow

      property real boxWidth: bg.width
      property real boxHeight: bg.height
      property real margin: 8

      width: boxWidth + margin * 2
      height: boxHeight + margin * 2
      x: (bg.width - width) / 2
      y: (bg.height - height) / 2

      property real resolutionX: width
      property real resolutionY: height
      property real boxHalfWidth: boxWidth / 2
      property real boxHalfHeight: boxHeight / 2

      property real radiusTopLeft: bg.radius
      property real radiusTopRight: bg.radius
      property real radiusBottomRight: bg.radius
      property real radiusBottomLeft: bg.radius

      property real transition: searchInput.activeFocus ? 1.0 : 0.0
      Behavior on transition {
        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
      }

      fragmentShader: "../../assets/shaders/textinput.frag.qsb"
    }
  }
}
