import QtQuick
import QtQuick.Shapes

import Qt5Compat.GraphicalEffects

Shape {
  id: root

  property real borderRadius: 12

  property real contentWidthProportion:0.925
  property real tabHeightProportion: 0.45
  property real borderWidth: 1

  required property color borderColor
  required property color fillColor
  required property color gripColor

  property int contentWidth: width * contentWidthProportion
  property int contentHeight: height

  property int tabX: contentWidth
  property int tabY: 0

  property int tabWidth: width - contentWidth
  property int tabHeight: height * tabHeightProportion
  

  ShapePath {
    strokeWidth: root.borderWidth
    strokeColor: root.borderColor
    fillColor: root.fillColor
    startX: root.borderRadius
    startY: 0

    PathLine { x: root.width - root.borderRadius ; y: 0 }

    PathArc {
      x: root.width
      y: root.borderRadius
      radiusX: root.borderRadius
      radiusY: root.borderRadius
    }

    PathLine { x: root.width; y: root.tabHeight - root.borderRadius }

    PathArc {
      x: root.width - root.borderRadius
      y: root.tabHeight
      radiusX: root.borderRadius
      radiusY: root.borderRadius
    }

    PathLine { x: root.contentWidth; y: root.tabHeight }

    PathLine {
      x: root.contentWidth
      y: root.tabHeight

    }

    PathLine { x: root.contentWidth; y: root.height - root.borderRadius }

    PathArc {
      x: root.contentWidth - root.borderRadius
      y: root.height
      radiusX: root.borderRadius
      radiusY: root.borderRadius
    }

    PathLine { x: root.borderRadius; y: root.height }

    PathArc {
      x: 0
      y: root.height - root.borderRadius
      radiusX: root.borderRadius
      radiusY: root.borderRadius
    }

    PathLine { x: 0; y: root.borderRadius }

    PathArc {
      x: root.borderRadius
      y: 0
      radiusX: root.borderRadius
      radiusY: root.borderRadius
    }
  }

  Item {
    x: root.tabX
    y: root.tabY
    width: root.tabWidth
    height: root.tabHeight

    Image {
      id: icon
      anchors.centerIn: parent
      fillMode: Image.PreserveAspectFit
      width: parent.width 
      height: parent.height
      source: "../../assets/icons/grip-vertical.svg"
    }

    ColorOverlay {
        anchors.fill: icon
        source: icon
        color: root.gripColor
    }
  }
}
