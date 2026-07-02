import Quickshell
import QtQuick
import Quickshell.Wayland
import "../Theme"
import "."
import Qt5Compat.GraphicalEffects

import Qt5Compat.GraphicalEffects

PanelWindow {
    width: islandRect.width + 40
    height: islandRect.height + 40
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Bottom
    color: "transparent"

    Rectangle {
        id: islandRect
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#1e1b18"
        border.color: Theme.activeAltColor
        radius: 16
        width: 50
        height: 50
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 4
            radius: 16
            samples: 33
            color: "#80000000"
        }

        state: DynamicIslandState.state

        states: [
            State {
                name: DynamicIslandState.State.Idle
                PropertyChanges { target: islandRect; width: 50; radius: 16; color: "#1e1b18" }
                PropertyChanges { target: logoOverlay; color: Theme.activeAltColor; y: 0; opacity: 1 }
            },
            State {
                name: DynamicIslandState.State.MainModding
                PropertyChanges {
                  target: islandRect;
                  width: 50; 
                  radius: 50; 
                  color: Theme.activeAltLightColor
                  layer.effect: null
                }
                PropertyChanges { target: logoOverlay; color: "white"; opacity: 1; width: 40; height: 40;  }
                PropertyChanges { target: icon; width: 40; height: 40;  }
            }
        ]

        transitions: Transition {
            from: "*"; to: "*"
            NumberAnimation { properties: "width,height,radius,y,opacity"; duration: 300; easing.type: Easing.InOutCubic }
            ColorAnimation { properties: "color"; duration: 300 }
        }

        Image {
            id: icon
            anchors.centerIn: parent
            width: 28
            height: 28
            sourceSize.width: width
            sourceSize.height: height
            source: `../assets/icons/distros-logo/${Theme.distroId}.svg`
        }

        ColorOverlay {
            id: logoOverlay
            anchors.fill: icon
            source: icon
            color: Theme.activeAltColor
        }
    }
}
