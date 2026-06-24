pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "./Theme"

Item {
    id: root

    readonly property HyprlandWorkspace focusedWorkspace: {
        for (var i = 0; i < Hyprland.workspaces.values.length; i++) {
            if (Hyprland.workspaces.values[i].focused) return Hyprland.workspaces.values[i]
        }
        return null
    }

    readonly property color activeColor: focusedWorkspace
        ? Theme.altColor(focusedWorkspace.id - 1)
        : "#ffffff"

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
