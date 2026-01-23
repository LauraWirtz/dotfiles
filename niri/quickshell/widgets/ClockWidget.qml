// ClockWidget.qml
import QtQuick
import "../services"

Text {
  // we no longer need time as an input

  // directly access the time property from the Time singleton
  text: Time.time+"\n"+Time.date
  color: "#9E9E9E"
  font.pixelSize: 20
  font.weight: 200
  lineHeight: 0.8
  horizontalAlignment: Text.AlignHCenter
  textFormat: Text.PlainText
  renderType: Text.QtRendering
}
