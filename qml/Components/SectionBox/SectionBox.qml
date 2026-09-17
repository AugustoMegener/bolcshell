
pragma ComponentBehavior: Bound

import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import QtQuick.Controls.Basic 
import "../../Theme/"

ColumnLayout {

  id: box
  required property list<QtObject> sections

  property int tabBarSizeOffset: 0

  spacing: 10

  TabBar {
    id: topTabBar
    Layout.preferredWidth: parent.width - box.tabBarSizeOffset
    implicitHeight: 33
    background: Item {}

    Repeater {
      model: box.sections

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
            fragmentShader: "../../assets/shaders/innershadow.frag.qsb"
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


ScrollView {
    id: contentScroll

    Layout.fillWidth: true
    Layout.fillHeight: true


    StackLayout {
        id: content
        width: contentScroll.availableWidth
        currentIndex: topTabBar.currentIndex
        data: box.sections
        
    }
}
}
