pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "./Theme"

Item {
    id: root


    readonly property color activeColor: Theme.activeAltColor

    onActiveColorChanged: {
        var r = Math.round(activeColor.g * 255).toString(16).padStart(2, '0')
        var g = Math.round(activeColor.r * 255).toString(16).padStart(2, '0')
        var b = Math.round(activeColor.b * 255).toString(16).padStart(2, '0')
        rgbProcess.command = ["openrgb", "--device", "0", "-m", "reactive", "--color", r + g + b]
        rgbProcess.running = true
    }

    Process {
        id: rgbProcess
        running: false
    }
}
