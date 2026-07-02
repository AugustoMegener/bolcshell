import QtQuick

Rectangle {
  property string character: ""
  property color foreground: "white"
  property color background: "black"
  property string font: "GoMono Nerdfont"

  property real bgWidthProportion: 0.95
  property real charHeightProportion: 0.88

  height: 14
  width: char.width * bgWidthProportion
  color: background

  Text {
    id: char
    anchors.centerIn: parent
    text: parent.character
    color: parent.foreground
    font.family: parent.font
    font.pixelSize: parent.height * parent.charHeightProportion

  }
}
