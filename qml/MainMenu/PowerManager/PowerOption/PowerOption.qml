import QtQuick
import "../../../Misc/Button/"
import "../../../Theme/"
import Quickshell

import Qt5Compat.GraphicalEffects


Button {
  id: menuOption
  required property string label
  required property url iconPath
  required property color buttonLightColor
  required property int buttonRadius
  required property string command

  property bool hasRadiusLeft: false
  property bool hasRadiusRight: false

  buttonInsetShadowSize: 3
  radiusLeft: menuOption.hasRadiusLeft ? 20 : 0
  radiusRight: menuOption.hasRadiusRight ? 20 : 0

  onClicked: {
    Quickshell.execDetached(["sh", "-c", "sleep 0.75 &&" + menuOption.command])
  }


  Image {
    id: icon
    width: 18
    height: 18
    anchors.centerIn: parent
    fillMode: Image.PreserveAspectFit
    sourceSize.width: width
    sourceSize.height: height
    source: "../../../assets/icons/" + menuOption.iconPath

    opacity: 0.75

    ColorOverlay {
      anchors.fill: parent
      color: Theme.text 
      source: parent
    }
  }
}
