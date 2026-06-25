import Quickshell
import QtQuick
import "../../Theme"
import "../SideBarState.qml"

PanelWindow {
  id: root
  visible: SideBarState.leftOpen
  color: "transparent"
  anchors {
    left: true
    right: true
    top: true
    bottom: true
  }

  Rectangle {
    id: widget
    width: 200
    height: 150
    color: Theme.background
    border.color: Theme.border
    radius: 12

    property real baseX: 300
    property real baseY: 100

    x: baseX
    y: baseY

    DragHandler {
      id: dragger
      onActiveChanged: {
        if (!active) {
          widget.baseX = widget.x
          widget.baseY = widget.y
        }
      }
    }

    states: State {
      when: dragger.active
      PropertyChanges {
        widget {
          x: widget.baseX + dragger.translation.x
          y: widget.baseY + dragger.translation.y
        }
      }
    }
  }
}
