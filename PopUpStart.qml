import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import QtQuick.Controls

import com.kometa.Products

Rectangle{
    id: root
    width: 200
    height: 200
    color: "white"

    opacity: 0.0
    visible: false

    property int index: 0
    property int buttonWidth: 50
    property int fontSize: 30

    property string placeName: ""
    property int shelf: 0

    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    onOpacityChanged: {
        if (root.opacity === 0)
            root.visible = false
        else
            root.visible = true
    }

    signal closed()

    signal start(int shelf, int productId, real weight)


    onVisibleChanged: {
        if(visible === true) {
            listProducts.indexSelected = -1
            setpointWeight.text = 0
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: root.focus = true
    }

    Text{
        id: txtLine1
        width: parent.width
        height: parent.height / 8
        anchors.top: parent.top
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        color: "#416f4c"
        font.pixelSize: root.fontSize * 2
        text: "Start " + placeName + " : " + (shelf + 1)
    }

    Item{
        id: itemLine2
        anchors.top: txtLine1.bottom
        width: parent.width * 0.9
        height: parent.height * 0.18
        anchors.horizontalCenter: parent.horizontalCenter

        Item{
            id: itemWeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            height: parent.height
            width: parent.width / 3

            Image {
                id: imgScale
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height / 3
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                source: "img/scale.svg"
            }

            SetpointField{
                id: setpointWeight
                anchors.left: imgScale.right
                anchors.leftMargin: root.fontSize / 3
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.7
                height: root.fontSize * 1.8

                minVal: 1
                maxVal: 999
                units: "kg"
            }
        }
    }

    ListView{
        id: listProducts
        anchors.top: itemLine2.bottom
        anchors.topMargin: parent.height / 100
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.9
        height: parent.height / 2
        clip: true
        ScrollBar.vertical: ScrollBar { }

        property int indexSelected: -1
        property int productIdSelected: -1

        model: Products

        delegate: Item {
            id: delegate
            height: listProducts.height / 4
            width: listProducts.width

            required property string productName
            required property int productId
            required property int index

            Rectangle{
                anchors.fill: parent
                border.color: "lightgrey"
                border.width: 1
                color: "white"
                Rectangle{ // selected line
                    anchors.fill: parent
                    color: "#3E95F9"
                    visible: delegate.index === listProducts.indexSelected
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        focus = true
                        listProducts.indexSelected = delegate.index
                        listProducts.productIdSelected = delegate.productId
                    }
                }

                Item {
                    id: itemTxtProductName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.height / 4
                    anchors.rightMargin: parent.height / 4
                    anchors.right: parent.right
                    height: parent.height
                    clip: true

                    Text {
                        id: txtProductName
                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: root.fontSize
                        color: (delegate.index === listProducts.indexSelected)?"white":"black"
                        text: delegate.productName

                        SequentialAnimation{
                            id: animationName
                            running: (root.visible === true) && (itemTxtProductName.width < txtProductName.width)
                            loops: Animation.Infinite
                            alwaysRunToEnd: true

                            NumberAnimation{
                                id: ani1
                                target: txtProductName
                                property: "x"
                                from: 0
                                to: itemTxtProductName.width - txtProductName.width
                                duration: 2000
                            }
                            PauseAnimation { duration: 500 }
                            NumberAnimation{
                                id: ani2
                                targets: txtProductName
                                property: "x"
                                from: itemTxtProductName.width - txtProductName.width
                                to: 0
                                duration: 2000
                            }
                            PauseAnimation { duration: 500 }
                        }
                    }
                }
            }
        }
    }


    // Buttons Start Stop
    Item{
        id: itemLineButtons
        anchors.top: listProducts.bottom
        width: parent.width * 0.9
        height: parent.height * 0.18
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            id: btnCancel
            height: root.buttonWidth * 0.3
            width: root.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            color: mouseAreaCancel.pressed? "red":"#d83324"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: root.fontSize
                color: "white"
                text: "CANCEL"
            }

            MouseArea{
                id: mouseAreaCancel
                anchors.fill: parent
                onClicked: {
                    root.opacity = 0
                    root.closed()
                }
            }
        }

        Rectangle{
            id: btnStart
            height: root.buttonWidth * 0.3
            width: root.buttonWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color: mouseAreaOk.pressed? "green":"#416f4c"
            radius: height / 2
            Text{
                anchors.centerIn: parent
                font.pixelSize: root.fontSize
                color: "white"
                text: "START"
            }
            MouseArea{
                id: mouseAreaOk
                anchors.fill: parent
                onClicked: {
                    // if(listProducts.indexSelected >= 0 && ProcessModel.sensorStatus === 0){
                    if(listProducts.indexSelected >= 0){
                        if(parseFloat(setpointWeight.text) > 0){

                            console.log("Start product ID=" + listProducts.productIdSelected)

                            root.start(root.shelf,
                                       listProducts.productIdSelected,
                                       parseFloat(setpointWeight.text))
                            root.opacity = 0
                            root.closed()
                        } else {
                            setpointWeight.setFocus()
                        }
                    }
                }
            }
        }
    }
}
