import QtQuick

Rectangle{
    id: popUpStop
    width: 200
    height: 200
    color: "white"

    opacity: 0.0
    visible: false

    property int buttonWidth: 50
    property int fontSize: 30
    property string placeName: ""
    property int shelf: 0

    signal stop(int shelf)
    signal closed()

    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    onOpacityChanged: {
        if (popUpStop.opacity === 0)
            popUpStop.visible = false
        else
            popUpStop.visible = true
    }

    Text{
        id: txtPopUpStopLine1
        width: parent.width
        height: parent.height / 4
        anchors.top: parent.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        color: "#416f4c"
        font.pixelSize: popUpStop.fontSize * 2
        text: "Stop?"
    }
    Text{
        id: txtPopUpStopLine2
        width: parent.width
        height: parent.height / 4
        anchors.top: txtPopUpStopLine1.bottom
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        color: "#416f4c"
        font.pixelSize: popUpStop.fontSize * 2
        text: placeName + " : " + (shelf + 1)
    }

    Item {
        id: itemPopUpStopLine3
        height: parent.height / 2
        width: parent.width * 0.85
        anchors.top: txtPopUpStopLine2.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id: btnPopUpStopCancel
            height: popUpStop.buttonWidth * 0.3
            width: popUpStop.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            color: mouseAreaStopCancel.pressed? "red":"#d83324"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: popUpStop.fontSize
                color: "white"
                text: "CANCEL"
            }

            MouseArea{
                id: mouseAreaStopCancel
                anchors.fill: parent
                onClicked: {
                    popUpStop.opacity = 0
                    popUpStop.closed()
                }
            }
        }

        Rectangle{
            id: btnPopUpStopOk
            height: popUpStop.buttonWidth * 0.3
            width: popUpStop.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color: mouseAreaStopOk.pressed? "green":"#416f4c"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: popUpStop.fontSize
                color: "white"
                text: "STOP"
            }
            MouseArea{
                id: mouseAreaStopOk
                anchors.fill: parent
                onClicked: {
                    popUpStop.stop(popUpStop.shelf)
                    popUpStop.closed()
                    popUpStop.opacity = 0
                }
            }
        }
    }
}
