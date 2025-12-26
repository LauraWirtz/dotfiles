// ClockWidget.qml
import QtQuick
import "../services"

Text {
  // we no longer need time as an input

  // directly access the time property from the Time singleton
  text: Time.time
  color: "white"
  font.pixelSize: 20
  font.weight: 200
}
