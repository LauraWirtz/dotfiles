import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Wayland

Image {
	Material.theme: Material.Dark
	Material.accent: Material.Green

	id: root
	required property LockContext context
	readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

	source: "/etc/nixos/home/background.png"
	fillMode: Image.PreserveAspectCrop

	ColumnLayout{
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			right: parent.right
		}
		Label {
			Layout.alignment: Qt.AlignHCenter

			renderType: Text.NativeRendering
			font.pointSize: 80

			SystemClock {
				id: clock
				precision: SystemClock.Minutes
			}

			text: Qt.formatDateTime(clock.date, "HH:mm")
		}
		RowLayout {
			Layout.alignment: Qt.AlignHCenter

			TextField {
				id: passwordBox

				implicitWidth: 400
				padding: 10

				focus: true
				enabled: !root.context.unlockInProgress
				echoMode: TextInput.Password
				inputMethodHints: Qt.ImhSensitiveData

				// Update the text in the context when the text in the box changes.
				onTextChanged: root.context.currentText = this.text;

				// Try to unlock when enter is pressed.
				onAccepted: root.context.tryUnlock();

				// Update the text in the box to match the text in the context.
				// This makes sure multiple monitors have the same text.
				Connections {
					target: root.context

					function onCurrentTextChanged() {
						passwordBox.text = root.context.currentText;
					}
				}
			}

			Button {
				text: "Clear"
				padding: 10
				onClicked: passwordBox.clear();
			}

			Button {
				text: "Unlock"
				padding: 10

				// don't steal focus from the text box
				focusPolicy: Qt.NoFocus

				enabled: !root.context.unlockInProgress && root.context.currentText !== "";
				onClicked: root.context.tryUnlock();
			}
		}

		Label {
			opacity: root.context.showFailure ? 1 : 0
			text: "Incorrect password"
		}

		GridLayout {
			Layout.alignment: Qt.AlignHCenter
			columns: 3
			uniformCellHeights: true
			uniformCellWidths: true

			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				implicitHeight: 32
				text: "7"
				padding: 10
				onClicked: passwordBox.text += "7";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "8"
				padding: 10
				onClicked: passwordBox.text += "8";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "9"
				padding: 10
				onClicked: passwordBox.text += "9";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "4"
				padding: 10
				onClicked: passwordBox.text += "4";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "5"
				padding: 10
				onClicked: passwordBox.text += "5";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "6"
				padding: 10
				onClicked: passwordBox.text += "6";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "1"
				padding: 10
				onClicked: passwordBox.text += "1";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "2"
				padding: 10
				onClicked: passwordBox.text += "2";
			}
			Button {
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "3"
				padding: 10
				onClicked: passwordBox.text += "3";
			}
			Button {
				Layout.column: 1
				Layout.row: 3
				Layout.preferredHeight: 64
				Layout.preferredWidth: height
				text: "0"
				padding: 10
				onClicked: passwordBox.text += "0";
			}

		}
	}
}
