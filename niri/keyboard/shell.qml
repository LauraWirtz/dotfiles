// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects


PanelWindow {
    id:root
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    mask: Region { x:0; y: keeb.y; width: root.width; height: keeb.height; }

    KeyboardWidget {
        id: keeb

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        anchors.bottomMargin: -height

        visible: false

        states: [
            State {
                name: "VISIBLE"
                when: KeyboardService.visible
                PropertyChanges {keeb.anchors.bottomMargin: 0}
                PropertyChanges {keeb.visible: true}
                PropertyChanges {touchpad.visible: true}
                PropertyChanges {doot.implicitHeight: keeb.height + 10}
            }
        ]
        transitions: [
            Transition {
                to: "VISIBLE"
                SequentialAnimation{
                    PropertyAction { target: keeb; property: "visible"; value: true }
                    NumberAnimation { properties: "keeb.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 100 }
                    PropertyAction { target: doot; property: "implicitHeight"; value: keeb.height }

                }
            },
            Transition {
                from: "VISIBLE"; to: "*"
                SequentialAnimation{
                    NumberAnimation { properties: "keeb.anchors.bottomMargin"; easing.type: Easing.InQuad; duration: 100 }
                    PropertyAction { target: keeb; property: "visible"; value: false }
                    PropertyAction { target: doot; property: "implicitHeight"; value: 0 }
                }
            },
        ]
    }
}
