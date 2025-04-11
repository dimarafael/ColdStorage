import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.StoragePlaces

Item{
    id: root

    property color textColor: "white"

    Text{
        id: textClock
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.8
        color: root.textColor
        font.bold: true
        text: {
            var now = new Date();
            return Qt.formatTime(now, "HH:mm:ss");
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();
            textClock.text = Qt.formatTime(now, "HH:mm:ss");
        }
    }
}
