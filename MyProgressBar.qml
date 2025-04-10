import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.StoragePlaces

Item{
    id: root
    
    property real progressValue: 0
    property int defMargin: 5
    property color colorMain: "gray"
    
    Rectangle{
        anchors.fill: parent
        color: "#BEBEBE"
        radius: root.defMargin / 2
        border.width: 1
        border.color: root.colorMain
        Rectangle{
            anchors{
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width * progressValue
            anchors.margins: 1
            radius: root.defMargin / 2
            color: "blue"
            
        }
    }
}
