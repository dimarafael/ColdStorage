import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.StoragePlaces

Window {
    id: window
    width: 960
    height: 540
    visible: true
    title: qsTr("Cold Storage")

    readonly property int defMargin: Math.floor(window.height * 0.01)
    readonly property color shadowColor: "#88000000"
    readonly property color colorKometaGreen: "#416f4c"

    property bool showSettings: false

    LinearGradient{
        anchors.fill: parent
        start: Qt.point(window.width / 4,height)
        end: Qt.point(width * 0.75 ,0)
        gradient: Gradient{
            GradientStop{
                position: 0.0;
                color: "#416f4c"
            }
            GradientStop{
                position: 0.5;
                color: "#ffffff"
            }
            GradientStop{
                position: 1.0;
                color: "#ce253c"
            }
        }
    }


    Item{
        id: itemRootContent
        anchors.fill: parent
        anchors.margins: window.defMargin


        DropShadow {
            anchors.fill: topMenu
            source: topMenu
            horizontalOffset: window.defMargin / 2
            verticalOffset: window.defMargin / 2
            radius: 8.0
            samples: 17
            color: window.shadowColor
            opacity: 0.8
        }

        Item {
            id: topMenu
            clip: true
            anchors.top: itemRootContent.top
            width: itemRootContent.width
            height: itemRootContent.height / 15
            Rectangle{
                id: topMenuBckground
                anchors.top: parent.top
                width: parent.width
                height: parent.height + window.defMargin
                color: colorKometaGreen
                radius: window.defMargin
            }

            DropShadow {
                anchors.fill: logo
                source: logo
                horizontalOffset: window.defMargin / 3
                verticalOffset: window.defMargin / 3
                radius: 3.0
                samples: 17
                color: window.shadowColor
                opacity: 0.8
            }
            Image {
                id: logo
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    margins: window.defMargin
                }
                fillMode: Image.PreserveAspectFit

                source: "img/logo.png"
            }

            MyClock {
                id: itemClock
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                textColor: "white"
            }

            Item{
                id: itemGear
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                width: height * 1.5

                Rectangle{ //background if clicked
                    anchors.fill: parent
                    radius: window.defMargin
                    color: "#33ffffff"
                    visible: mouseAreaGear.pressed
                }

                MouseArea{
                    id: mouseAreaGear
                    anchors.fill: parent
                    onClicked: {
                        window.showSettings = !window.showSettings
                        itemSettings.unlocked = false
                        itemSettings.hideAllPopUps()
                        focus: true
                    }
                }

                DropShadow {
                    anchors.fill: imgGear
                    source: imgGear
                    horizontalOffset: window.defMargin / 3
                    verticalOffset: window.defMargin / 3
                    radius: 3.0
                    samples: 17
                    color: window.shadowColor
                    opacity: 0.8
                }
                Image {
                    id: imgGear
                    anchors{
                        fill: parent
                        margins: window.defMargin
                    }
                    fillMode: Image.PreserveAspectFit
                    source: "img/gear.svg"
                }
            }
        }

        GridView{
            id: gridViev
            anchors{
                top: topMenu.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: -( window.defMargin / 2)
                topMargin: window.defMargin / 2
            }
            cellWidth: width / 20
            cellHeight: height / 5
            interactive: false
            verticalLayoutDirection: GridView.TopToBottom

            model: StoragePlaces

            delegate: StoragePlaceDelegate {
                height: gridViev.cellHeight
                width: gridViev.cellWidth
                defMargin: window.defMargin
                shadowColor: window.shadowColor
                colorMain: window.colorKometaGreen
                visible: shelvesQty>0

                onShowDetailPopUp: function(model, name){
                    popUpShelves.show(model, name)
                }
            }
        }

        SettingsPanel {
            id: itemSettings
            width: parent.width
            height: parent.height - topMenu.height
            x: 0
            y: window.showSettings ? topMenu.height + window.defMargin : window.height
            defMargin: window.defMargin
            fontSize: height / 30

            Behavior on y{
                NumberAnimation{
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
            onHidePanel: {
                window.showSettings = false
                itemSettings.unlocked = false
            }
        }
    } // itemRootContent

    Rectangle{
        id:popUpBG
        x: 0
        y: 0
        width: window.width
        height: window.height
        color: "gray"
        opacity: popUpShelves.visible ? 0.7 : 0
        visible: false
        MouseArea{
            anchors.fill: parent
            onClicked: {
                focus=true
                popUpShelves.hide()
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }

        onOpacityChanged: {
            if (popUpBG.opacity === 0)
                popUpBG.visible = false
            else
                popUpBG.visible = true
        }
    }

    PopUpShelves {
        id: popUpShelves
        defMargin: window.defMargin
        colorMain: window.colorKometaGreen
        shadowColor: window.shadowColor
        width: parent.width / 3
        height: parent.height * 0.7
        // anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        x: (parent.width - width) / 2
    }


    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
