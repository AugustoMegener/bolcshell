
import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower 
import "../AudioStatus/AudioState"
import "../../Theme/"
import "../../Misc/RangeSlider/"
import "../../Components/AudioStatus/"
import "../../Components/AudioStatus/AudioState/"
import "../../Misc/Dropdown/"

Column {
  Item {
    id: volumeControl
    width: parent.width
    height: childrenRect.height
    Text {
      id: title
      text: qsTr(" Power profile")
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

      Dropdown {
        buttonWidth: 130
        implicitWidth: buttonWidth
        textRole: "text"
        valueRole: "value"
        model: [
          { text: "   Performace", value: PowerProfile.Performance },
          { text: "   Balanced", value: PowerProfile.Balanced },
          { text: "   Power saver", value: PowerProfile.PowerSaver }
        ]

        currentValue: PowerProfiles.profile
        onActivated: PowerProfiles.profile = valueAt(index)
      }
    }
  }
}
