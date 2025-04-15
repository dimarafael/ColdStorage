import QtQuick
import QtQuick.VirtualKeyboard
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import com.kometa.Products

Item {
    id: root
    property int defMargin: 5
    property bool unlocked: false
    property int fontSize: 30
    property color textColor: "black" //"#bb000000"
    property int indexForDeleteEdit: 0
    property string nameForDeleteEdit: ""

    signal hidePanel()

    function hideAllPopUps(){
        popUpDelete.visible = false
        popUpAddEdit.visible = false
    }

    function checkPassword(){
        if(txtFldPass.text === "123"){
            root.unlocked = true
            root.focus = true
        }
        txtFldPass.text = ""
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            focus = true
        }
    }

    MouseArea{ // Hidden area for close application
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 40
        height: 40

        onClicked: {
            Qt.callLater(Qt.quit)
        }
    }

    DropShadow {
        anchors.fill: root
        source: root
        horizontalOffset: root.defMargin / 2
        verticalOffset: root.defMargin / 2
        radius: 3.0
        samples: 17
        color: "#88000000"
    }

    Rectangle{
        id: bgRectangle
        width: parent.width
        height: parent.height + root.defMargin
        color: "lightgray"
        radius: root.defMargin
    }


    Item{ // show content
        id: itemRootContent
        visible: root.unlocked
        anchors.fill: parent

        Text{
            id: textLabelRootContent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 100
            text: "Edit products list"
            color: "#416f4c"
            font.pixelSize: root.fontSize * 2
        }

        ListView{
            id: listProducts
            anchors.top: textLabelRootContent.bottom
            anchors.topMargin: parent.height / 100
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            height: parent.height * 0.75
            clip: true
            ScrollBar.vertical: ScrollBar { }

            model: Products

            delegate: Item{
                id: delegate
                height: listProducts.height / 10
                width: listProducts.width
                required property int productId
                required property string productCode
                required property string productName
                required property real stage1Hours
                required property real stage2Hours
                required property real stage3Hours
                required property int index

                Rectangle{
                    anchors.fill: parent
                    border.color: "grey"
                    border.width: 1
                    color: bgRectangle.color

                    Item {
                        id: itemTxtProductName
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: parent.height / 4
                        anchors.rightMargin: parent.height / 4
                        anchors.right: itemStage1Hours.left
                        height: parent.height
                        clip: true

                        Text {
                            id: txtProductName
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: root.fontSize
                            color: root.textColor
                            text: delegate.productCode + " : " + delegate.productName

                            SequentialAnimation{
                                id: animationName
                                running: (root.unlocked) && (itemTxtProductName.width < txtProductName.width)
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

                    Item{
                        id: itemStage1Hours
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            right: itemStage2Hours.left
                            topMargin: 1
                            bottomMargin: 1
                        }
                        width: height * 1.5

                        Rectangle{
                            id: rectangleStage1Hours
                            anchors.fill: parent
                            color: "lightgray"
                        }
                        RadialGradient {
                            id: gradientYellow
                            anchors.fill: rectangleStage1Hours
                            source: rectangleStage1Hours
                            gradient: Gradient {
                                GradientStop { position: 0; color: "#FFF898" }
                                GradientStop { position: 0.5; color: "#ffed00" }
                            }
                        }
                        Text{
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: root.fontSize
                            text: stage1Hours + "h"
                        }
                    }

                    Item{
                        id: itemStage2Hours
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            right: itemStage3Hours.left
                            topMargin: 1
                            bottomMargin: 1
                        }
                        width: height * 1.5

                        Rectangle{
                            id: rectangleStage2Hours
                            anchors.fill: parent
                            color: "lightgray"
                        }
                        RadialGradient {
                            id: gradientOrange
                            anchors.fill: rectangleStage2Hours
                            source: rectangleStage2Hours
                            gradient: Gradient {
                                GradientStop { position: 0; color: "#E8AD69" }
                                GradientStop { position: 0.5; color: "#e1871f" }
                            }
                        }
                        Text{
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: root.fontSize
                            text: stage2Hours + "h"
                        }
                    }

                    Item{
                        id: itemStage3Hours
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            right: itemEdit.left
                            topMargin: 1
                            bottomMargin: 1
                        }
                        width: height * 1.5

                        Rectangle{
                            id: rectangleStage3Hours
                            anchors.fill: parent
                            color: "lightgray"
                        }
                        RadialGradient {
                            id: gradientRed
                            anchors.fill: rectangleStage3Hours
                            source: rectangleStage3Hours
                            gradient: Gradient {
                                GradientStop { position: 0; color: "#CA7154" }
                                GradientStop { position: 0.5; color: "#EE2F37" }
                            }
                        }
                        Text{
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: root.fontSize
                            text: stage3Hours + "h"
                        }
                    }

                    Item{
                        id: itemEdit
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            right: itemDelete.left
                        }
                        width: height * 1.5

                        Rectangle{ //background if clicked
                            anchors.fill: parent
                            color: "#33ffffff"
                            visible: mouseAreaEdit.pressed
                        }

                        MouseArea{
                            id: mouseAreaEdit
                            anchors.fill: parent
                            onClicked: {
                                focus: true
                                console.log("Edit " + delegate.index)
                                setpointCode.text = delegate.productCode
                                txtProdName.text = delegate.productName
                                setpointStage1.text = delegate.stage1Hours
                                setpointStage2.text = delegate.stage2Hours
                                setpointStage3.text = delegate.stage3Hours
                                popUpAddEdit.index = delegate.productId
                                popUpAddEdit.isEdit = true
                                popUpAddEdit.visible = true
                            }
                        }

                        Image {
                            id: imgEdit
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: parent.height / 7
                            fillMode: Image.PreserveAspectFit
                            sourceSize.height: height
                            source: "img/edit.svg"
                        }
                    }

                    Item{
                        id: itemDelete
                        anchors{
                            top: parent.top
                            bottom: parent.bottom
                            right: parent.right
                        }
                        width: height * 1.5

                        Rectangle{ //background if clicked
                            anchors.fill: parent
                            color: "#33ffffff"
                            visible: mouseAreaDelete.pressed
                        }

                        MouseArea{
                            id: mouseAreaDelete
                            anchors.fill: parent
                            onClicked: {
                                focus: true
                                console.log("Delete " + delegate.index)
                                root.indexForDeleteEdit = delegate.productId
                                root.nameForDeleteEdit = delegate.productName
                                popUpDelete.visible = true
                            }
                        }

                        Image {
                            id: imgDelete
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: parent.height / 8
                            fillMode: Image.PreserveAspectFit
                            sourceSize.height: height
                            source: "img/trash.svg"
                        }
                    }

                }
            } // delegate
        } //item listProducts

        Item{
            id: itemOkCancel
            width: parent.width * 0.9
            height: root.height - listProducts.height - listProducts.y
            anchors.top: listProducts.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: btnCanceSettings
                height: parent.height * 0.6
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                color: mouseCancelSettings.pressed? "red":"#d83324"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "CANCEL"
                }

                MouseArea{
                    id: mouseCancelSettings
                    anchors.fill: parent
                    onClicked: {
                        root.unlocked = false
                        root.hideAllPopUps()
                        root.hidePanel()
                    }
                }
            }

            Rectangle{
                id: btnAddSettings
                height: parent.height * 0.6
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: mouseAddSettings.pressed? "blue":"#3E95F9"
                radius: height / 2
                Text{
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: -(root.fontSize * 0.6)
                    font.pixelSize: root.fontSize * 3
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                    text: "+"
                }

                MouseArea{
                    id: mouseAddSettings
                    anchors.fill: parent
                    onClicked: {
                        popUpAddEdit.index = 0
                        popUpAddEdit.isEdit = false
                        popUpAddEdit.visible = true

                        setpointCode.text = ""
                        txtProdName.text = ""
                        setpointStage1.text = ""
                        setpointStage2.text = ""
                        setpointStage3.text = ""
                    }
                }
            }

        } // itemOkCancel

    } // show content

    Rectangle{
        id:popUpBG
        x: 0
        y: 0
        width: root.width
        height: root.height + root.defMargin
        radius: root.defMargin
        color: "gray"
        opacity: 0.7
        visible: popUpDelete.visible | popUpAddEdit.visible
        MouseArea{
            anchors.fill: parent
            onClicked: focus=true
        }
    }

    DropShadow {
        anchors.fill: popUpDelete
        source: popUpDelete
        horizontalOffset: root.defMargin / 3
        verticalOffset: root.defMargin / 3
        radius: 8.0
        samples: 17
        color: "#88000000"
        visible: popUpDelete.visible
    }
    Rectangle{
        id: popUpDelete
        width: parent.width / 2
        height: parent.height / 2
        radius: root.defMargin
        color: "white"
        anchors.centerIn: parent
        visible: false
        clip: true
        Text{
            id: txtPopUpDeleteLine1
            width: parent.width
            height: parent.height / 4
            anchors.top: parent.top
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            color: "#416f4c"
            font.pixelSize: root.fontSize * 2
            text: "Delete?"
        }
        Text{
            id: txtPopUpDeleteLine2
            width: parent.width
            height: parent.height / 4
            anchors.top: txtPopUpDeleteLine1.bottom
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            color: "#416f4c"
            font.pixelSize: root.fontSize * 2
            text: root.nameForDeleteEdit
        }

        Item {
            id: itemPopUpDeleteLine3
            height: parent.height / 2
            width: parent.width * 0.85
            anchors.top: txtPopUpDeleteLine2.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: btnPopUpDeleteCancel
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                color: mouseAreaDeleteCancel.pressed? "red":"#d83324"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "CANCEL"
                }

                MouseArea{
                    id: mouseAreaDeleteCancel
                    anchors.fill: parent
                    onClicked: {
                        popUpDelete.visible = false
                    }
                }
            }

            Rectangle{
                id: btnPopUpDeleteOk
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                color: mouseAreaDeleteOk.pressed? "green":"#416f4c"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "DELETE"
                }
                MouseArea{
                    id: mouseAreaDeleteOk
                    anchors.fill: parent
                    onClicked: {
                        console.log("Delete: " + root.nameForDeleteEdit + " Id: " + root.indexForDeleteEdit)
                        Products.removeProduct(root.indexForDeleteEdit)
                        popUpDelete.visible = false
                    }
                }
            }
        }
    } //popUpDelete

    Rectangle{
        id: popUpAddEdit
        width: parent.width * 0.7
        height: parent.height * 0.7
        radius: root.defMargin
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: height * 0.01
        visible: false
        property bool mode: false
        property int index: 0
        property bool isEdit: false

        Item {
            id: popUpEditLine1
            width: parent.width
            height: parent.height / 6
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                id: txtPopUpEditLine1
                // width: parent.width
                // height: parent.height
                // anchors.top: parent.top
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#416f4c"
                font.pixelSize: root.fontSize * 2
                text: popUpAddEdit.isEdit? "Edit product":"New product"
            }


        }

        Item {
            id: popUpEditLine2
            width: parent.width
            height: parent.height / 5
            // anchors.verticalCenter: parent.verticalCenter
            anchors.top: popUpEditLine1.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id: txtLblCode
                anchors.bottom: setpointCode.top
                anchors.horizontalCenter: setpointCode.horizontalCenter
                font.pixelSize: root.fontSize
                color: "#416f4c"
                text: "Code"
            }

            SetpointField{
                id: setpointCode
                anchors.left: parent.left
                anchors.leftMargin: root.fontSize
                anchors.top: parent.top
                anchors.topMargin: height / 2
                width: parent.width * 0.2
                height: parent.height * 0.6

                minVal: 1
                maxVal: 9999
            }

            Text{
                id: txtLblName
                anchors.bottom: txtProdName.top
                anchors.horizontalCenter: txtProdName.horizontalCenter
                font.pixelSize: root.fontSize
                color: "#416f4c"
                text: "Product name"
            }

            TextField{
                id: txtProdName
                // width: parent.width * 0.6
                height: parent.height * 0.6
                anchors.top: parent.top
                anchors.topMargin: height / 2
                anchors.right: parent.right
                anchors.rightMargin: root.fontSize
                anchors.left: setpointCode.right
                anchors.leftMargin: root.fontSize
                inputMethodHints: Qt.ImhNoTextHandles // | hide selection handles
                font.pixelSize: height*0.7
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                onAccepted: {
                    console.log(text)
                    focus = false
                }

                background: Rectangle {
                    color: "#00FFFFFF"
                    border.width: parent.activeFocus ? 2 : 1
                    border.color: parent.activeFocus ? "#416f4c" : "lightgray"
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 250
                        }
                    }
                }
            }
        }

        Item {
            id: popUpEditLine3
            width: parent.width
            height: parent.height / 5
            anchors.top: popUpEditLine2.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id: txtLblStage1
                anchors.bottom: setpointStage1.top
                anchors.horizontalCenter: setpointStage1.horizontalCenter
                font.pixelSize: root.fontSize
                color: "#416f4c"
                text: "Stage 1 hours"
            }
            SetpointField{
                id: setpointStage1
                anchors.left: parent.left
                anchors.leftMargin: root.fontSize
                anchors.top: parent.top
                anchors.topMargin: height / 2
                width: parent.width * 0.2
                height: parent.height * 0.6

                minVal: 1
                maxVal: 9999
            }

            Text{
                id: txtLblStage2
                anchors.bottom: setpointStage2.top
                anchors.horizontalCenter: setpointStage2.horizontalCenter
                font.pixelSize: root.fontSize
                color: "#416f4c"
                text: "Stage 2 hours"
            }
            SetpointField{
                id: setpointStage2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: height / 2
                width: parent.width * 0.2
                height: parent.height * 0.6

                minVal: 1
                maxVal: 9999
            }

            Text{
                id: txtLblStage3
                anchors.bottom: setpointStage3.top
                anchors.horizontalCenter: setpointStage3.horizontalCenter
                font.pixelSize: root.fontSize
                color: "#416f4c"
                text: "Stage 3 hours"
            }
            SetpointField{
                id: setpointStage3
                anchors.right: parent.right
                anchors.rightMargin: root.fontSize
                anchors.top: parent.top
                anchors.topMargin: height / 2
                width: parent.width * 0.2
                height: parent.height * 0.6

                minVal: 1
                maxVal: 9999
            }
        }

        Item {
            id: popUpEditLine4
            width: parent.width * 0.7
            height: parent.height * 0.4
            anchors.top: popUpEditLine3.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: btnPopUpEditCancel
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                color: mouseAreaEditCancel.pressed? "red":"#d83324"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "CANCEL"
                }

                MouseArea{
                    id: mouseAreaEditCancel
                    anchors.fill: parent
                    onClicked: {
                        popUpAddEdit.visible = false
                    }
                }
            }

            Rectangle{
                id: btnPopUpEditOk
                height: root.height / 9
                width: root.width / 5
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                color: mouseAreaEditOk.pressed? "green":"#416f4c"
                radius: height / 2
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: root.fontSize
                    color: "white"
                    text: "OK"
                }
                MouseArea{
                    id: mouseAreaEditOk
                    anchors.fill: parent
                    onClicked: {
                        if(parseInt(setpointCode.text) > 0)
                        {
                            if(txtProdName.text.length > 0){
                                if(parseInt(setpointStage1.text) > 0){
                                    if((parseInt(setpointStage2.text) > 0) &&
                                            (parseInt(setpointStage2.text) > parseInt(setpointStage1.text))){
                                        if((parseInt(setpointStage3.text) > 0) &&
                                                (parseInt(setpointStage3.text) > parseInt(setpointStage2.text))){
                                            if(popUpAddEdit.isEdit){
                                                // Products.set(popUpAddEdit.index, txtProdName.text);
                                            }
                                            else{
                                                // Products.append(txtProdName.text);
                                                listProducts.positionViewAtEnd();
                                            }

                                            console.log("Product :" + parseInt(setpointCode.text) + " : " +
                                                        txtProdName.text + " : " +
                                                        parseInt(setpointStage1.text) + " : " +
                                                        parseInt(setpointStage2.text) + " : " +
                                                        parseInt(setpointStage3.text) +
                                                        " ID=" + popUpAddEdit.index)

                                            popUpAddEdit.visible = false
                                        }else setpointStage3.setFocus()
                                    }else setpointStage2.setFocus()
                                }else setpointStage1.setFocus()
                            }else txtProdName.focus = true
                        } else setpointCode.setFocus()
                    }
                }
            }
        }
    }// popUpAddEdit

    Item{ // show password field
        id: itemPass
        visible: !root.unlocked
        anchors.fill: parent

        Text{
            id: textLabelPass
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 6
            text: "Enter password"
            color: "#416f4c"
            font.pixelSize: root.fontSize

        }

        TextField{
            id: txtFldPass
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: textLabelPass.bottom
            anchors.topMargin: height / 3
            width: parent.width / 4
            height: root.fontSize * 1.4
            inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoTextHandles // | hide selection handles
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: root.fontSize
            echoMode: TextInput.Password
            onAccepted: root.checkPassword()
        }
    }
}
