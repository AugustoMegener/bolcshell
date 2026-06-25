
import "../../Theme"
import "../SideBar"

Item {
  id: sideBarToggle

  required property string side
  property bool toggle: {
    if (side == "left") SideBarState.leftOpen
    else if (side == "right") SideBarState.rightOpen
  }

  width: 33
  height: 33 

  Rectangle {
    id: toggleIcon

    anchors.centerIn: parent
    anchors.horizontalCenterOffset: sideBarToggle.side == "right" ? -5 : 5
    width: 22
    height: 20

    color: "transparent"
    border.color:  Theme.dim
    border.width: 1.35
    radius: 4

    Rectangle {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: {
        if (sideBarToggle.side == "left") parent.left
      }
      anchors.right: {
        if (sideBarToggle.side == "right") parent.right
      }

      anchors.topMargin: 3
      anchors.bottomMargin: 3
      anchors.leftMargin: 3
      anchors.rightMargin: 3

      width: sideBarToggle.toggle? 5 : 3
      radius: 2
      color: Theme.dim

      Behavior on width {
        NumberAnimation {
          duration: 200
        }
      }
    }

    scale: 0.7
  }


  MouseArea {
    anchors.fill: toggleIcon
    onClicked: {

    if (side == "left") SideBarState.leftOpen = 
    else if (side == "right") SideBarState.rightOpen
    } 
    z: 2

  }
}
