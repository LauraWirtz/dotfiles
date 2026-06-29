// ClockWidget.qml
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Basic

Item {
	id: root

	implicitWidth: list.contentWidth + 14
	// implicitHeight: list.contentItem.childrenRect.height

	property alias model: list.model
	property alias orientation: list.orientation
	property alias interactive: list.interactive

	property var display: AbstractButton.TextBesideIcon
	property var alignment: Qt.AlignVCenter | Qt.AlignLeft
	property int size: 32
	property alias spacing: list.spacing

	property bool showText: false
	property bool showSections: false

	component DesktopEntryDelegate: BreezeButton {
		id: button
		width: list.contentWidth

		square: !root.showText
		topInset: 2
		leftInset: 2
		rightInset: 2
		bottomInset: 2
		leftPadding: 8
		rightPadding: 8
		topPadding: 8
		bottomPadding: 8

		Layout.alignment: root.alignment

		// icon.name: DesktopService.customIcons(modelData.icon)
		// icon.color: "transparent"
		// icon.width: root.size
		// icon.height: root.size
		display: root.display

		contentItem: RowLayout {
			spacing: root.showText ? 8 : 0
			Button {
				padding: 0
				icon.name: DesktopService.customIcons(modelData)
				icon.color: "transparent"
				icon.width: root.size
				icon.height: root.size
				background: Item {}
				onClicked: button.onClicked()
			}
			Loader {
				Layout.fillWidth: true
				active: root.showText
				sourceComponent: ColumnLayout {
					spacing: 0
					Text {
						color: button.palette.buttonText
						font.pixelSize: 18
						font.weight: 300
						text: DesktopService.customNames(modelData)
					}
					Text {
						color: button.palette.buttonText
						font.pixelSize: 12
						opacity: 0.5
						text: modelData.comment
					}
				}
			}
		}

		onClicked: {
			Niri.spawn(modelData.command)
		}
	}

	ListView {
		id: list

		anchors.fill: parent
		clip: list.interactive
		spacing: 0
		// implicitHeight: contentHeight

		// width: root.width
		// height: root.height
		contentWidth: contentItem.children.reduce((acc, el) => {
			return Math.max(el.implicitWidth, acc)
		}, 0) + 10
		contentHeight: contentItem.childrenRect.height

		boundsBehavior: Flickable.StopAtBounds
		Behavior on contentY { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }

		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.NoButton
			scrollGestureEnabled: true
			onWheel: wheel => {
				list.contentY = Math.max(0, Math.min(list.contentY-1.5*wheel.angleDelta.y, list.contentHeight - list.height))
			}
		}

		ScrollBar.vertical: ScrollBar {
			id: scrollbar
			hoverEnabled: true
			policy: list.contentHeight > list.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			contentItem: Item {
				implicitWidth: 10

				Rectangle {
					anchors.fill: parent
					radius: 5
					color: "white"
					opacity: 0.1 + 0.1 * (scrollbar.hovered || scrollbar.active)
					Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
				}
				Rectangle {
					anchors.fill: parent
					radius: 5
					color: "transparent"
					border.color: "white"
					opacity: 0.1 + 0.2 * (scrollbar.hovered || scrollbar.active)
					Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
				}
			}
		}

		section.property: showSections ? "name" : ""
		section.criteria: ViewSection.FirstCharacter
		section.delegate: Text {
			required property string section
			text: section.toUpperCase()
			color: "white"
		}

		delegate: DesktopEntryDelegate {}
	}
}
