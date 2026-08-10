pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick
import Quickshell.Io

Singleton {

  FileView {
      id: osRelease
      path: "/etc/os-release"
      watchChanges: false
      onTextChanged: {
          const match = osRelease.text().match(/^ID=(.+)$/m);
          if (match) distroId = match[1].trim();
      }
  }

  property string distroId: "linux"

  Component.onCompleted: {
      const text = osRelease.text();
      const match = text.match(/^ID=(.+)$/m);
      if (match) distroId = match[1].trim();
  }

  readonly property color colorPurple: "#4a4cba"
  readonly property color colorYellow: "#da9a22"
  readonly property color colorRed: "#f35044"
  readonly property color colorBlue: "#4197b9"
  readonly property color colorGreen: "#108454"


  readonly property color colorLightPurple: "#707aff"
  readonly property color colorLightYellow: "#ffbb00"
  readonly property color colorLightRed: "#f0516c"
  readonly property color colorLightBlue: "#2ab1c0"
  readonly property color colorLightGreen: "#4ec68e"


  readonly property color transparent: "#00000000"
  readonly property string innershadowShader: "assets/shaders/innershadow.frag.qsb"
  readonly property color accent: colorYellow
  readonly property color background: "#26211c"
  readonly property color foreground: "#2e261f"
  readonly property color lightForeground: "#342c23"
  readonly property color border: "#3b3026"
  readonly property color dim: "#866f50"
  readonly property color text: "#d7c0a3"  
  readonly property color buttonColor: "#26211c"
  readonly property color mainButtonColor: "#5a4533"
  readonly property color dangerButtonColor: "#e02f29"

  readonly property int fontSize: 14


  property var altColor: function(i) {
    const colors = [colorYellow, colorRed, colorBlue]
    if (i === 0)
    return colorPurple
    return colors[(i - 1) % 3]
  }


  property var altLightColor: function(i) {
    const colors = [colorLightYellow, colorLightRed, colorLightBlue]
    if (i === 0)
    return colorLightPurple
    return colors[(i - 1) % 3]
  }

  readonly property HyprlandWorkspace focusedWorkspace: {
    for (var i = 0; i < Hyprland.workspaces.values.length; i++) {
      if (Hyprland.workspaces.values[i].focused) return Hyprland.workspaces.values[i]
    }
    return null
  }

  readonly property color activeAltColor: focusedWorkspace ? Theme.altColor(focusedWorkspace.id - 1) : colorPurple
  readonly property color activeAltLightColor: focusedWorkspace ? Theme.altLightColor(focusedWorkspace.id - 1) : colorLightPurple

  property var altIcon: function(i) {
    const icons = [ "circle", "triangle", "square"  ]
    return "assets/icons/" + ((i === 0) ? "astroid" : icons[(i - 1) % 3]) + ".svg"
  }

  function mixColors(colorA, colorB, ratio) {
      return Qt.rgba(
          colorA.r * (1 - ratio) + colorB.r * ratio,
          colorA.g * (1 - ratio) + colorB.g * ratio,
          colorA.b * (1 - ratio) + colorB.b * ratio,
          colorA.a * (1 - ratio) + colorB.a * ratio
      )
  }
}
