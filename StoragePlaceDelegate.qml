import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import com.kometa.StoragePlaces

Item{
    id: root
    property int defMargin: 5
    property color shadowColor: "#88000000"
    property color colorMain: "gray"
    property int fontSize1: root.height / 10

    Item{
        id: itemContent
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: defMargin / 2
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                focus: true
                console.log("Delegate clicked " + (index+1).toString())
            }
        }
        DropShadow {
            anchors.fill: bgRectangle
            source: bgRectangle
            horizontalOffset: root.defMargin / 2
            verticalOffset: root.defMargin / 2
            radius: 8.0
            samples: 17
            color: root.shadowColor
            opacity: 0.8
        }
        Rectangle{
            id: bgRectangle
            anchors.fill: parent
            radius: root.defMargin
            color: Qt.lighter( "#7F7F7F" )
        }

        Item{
            id: itemRectTop
            clip: true
            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: root.height / 5

            Rectangle{
                id: rectTop
                anchors.top: parent.top
                width: parent.width
                height: parent.height + root.defMargin
                color: colorMain
                radius: root.defMargin
            }

            Text{
                id: textTitle
                anchors.fill: parent
                font.pixelSize: root.fontSize1 * 1.5
                font.bold: true
                text: placeName
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }


        ListView{
            id: listShelves
            anchors{
                top: itemRectTop.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            interactive: false
            verticalLayoutDirection: ListView.BottomToTop

            model: shelvesModel

            delegate: Item{
                width: listShelves.width
                height: listShelves.height / shelvesQty

                Item{
                    id: itemStageBackground
                    clip: true
                    anchors.fill: parent
                    visible: ocupated
                    Rectangle{
                        id: rectStageBackground
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: parent.height + root.defMargin
                        color: "grey"
                        radius: index === 0?  root.defMargin : 0
                    }

                    RadialGradient {
                        id: gradientGreen
                        anchors.fill: rectStageBackground
                        source: rectStageBackground
                        visible: stage === 0
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#61B94A" }
                            GradientStop { position: 0.5; color: "#3E9149" }
                        }
                    }

                    RadialGradient {
                        id: gradientYellow
                        anchors.fill: rectStageBackground
                        source: rectStageBackground
                        visible: stage === 1
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#FFF898" }
                            GradientStop { position: 0.5; color: "#ffed00" }
                        }
                    }

                    RadialGradient {
                        id: gradientOrange
                        anchors.fill: rectStageBackground
                        source: rectStageBackground
                        visible: stage === 2
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#E8AD69" }
                            GradientStop { position: 0.5; color: "#e1871f" }
                        }
                    }

                    RadialGradient {
                        id: gradientRed
                        anchors.fill: rectStageBackground
                        source: rectStageBackground
                        visible: stage === 3
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#CA7154" }
                            GradientStop { position: 0.5; color: "#EE2F37" }
                        }
                    }
                }

                Rectangle{
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: root.colorMain
                }

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: index + 1 + " : " + stage
                }
            }

        }

        Rectangle{
            id: borderRectangle
            anchors.fill: parent
            radius: root.defMargin
            border.color: colorMain
            border.width: 1
            color: "transparent"
        }
    } // itemContent
}
