
pragma ComponentBehavior: Bound

import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import QtQuick.Controls.Basic 
import "../../../Components/QuickSettings/"
import "../../../Components/BluetoothMenu/"
import "../../../Theme/"

ColumnLayout {
  TabBar {
    id: topTabBar
    Layout.preferredWidth: parent.width 
    implicitHeight: 33
    background: Item {}

    Repeater {
      model: [
        { icon: "../../../assets/icons/sliders-horizontal.svg" },
        { icon: "../../../assets/icons/bluetooth.svg" }
      ]

      TabButton {
        id: topTabButton
        required property int index 
        required property var modelData

        property int isCurrent: topTabBar.currentIndex == topTabButton.index

        width: 33
        height: 33
        anchors.top: parent.top

        background: Rectangle {
          color: topTabButton.isCurrent? Theme.darkBackgound : "transparent"
          radius: 3
          border.width: topTabButton.isCurrent? 1 : 0
          border.color: Theme.altColorNoPurple(topTabButton.index)
          layer.enabled: topTabButton.isCurrent
          layer.effect: ShaderEffect {
            property real w: width - 2.0
            property real h: height - 2.0
            property real offsetX: 1.0
            property real offsetY: 1.0
            property real radius: 3.0
            fragmentShader: "../../../assets/shaders/innershadow.frag.qsb"
          }
          Image {
            id: topTabButtonIcon

            source: topTabButton.modelData.icon
            anchors.centerIn: parent

            width: 15
            height: 15

            ColorOverlay {

              anchors.fill: parent
              color: topTabButton.isCurrent? Theme.text : Theme.dim
              source: topTabButtonIcon
            }
          }
        }
      }
    }
  }

  Item {
    implicitHeight: 10
    implicitWidth: 1
  }

  StackLayout {
    currentIndex: topTabBar.currentIndex

    QuickSettings {
      Layout.fillWidth: true
    }
    BluetoothMenu {
      Layout.fillWidth: true
    }
  }
}
