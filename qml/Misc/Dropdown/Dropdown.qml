pragma ComponentBehavior: Bound
import QtQuick.Controls
import QtQuick
import "../../Theme/"

ComboBox {
  id: root

  property real buttonWidth: root.width
  property real buttonHeight: 32
  property real buttonInsetShadowSize: 2
  property real cornerRadius: 8
  property real radiusLeft: cornerRadius
  property real radiusRight: cornerRadius
  property real radiusTopLeft: radiusLeft
  property real radiusTopRight: radiusRight
  property real radiusBottomRight: radiusRight
  property real radiusBottomLeft: radiusLeft
  property color backgroundColor: Theme.buttonColor
  property real shadowMargin: 16

  signal selected()

  implicitWidth: 200
  implicitHeight: root.buttonHeight

  background: Item {
    implicitWidth: root.buttonWidth + 2 * root.shadowMargin
    implicitHeight: root.buttonHeight + 2 * root.shadowMargin
    width: implicitWidth
    height: implicitHeight
    anchors.centerIn: parent

    Rectangle {
      id: box
      x: root.shadowMargin
      y: root.shadowMargin
      width: root.buttonWidth
      height: root.buttonHeight
      color: root.backgroundColor
      topLeftRadius: root.radiusTopLeft
      topRightRadius: root.radiusTopRight
      bottomRightRadius: root.radiusBottomRight
      bottomLeftRadius: root.radiusBottomLeft
    }

    ShaderEffect {
      anchors.fill: parent
      property real resolutionX: width
      property real resolutionY: height
      property real boxHalfWidth: root.buttonWidth / 2
      property real boxHalfHeight: root.buttonHeight / 2
      property real insetShadowSize: root.buttonInsetShadowSize
      property real pressed: 0
      property real radiusTopLeft: root.radiusTopLeft
      property real radiusTopRight: root.radiusTopRight
      property real radiusBottomRight: root.radiusBottomRight
      property real radiusBottomLeft: root.radiusBottomLeft
      fragmentShader: Qt.resolvedUrl("../../assets/shaders/button.frag.qsb")
    }
  }

  indicator: Image {
    source: "../../assets/icons/dropdown-indicator.svg"
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    anchors.rightMargin: 5
    fillMode: Image.PreserveAspectFit
    width: 13
  }

  contentItem: Text {
    leftPadding: 10
    rightPadding: 20
    text: root.displayText
    font: root.font
    color: Theme.text
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
  }

  popup: Popup {
    y: root.height + 2
    width: root.width
    height: Math.min(contentItem.implicitHeight, root.Window.height - topMargin - bottomMargin)
    padding: 1

    contentItem: ListView {
      clip: true
      implicitHeight: contentHeight
      model: root.popup.visible ? root.delegateModel : null
      currentIndex: root.highlightedIndex
      ScrollIndicator.vertical: ScrollIndicator { }
    }

    background: Rectangle {
      border.color: Theme.border
      color: Theme.foreground
      radius: 6
    }
  }

  delegate: ItemDelegate {
    id: itemDelegate
    width: root.width
    height: root.buttonHeight
    required property int index
    required property var modelData
    highlighted: root.highlightedIndex === index

    background: Rectangle {
      color: itemDelegate.highlighted ? Theme.lightForeground : "transparent"
      radius: 6
    }

    contentItem: Text {
      text: itemDelegate.modelData[root.textRole] ?? itemDelegate.modelData
      color: Theme.text
      leftPadding: 10
      rightPadding: 10
      verticalAlignment: Text.AlignVCenter
      elide: Text.ElideRight
    }
  }
}
