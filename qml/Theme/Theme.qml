pragma Singleton

import Quickshell.Hyprland
import QtQuick

QtObject {
    readonly property color colorPurple: "#4b4db8"
    readonly property color colorYellow: "#da9a22"
    readonly property color colorRed: "#f25146"
    readonly property color colorBlue: "#4396b7"
    readonly property color colorGreen: "#108454"

    readonly property color transparent: "#00000000"
    readonly property string innershadowShader: "assets/shaders/innershadow.frag.qsb"
    readonly property color accent: colorYellow
    readonly property color background: "#2b2622"
    readonly property color foreground: "#302b24"
    readonly property color border: "#3b3026"
    readonly property color dim: "#866f51"
    readonly property color text: "#d5bfa1"  
    readonly property int fontSize: 14



    property var altColor: function(i) {
      const colors = [colorYellow, colorRed, colorBlue]
      if (i === 0)
      return colorPurple
      return colors[(i - 1) % 3]
    }

    readonly property HyprlandWorkspace focusedWorkspace: {
        for (var i = 0; i < Hyprland.workspaces.values.length; i++) {
            if (Hyprland.workspaces.values[i].focused) return Hyprland.workspaces.values[i]
        }
        return null
    }


    readonly property color activeAltColor: focusedWorkspace
        ? Theme.altColor(focusedWorkspace.id - 1)
        : "#ffffff"
    property var altIcon: function(i) {
      const icons = [ "circle", "triangle", "square"  ]
      return "assets/icons/" + ((i === 0) ? "astroid" : icons[(i - 1) % 3]) + ".svg"
    }
}
