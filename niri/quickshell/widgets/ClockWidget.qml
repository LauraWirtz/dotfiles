// ClockWidget.qml
import QtQuick
import "../services"

Text {
  // we no longer need time as an input

  // directly access the time property from the Time singleton
  text: Time.time+"\n"+Time.date
  color: Niri.inOverview ? "white" : "#9E9E9E"
  font.pixelSize: 18
  font.weight: Niri.inOverview ? 300 : 200
  horizontalAlignment: Text.AlignHCenter
  textFormat: Text.PlainText
  renderType: Text.QtRendering
}
