import Quickshell
import Quickshell.Wayland
import QtQuick
import "../Theme"
import "../SideBar"

PanelWindow {
    id: sidebar
    required property string side
    WlrLayershell.namespace: "border-" + side
    WlrLayershell.layer: WlrLayershell.Layer.Bottom
    aboveWindows: false
    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: side == "left"
        right: side == "right"
    }
    Component.onCompleted: {
        Quickshell.execDetached(["hyprctl", "keyword", "bezier", "Linear,0,0,1,1"])
        Quickshell.execDetached(["hyprctl", "keyword", "animation", "windows,1,5,Linear"])
        Quickshell.execDetached(["hyprctl", "keyword", "animation", "windowsMove,1,5,Linear"])
        Quickshell.execDetached(["hyprctl", "keyword", "animation", "layers,1,5,Linear"])
    }
    property int targetZone: side == "left"
        ? (SideBarState.leftOpen ? SideBarState.leftWidth : 45)
        : (SideBarState.rightOpen ? SideBarState.rightWidth : 0)

property real animatedZone: targetZone


Behavior on animatedZone {
    NumberAnimation {
        duration: 500
        easing.type: Easing.Linear
    }
}
    implicitWidth: side == "left" ? SideBarState.leftWidth : SideBarState.rightWidth
exclusiveZone: animatedZone
    Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: side == "left" ? parent.left : undefined
        anchors.right: side == "right" ? parent.right : undefined
        implicitWidth: sidebar.animatedZone
        color: "#2b2622"
    }
}
