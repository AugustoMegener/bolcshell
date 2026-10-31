pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

import QtQuick.VectorImage
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../../Theme"
import "../../../Misc/TextInput/"
import "../../../Misc/Dropdown/"
import "../../../ShellState/"

import Quickshell.Services.Greetd 


Column {
  id: root

  width: parent.width

  padding: 10
  spacing: 10

  leftPadding: 30
  rightPadding: 30

  property var sessionNames: ({})

  property string typedUser: ShellState.cache.lastGreeterUser

  property bool sessionPicked: false

  readonly property var sessionOptions: {
    const count = ShellState.sessions.count
    const options = []
    for (let i = 0; i < count; i++) {
      const path = ShellState.sessions.get(i).sessionPath
      const file = path.split("/").pop()
      options.push({ text: sessionNames[path] ?? file.replace(/\.desktop$/, ""), value: file })
    }
    return options
  }

  Binding {
    target: ShellState
    property: "selectedSessionIndex"
    when: !root.sessionPicked
    value: Math.max(0, root.sessionOptions.findIndex(option => option.value === ShellState.cache.lastGreeterSession))
  }

  Instantiator {
    model: ShellState.sessions

    delegate: FileView {
      required property string sessionPath

      path: sessionPath

      onLoaded: {
        const match = text().match(/^Name=(.*)$/m)
        if (!match)
        return
        const names = Object.assign({}, root.sessionNames)
        names[sessionPath] = match[1].trim()
        root.sessionNames = names
      }
    }
  }

  RowLayout {
    width: parent.width - parent.leftPadding - parent.rightPadding

    Item {
      Layout.preferredWidth: 20
      Layout.preferredHeight: 20

      VectorImage {
        id: userIcon
        source: "../../../assets/icons/user.svg"
        preferredRendererType: VectorImage.CurveRenderer
        anchors.fill: parent
      }

      ColorOverlay {
        anchors.fill: userIcon
        source: userIcon
        color: Theme.dim
      }
    }

    TextInput {
      Layout.fillWidth: true
      placeholderText: "User"
      activeFocusOnTab: true
      text: ShellState.cache.lastGreeterUser

      onTextChanged: root.typedUser = text
    }
  }

  RowLayout {
    width: parent.width - parent.leftPadding - parent.rightPadding

    Item {
      Layout.preferredWidth: 20
      Layout.preferredHeight: 20

      VectorImage {
        id: sessionIcon
        source: "../../../assets/icons/app-window.svg"
        preferredRendererType: VectorImage.CurveRenderer
        anchors.fill: parent
      }

      ColorOverlay {
        anchors.fill: sessionIcon
        source: sessionIcon
        color: Theme.dim
      }
    }

    Dropdown {
      Layout.fillWidth: true
      shadowMargin: 0
      textRole: "text"
      valueRole: "value"
      model: root.sessionOptions
      currentIndex: ShellState.selectedSessionIndex

      onActivated: index => {
        root.sessionPicked = true
        ShellState.selectedSessionIndex = index
      }
    }
  }

  function submit() {

      ShellState.cache.lastGreeterUser = root.typedUser
      ShellState.cache.lastGreeterSession = root.sessionOptions[ShellState.selectedSessionIndex]?.value ?? ""

      if (Greetd.state == GreetdState.Inactive && !ShellState.cache.lastGreeterUser && ShellState.cache.lastGreeterSession) {

        Greetd.createSession(ShellState.cache.lastGreeterUser)
      }
  }
}
