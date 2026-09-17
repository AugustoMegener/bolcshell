
import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "../BrightnessManager/BrightnessState/"
import "../../Theme/"
import "../../Misc/RangeSlider/" as Misc

Column {
  Item {
    id: volumeControl
    width: parent.width
    height: childrenRect.height 
    Text {
      id: title
      text: qsTr("󰃝  Brightness")
      font.pixelSize: 13
      font.family: "Bricolage Grotesque"
      font.weight: Font.ExtraBold
      color: Theme.text
      anchors.left: parent.left
    }
    Row {
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.topMargin: 5

      TextField {
        anchors.verticalCenter: parent.verticalCenter
        id: volumeField
        text: Math.round(BrightnessState.brightnessPct * 100)
        color: Theme.text
        font.pixelSize: 13
        background: Rectangle {
          color: volumeField.activeFocus ? Theme.lightForeground : "transparent"
          radius: 4
        }
        leftPadding: 4
        rightPadding: activeFocus? 4 : 0
        topPadding: 0
        bottomPadding: 0
        implicitWidth: contentWidth + leftPadding + rightPadding
        validator: IntValidator { bottom: 0; top: 100 }
        Keys.onReturnPressed: volumeField.focus = false
        Keys.onEnterPressed: volumeField.focus = false
        onActiveFocusChanged: {
          if (!activeFocus) {
            if (acceptableInput) {
              BrightnessState.setBrightness(parseInt(text) / 100)
            } else {
              text = Qt.binding(function() { return Math.round(BrightnessState.brightnessPct * 100) })
            }
          }
        }
      }
      Text {
        text: "%"
        color: Theme.text
        font.pixelSize: 13
        anchors.verticalCenter: parent.verticalCenter
      }
      Item {
        width: 5
        height: 1 
      }
      Misc.RangeSlider {
        id: volumeSlider
        hoverEnabled: true
        anchors.verticalCenter: parent.verticalCenter
        width: 100
        from: 0
        to: 1
        value: BrightnessState.brightnessPct
        onMoved: {
           BrightnessState.setBrightness(value)
        }
      }

      Item {
        width: 5
        height: 1 
      }
    }
  }
}
