import Quickshell
import Quickshell.Wayland
import QtQuick
import "../Theme"
import "../SideBar"

PanelWindow {
    id: sidebar
    required property string side

    WlrLayershell.layer: WlrLayershell.Layer.Bottom
    aboveWindows: false
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: side == "left"
        right: side == "right"
    }

    property int targetZone: side == "left"
        ? (SideBarState.leftOpen ? SideBarState.leftWidth : 45)
        : (SideBarState.rightOpen ? SideBarState.rightWidth : 0)

    property int sidebarWidth: targetZone

    exclusiveZone: sidebarWidth
    implicitWidth: sidebarWidth

    onTargetZoneChanged: anim.restart()

    Component.onCompleted: {
        sidebarWidth = targetZone
    }

    NumberAnimation {
        id: anim
        target: sidebar
        property: "sidebarWidth"
        from: sidebar.sidebarWidth
        to: sidebar.targetZone
       duration: 30
    }

    mask: Region { item: content }

    Rectangle {
        id: content
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: sidebar.side == "left" ? parent.left : undefined
        anchors.right: sidebar.side == "right" ? parent.right : undefined

        color: "#2b2622"
        width: sidebar.sidebarWidth
    }
}
