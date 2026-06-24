pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "./TopBar"
import "./Border"
import "./SideBar"
import "./KeyboardRgb"

ShellRoot { 
    id: root 

SideBar { side: "right" }
SideBar { side: "left" }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            Border {
                required property ShellScreen modelData
                screen: modelData
            }
        }
    }
KeyboardRgb {}

    TopBar { }
}
