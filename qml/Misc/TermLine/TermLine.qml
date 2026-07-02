pragma ComponentBehavior: Bound
import QtQuick
import "./TermCell" 


Row {
    id: line
    property int charHeight: 14
    property string font: "GoMono Nerdfont"
    property var segments: []

    property real bgWidthProportion: 0.95
    property real charHeightProportion: 0.88

    Repeater {
        model: parent.segments

        Row {
            id: row
            required property var modelData

            Repeater {
                model: parent.modelData.text.length

                TermCell {
                    required property int index
                    font: line.font 
                    height: line.charHeight
  
                    bgWidthProportion: line.bgWidthProportion
                    charHeightProportion: line.charHeightProportion

                    character: row.modelData["text"][index]
                    foreground: row.modelData["fg"] || "white"
                    background: row.modelData["bg"] || "transparent"
                }
            }
        }
    }
}
