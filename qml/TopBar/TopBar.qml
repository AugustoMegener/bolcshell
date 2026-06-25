import Quickshell
import Quickshell.Wayland
import QtQuick
import "../Theme"
import "./TopBarLeft"
import "./TopBarRight"
import "../SideBar"

PanelWindow { 
    id: bar
    aboveWindows: false
    WlrLayershell.layer: WlrLayershell.Layer.Bottom
    WlrLayershell.namespace: "topbar"
    anchors { top: true; left: true; right: true }
    implicitHeight: 50
    color: "transparent"

Component.onCompleted: {
    Quickshell.execDetached(["hyprctl", "keyword", "bezier", "Linear,0,0,1,1"])
    Quickshell.execDetached(["hyprctl", "keyword", "animation", "windows,1,5,Linear"])
    Quickshell.execDetached(["hyprctl", "keyword", "animation", "windowsMove,1,5,Linear"])
    Quickshell.execDetached(["hyprctl", "keyword", "layerrule[noanim_topbar]:no_anim on"])
    Quickshell.execDetached(["hyprctl", "keyword", "layerrule[noanim_topbar]:match:namespace topbar"])
}

    Rectangle {

        anchors.fill: parent
        color: Theme.background
        Item {
            x: 10
            y: 10
            width: parent.width - 20
            height: parent.height - 10


            
            TopBarLeft {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            TopBarRight {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

}
