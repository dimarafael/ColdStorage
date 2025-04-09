import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
// import com.kometa.StoragePlaces
import com.kometa.Products

Item{
    id: root
    visible: false
    property int defMargin: 5
    property color colorMain: "gray"
    property color shadowColor: "#88000000"
    property int fontSize1: root.height / 10

    property var detailModel: null
    property string placeName: ""

    function show(model, name) {
        root.detailModel = model
        root.placeName = name
        root.visible = true
    }

    function hide(){
        root.visible = false
    }

    DropShadow {
        anchors.fill: rectangleMain
        source: rectangleMain
        horizontalOffset: root.defMargin / 2
        verticalOffset: root.defMargin / 2
        radius: 8.0
        samples: 17
        color: root.shadowColor
        opacity: 0.8
    }

    MouseArea{
        anchors.fill: parent
        onClicked: focus=true
    }

    Rectangle{
        id: rectangleMain
        anchors.fill: parent
        radius: root.defMargin
        color: "#BEBEBE"
        border.width: 1
        border.color: root.colorMain
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
            text: root.placeName
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    } // itemRectTop


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

        model: detailModel

        property int delegateHeight: count > 0 ? listShelves.height / count : 0

        delegate: Item{
            width: listShelves.width
            height: listShelves.delegateHeight

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log(root.placeName + " : shelf=" + index + " ocupated=" + ocupated)
                    if (ocupated) {
                        detailModel.takeProduct(index)
                    } else {
                        detailModel.putProduct(index, 1)
                    }
                }
            }

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
            } //itemStageBackground

            // split line
            Rectangle{
                anchors.top: parent.top
                width: parent.width
                height: 1
                color: root.colorMain
            }

            Item{
                id: itemTopPart
                visible: ocupated
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: parent.height / 3

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: Products.getProductNameById(productId)
                    font.pixelSize: parent.height * 0.7
                }


            } // itemTopPart

            Item{
                id: item2ndPart
                visible: ocupated
                anchors{
                    top: itemTopPart.bottom
                    left: parent.left
                    right: parent.right
                }
                height: parent.height / 3

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: elapsed
                    font.pixelSize: parent.height * 0.7
                }


            } // itemTopPart

            Item{
                id: itemBottomPart
                visible: ocupated
                anchors{
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    // bottomMargin: parent.height * 0.1
                }
                height: parent.height / 3

                ProgressBar {
                    id: itemProgressBar
                    anchors.centerIn: parent
                    width: parent.width * 0.9
                    height: parent.height * 0.7
                    progress: progress
                    colorMain: root.colorMain
                    defMargin: root.defMargin
                }
            } // itemBottomPart

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

}
