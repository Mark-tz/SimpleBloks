import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Client.Component 1.0 as Client
ApplicationWindow{
    visible:true;
    width:1400;
    height:(Qt.platform.os == "windows") ? 722 : 700;
    minimumHeight: height;
    minimumWidth: width;
    maximumHeight: height;
    maximumWidth: width;
    color:"#FFFFFF";
    id:window;
    menuBar: MenuBar {
        Menu {
            id:menu;
            property int itemWidth : 100;
            title: qsTr("Setting")+translator.emptyString;
            Menu {
                title: qsTr("Language")+translator.emptyString;
                MenuItem {
                    id : en;
                    text:qsTr("English")+translator.emptyString;
                    onTriggered: {
                        en.checked = true;
                        zh.checked = false;
                        translator.selectLanguage("en");
                    }
                }
                MenuItem {
                    id : zh;
                    text:qsTr("Chinese")+translator.emptyString;
                    onTriggered: {
                        en.checked = false;
                        zh.checked = true;
                        translator.selectLanguage("zh");
                    }
                }
            }
        }
        Menu {
            title: qsTr("Help")+translator.emptyString;
            MenuItem {
                text: qsTr("About")+translator.emptyString;
                onTriggered: aboutDialog.visible = true;
            }
        }
//        style: MenuBarStyle {
//            itemDelegate: Rectangle {
//                width:100;
//            }
//        }
    }
    Dialog {
        id: aboutDialog;
        title: "About"
        Component.onCompleted: visible = false;
        contentItem: Rectangle {
            color: "white"
            implicitWidth: 400
            implicitHeight: 300
            Image{
                width:128;
                height:128;
                x:20;
                y:20;
                source:"../../logo.jpg";
            }
            Image{
                width:128;
                height:128;
                x:200;
                y:15;
                source:"../../seer.jpg";
            }
            Text{
                x:20;
                y:20+128+20;
                text:qsTr("YISIBOT SSL CLIENT");
				font.pointSize: 12;
				font.weight:  Font.Bold;
            }
            Text{
                x:20;
                y:20+128+20+50;
                text:qsTr("Copyright © 2016 YISIBOT, All rights reserved");
            }
            Text{
                x:20;
                y:20+128+20+90;
                text:qsTr("Power by RoboKit®, Seer Robotics");
            }
            Button{
                x:320;
                y:20+128+20+90+10;
                text : qsTr("Close")+translator.emptyString;
                onClicked: aboutDialog.visible = false;
				visible: (Qt.platform.os == "windows") ? false : true;
            }
        }
    }
    Client.CommandParser{ id: commandParser; }
    Client.Serial { id : serial; }
    Client.Interaction{ id : interaction; }
    Client.Translator{ id : translator; }
    signal radioSend();
    signal radioSendTimer();
    signal radioVelRTimer();
    Timer{
        id:timer;
        interval:15;
        running:false;
        repeat:true;
        property int count : 0;
        property int radioTimer : 5;
        property int count2 : 0;
        property int velRTimer : 3;
        onTriggered: {
            if (count < radioTimer)
                count++;
            if (count == radioTimer) {
                count++;
                radioSendTimer();
            }
            if (count2 < velRTimer)
                count2++;
            if (count2 == velRTimer) {
                radioVelRTimer();
            }
            serial.sendCommand();
            window.radioSend();
        }
    }
    Timer{
        id:fpsTimer;
        interval:1000;
        running:true;
        repeat:true;
        onTriggered: {
            fps.text = (fieldCanvas.getFPS()).toString();
        }
    }
    Rectangle{
        height:2;
        width:window.width;
        color:"yellow";
        id:line;
        visible: false;
    }
    Grid{
        rows:2;
        columns:2;
        rowSpacing:0;
        columnSpacing:0;
        anchors.top:(Qt.platform.os==="windows")? line.bottom : parent.top;
        function fieldChangeSignal(ifBig){
            fieldCanvas.ifBig = ifBig;
        }
        Client.Field{
            width:1050;
            height:700;
            id:fieldCanvas;
            property bool ifBig : true;
            property int bigWidth : 1050;
            property int bigHeight: 700;
            property int smallWidth : 700;
            property int smallHeight : 467;
            MouseArea{
                anchors.fill: parent;
                hoverEnabled : true;
                onPositionChanged:{
                    var w = fieldCanvas.ifBig ? fieldCanvas.bigWidth : fieldCanvas.smallWidth;
                    var h = fieldCanvas.ifBig ? fieldCanvas.bigHeight : fieldCanvas.smallHeight;
                    var x = Math.floor((1/fieldCanvas.width*mouseX - 0.5)*w);
                    var y = -Math.floor((1/fieldCanvas.height*mouseY- 0.5)*h);
                    mousePos.text = "( " + x  + " , " + y + " )";
                }
            }
            Text{
                id : mousePos;
                text : "";
                x:10;
                y:5;
                color:"white";
                font.pointSize: (Qt.platform.os == "windows") ? 10 : 14;
                font.weight:  Font.Bold;
            }
            Text{
                id : fpsWord;
                text : qsTr("FPS");
                x:parent.width - 70;
                y:5;
                color:"white";
                font.pointSize: (Qt.platform.os == "windows") ? 10 : 14;
                font.weight:  Font.Bold;
            }
            Text{
                id : fps;
                text : "";
                anchors.top: parent.top;
                anchors.topMargin: 5;
                anchors.right: parent.right;
                anchors.rightMargin: 10;
                color:"white";
                font.pointSize: (Qt.platform.os == "windows") ? 10 : 14;
                font.weight:  Font.Bold;
            }
        }
        TabView{
            style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                    color: styleData.selected ? "lightgrey" : "white"
                    implicitWidth: operationPanel.width/operationPanel.count;
                    implicitHeight: 20
                    radius: 2
                    Text {
                        id: text
                        anchors.centerIn: parent
                        text: styleData.title
                        color: styleData.selected ? "black" : "grey"
                    }
                }
                frame: Rectangle { color: "lightgrey" }
            }
            width:window.width - fieldCanvas.width;
            height:fieldCanvas.height;
            id: operationPanel;
            signal fieldOptionChange(bool ifBig);
            property bool fieldIfBig : true;
            Connections{
                target:operationPanel;
                onFieldOptionChange:{
                    operationPanel.fieldIfBig = ifBig;
                }
            }
            Tab{
                id : radio;
                signal leave();
                onVisibleChanged : {
                    radio.leave();
                }
                anchors.fill: parent;
                title: qsTr("Radio") + translator.emptyString;
                Rectangle{
                    width:parent.width;
                    anchors.top: parent.top;
                    anchors.bottom: parent.bottom;
                    color : "lightgrey";
                    id:radioRectangle;
                    GroupBox{
                        id : crazyListRectangle;
                        width: parent.width - 15;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        height: 245;
                        anchors.top: parent.top;
                        anchors.margins: 10;
                        title :qsTr("Sender Setting") + translator.emptyString;
                        ListView{
                            id : crazyListView;
                            delegate:crazyComponent;
                            anchors.left: parent.left;
                            anchors.right:parent.right;
                            anchors.top: parent.top;
                            anchors.bottom: parent.bottom;
                            anchors.margins: 10;
                            interactive:false;
                            spacing: 10;
                            model: [qsTr("Ports")+ translator.emptyString,qsTr("BaudRate")+ translator.emptyString
                                ,qsTr("DataBits")+ translator.emptyString,qsTr("Parity")+ translator.emptyString
                                ,qsTr("StopBits")+ translator.emptyString,qsTr("Frequency")+ translator.emptyString];
                            enabled: !crazyConnect.ifConnected;
                        }
                    }
                    Button{
                        id : crazyConnect;
                        text : (ifConnected ? qsTr("Disconnect") : qsTr("Connect")) + translator.emptyString;
                        property bool ifConnected:false;
                        anchors.top: crazyListRectangle.bottom;
                        anchors.right: parent.right;
                        anchors.rightMargin: 20;
                        anchors.topMargin: 10;
                        onClicked: clickEvent();
//                        Timer{
//                            id:tempTimer;
//                            onTriggered: serial.sendStartPacket();
//                        }
//                        function delay(delayTime) {
//                            tempTimer.interval = delayTime;
//                            tempTimer.repeat = false;
//                            tempTimer.start();
//                        }
                        function clickEvent(){
                            if(ifConnected){
                                timer.stop();
                                if(crazyStart.ifStarted) crazyStart.handleClickEvent();
                                serial.closeSerialPort();
                            }else{
                                serial.openSerialPort();
                                serial.sendStartPacket();
                            }
                            ifConnected = !ifConnected;
                        }
                    }
                    GroupBox{
                        title : qsTr("Manual Control") + translator.emptyString;
                        width:parent.width - 15;
                        anchors.top:crazyConnect.bottom;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.margins: 20;
                        id : groupBox2;
                        Grid{
                            id : crazyShow;
                            columns: 4;
                            rows:5;
                            verticalItemAlignment: Grid.AlignVCenter;
                            horizontalItemAlignment: Grid.AlignLeft;
                            anchors.horizontalCenter: parent.horizontalCenter;
                            columnSpacing: 10;
                            rowSpacing: 5;
                            property int m_VEL : 255
                            property int m_VELR : 1023
                            property int velX : 0;
                            property int velY : 0;
                            property int velR : 0;
                            property bool shoot : false;
                            property bool dribble : false;
                            property int power : 127;
                            property int velStep : 20;
                            property bool mode : false;
                            property int robotID : 0;
                            property int itemWidth : 70;
                            property int velRAddStep : 10;
                            property int limitVelR : 15;
                            Text{ text:qsTr("robot") + translator.emptyString }
                            SpinBox{ minimumValue:0; maximumValue:11; value:parent.robotID; width:parent.itemWidth
                                onEditingFinished:{parent.robotID = value}}
                            Text{ text:" " }
                            Text{ text:" " }
                            Text{ text:qsTr("vel-x") + translator.emptyString }
                            SpinBox{ minimumValue:-crazyShow.m_VEL; maximumValue:crazyShow.m_VEL; value:parent.velX;width:parent.itemWidth
                                onEditingFinished:{parent.velX = value;}}
                            Text{ text:qsTr("dribb") + translator.emptyString }
                            Button{ text:(parent.dribble ? qsTr("true") : qsTr("false")) +translator.emptyString;width:parent.itemWidth
                                onClicked: {
                                    parent.dribble = !parent.dribble;
                                    serial.updateCommandParams(crazyShow.robotID,crazyShow.velX,crazyShow.velY,crazyShow.velR,crazyShow.dribble,crazyShow.mode,crazyShow.shoot,crazyShow.power);
                                }
                            }
                            Text{ text:qsTr("vel-y ") + translator.emptyString}
                            SpinBox{ minimumValue:-crazyShow.m_VEL; maximumValue:crazyShow.m_VEL; value:parent.velY;width:parent.itemWidth
                                onEditingFinished:{parent.velY = value;}}
                            Text{ text:qsTr("shoot") + translator.emptyString}
                            Button{ text:(parent.shoot? qsTr("true") : qsTr("false")) + translator.emptyString;width:parent.itemWidth
                                onClicked: {
                                    parent.shoot = !parent.shoot;
                                    serial.updateCommandParams(crazyShow.robotID,crazyShow.velX,crazyShow.velY,crazyShow.velR,crazyShow.dribble,crazyShow.mode,crazyShow.shoot,crazyShow.power);
                                }
                            }
                            Text{ text:qsTr("vel-r")  + translator.emptyString}
                            SpinBox{ minimumValue:-crazyShow.m_VELR; maximumValue:crazyShow.m_VELR; value:parent.velR;width:parent.itemWidth
                                onEditingFinished:{parent.velR = value;}}
                            Text{ text:qsTr("mode")  + translator.emptyString}
                            Button{ text:(parent.mode?qsTr("lift"):qsTr("flat")) + translator.emptyString;width:parent.itemWidth
                                onClicked: {
                                    parent.mode = !parent.mode
                                    serial.updateCommandParams(crazyShow.robotID,crazyShow.velX,crazyShow.velY,crazyShow.velR,crazyShow.dribble,crazyShow.mode,crazyShow.shoot,crazyShow.power);
                                }
                            }
                            Text{ text:qsTr("step") + translator.emptyString }
                            SpinBox{ minimumValue:1; maximumValue:crazyShow.m_VEL; value:parent.velStep;width:parent.itemWidth
                                onEditingFinished:{parent.velStep = value;}}
                            Text{ text:qsTr("power") + translator.emptyString }
                            SpinBox{ minimumValue:0; maximumValue:127; value:parent.power;width:parent.itemWidth
                                onEditingFinished:{parent.power = value;}}
                            Keys.onPressed:getFocus(event);
                            function getFocus(event){
                                switch(event.key){
                                case Qt.Key_Enter:
                                case Qt.Key_Return:
                                case Qt.Key_Escape:
                                    crazyShow.focus = true;
                                    break;
                                default:
                                    event.accepted = false;
                                    return false;
                                }
                                event.accepted = true;
                            }
                            function handleKeyboardEvent(e){
                                switch(e){
                                case 'U':{crazyShow.mode = !crazyShow.mode;break;}
                                case 'a':{crazyShow.velY = crazyShow.limitVel(crazyShow.velY-crazyShow.velStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                    break;}
                                case 'd':{crazyShow.velY = crazyShow.limitVel(crazyShow.velY+crazyShow.velStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                    break;}
                                case 'w':{crazyShow.velX = crazyShow.limitVel(crazyShow.velX+crazyShow.velStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                    break;}
                                case 's':{crazyShow.velX = crazyShow.limitVel(crazyShow.velX-crazyShow.velStep,-crazyShow.m_VEL,crazyShow.m_VEL);
                                    break;}
                                case 'q':{crazyShow.dribble = !crazyShow.dribble;
                                    break;}
                                case 'e':{crazyShow.shoot = !crazyShow.shoot;
                                    timer.count = 0;
                                    break;}
                                case 'L':{
                                    if (crazyShow.velR < crazyShow.limitVelR && crazyShow.velR > -crazyShow.limitVelR)
                                        crazyShow.velR = crazyShow.limitVel(crazyShow.velR+crazyShow.velRAddStep,-crazyShow.m_VELR,crazyShow.m_VELR);
                                    else
                                        crazyShow.velR = crazyShow.limitVel(crazyShow.velR*1.5,-crazyShow.m_VELR,crazyShow.m_VELR);
                                    timer.count2 = 0;
                                    break;}
                                case 'R':{
                                    if (crazyShow.velR < crazyShow.limitVelR && crazyShow.velR > -crazyShow.limitVelR)
                                        crazyShow.velR = crazyShow.limitVel(crazyShow.velR-crazyShow.velRAddStep,-crazyShow.m_VELR,crazyShow.m_VELR);
                                    else
                                        crazyShow.velR = crazyShow.limitVel(crazyShow.velR*1.5,-crazyShow.m_VELR,crazyShow.m_VELR);
                                    timer.count2 = 0;
                                    break;}
                                case 'S':{crazyShow.velX = 0;
                                        crazyShow.velY = 0;
                                        crazyShow.velR = 0;
                                        crazyShow.shoot = false;
                                        crazyShow.dribble = false;
                                    break;}
                                default:
                                    return false;
                                }
                                updateCommand();
                            }
                            function updateCommand(){
                                serial.updateCommandParams(crazyShow.robotID,crazyShow.velX,crazyShow.velY,crazyShow.velR,crazyShow.dribble,crazyShow.mode,crazyShow.shoot,crazyShow.power);
                            }
                            function limitVel(vel,minValue,maxValue){
                                if(vel>maxValue) return maxValue;
                                if(vel<minValue) return minValue;
                                return vel;
                            }
                            Shortcut{
                                sequence:"A";
                                onActivated:crazyShow.handleKeyboardEvent('a');
                            }
                            Shortcut{
                                sequence:"Up";
                                onActivated:crazyShow.handleKeyboardEvent('U');
                            }
                            Shortcut{
                                sequence:"D"
                                onActivated:crazyShow.handleKeyboardEvent('d');
                            }
                            Shortcut{
                                sequence:"W"
                                onActivated:crazyShow.handleKeyboardEvent('w');
                            }
                            Shortcut{
                                sequence:"S"
                                onActivated:crazyShow.handleKeyboardEvent('s');
                            }
                            Shortcut{
                                sequence:"Q"
                                onActivated:crazyShow.handleKeyboardEvent('q');
                            }
                            Shortcut{
                                sequence:"E"
                                onActivated:crazyShow.handleKeyboardEvent('e');
                            }
                            Shortcut{
                                sequence:"Left"
                                onActivated:crazyShow.handleKeyboardEvent('L');
                            }
                            Shortcut{
                                sequence:"Right"
                                onActivated:crazyShow.handleKeyboardEvent('R');
                            }
                            Shortcut{
                                sequence:"Space"
                                onActivated:crazyShow.handleKeyboardEvent('S');
                            }
                            Connections{
                                target:window;
                                onRadioVelRTimer:{
                                    crazyShow.velR = crazyShow.velR*0.8;
                                    //if (crazyShow.velR > 0) crazyShow.velR = crazyShow.limitVel(crazyShow.velR-crazyShow.velRMinStep,0,crazyShow.m_VELR);
                                    //if (crazyShow.velR < 0) crazyShow.velR = crazyShow.limitVel(crazyShow.velR+crazyShow.velRMinStep,-crazyShow.m_VELR,0);
                                    if (crazyShow.velR < crazyShow.limitVelR && crazyShow.velR > -crazyShow.limitVelR) {
                                        crazyShow.velR = 0;
                                        timer.count2++;
                                    }
                                    crazyShow.updateCommand();
                                }
                            }
                            Connections{
                                target:window;
                                onRadioSendTimer:{
                                    crazyShow.shoot = false;
                                    crazyShow.updateCommand();
                                }
                            }
                        }
                    }
                    Button{
                        id:crazyStart;
                        text:qsTr("Start") + translator.emptyString;
                        property bool ifStarted:false;
                        anchors.right:parent.right;
                        anchors.rightMargin: 20;
                        anchors.top:groupBox2.bottom;
                        anchors.topMargin: 20;
                        enabled : crazyConnect.ifConnected;
                        onClicked:{
                            handleClickEvent();
                        }
                        function handleClickEvent(){
                            if(ifStarted){
                                timer.stop();
                            }else{
                                timer.start();
                            }
                            ifStarted = !ifStarted;
                            text = (ifStarted ? qsTr("Stop") : qsTr("Start")) + translator.emptyString;
                        }
                    }
                    Connections{
                        target:radio;
                        onLeave:{
                            if(crazyConnect.ifConnected){
                                crazyConnect.clickEvent();
                            }
                        }
                    }
                }
            }
            Tab{
                anchors.fill: parent;
                property string title: qsTr("Referee") + translator.emptyString;
                RefereeBox{}
            }
            Tab{
                anchors.fill: parent;
                property string title: qsTr("Vision") + translator.emptyString;
                Rectangle{
                    id:vision;
                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                    color : "lightgrey";
                    property bool en: false;
                    GroupBox{
                        enabled: vision.en;
                        id : visionAddress;
                        width:parent.width*0.9;
                        title:qsTr("Receiver Setting")+translator.emptyString;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        property bool visionGetter : false;
                        Grid{
                            id:inputFields;
                            width:parent.width;
                            columns: 2;
                            columnSpacing: 20;
                            rowSpacing: 5;
                            anchors.horizontalCenter: parent.horizontalCenter;
                            verticalItemAlignment: Grid.AlignVCenter;
                            horizontalItemAlignment: Grid.AlignLeft;
                            Text{
                                id:inputText;
                                text:qsTr("Interface")+translator.emptyString;
                            }
                            ComboBox{
                                id:interfaces;
                                model:interaction.getNetworkInterfaces();width:parent.width - inputText.width - parent.columnSpacing;
                            }
                            Text{
                                text:qsTr("Address")+translator.emptyString;
                            }
                            TextField{
                                id:address;
                                text:interaction.getDefaultVisionAddress();width:parent.width - inputText.width - parent.columnSpacing;
                            }
                            Text{
                                text:qsTr("Port")+translator.emptyString;
                            }
                            TextField{
                                id:port;
                                text:interaction.getDefaultVisionPort(fieldCanvas.ifBig);width:parent.width - inputText.width - parent.columnSpacing;
                            }
                        }
                    }
                    GroupBox{
                        enabled: vision.en;
                        id : visionSender;
                        width:parent.width*0.90;
                        title:qsTr("Transmit Setting")+translator.emptyString;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.top: visionAddress.bottom;
                        anchors.topMargin: 5;
                        Grid{
                            id:senderInputs;
                            columns: 2;
                            columnSpacing: 20;
                            rowSpacing: 5;
                            width:parent.width;
                            anchors.horizontalCenter: parent.horizontalCenter;
                            verticalItemAlignment: Grid.AlignVCenter;
                            horizontalItemAlignment: Grid.AlignLeft;
                            Text{
                                id : senderInput;
                                text:qsTr("Address")+translator.emptyString;
                            }
                            TextField{
                                id:senderAddress;
                                text:interaction.getDefaultVisionSenderAddress();width:parent.width - senderInput.width - parent.columnSpacing;
                            }
                            Text{
                                text:qsTr("Port")+translator.emptyString;
                            }
                            TextField{
                                id:senderPort;
                                text:interaction.getDefaultVisionSenderPort();width:parent.width - senderInput.width - parent.columnSpacing;
                            }
                        }
                        Grid{
                            id:senderInputs2;
                            columns: 2;
                            columnSpacing: 20;
                            rowSpacing: 5;
                            width:parent.width;
                            anchors.horizontalCenter: parent.horizontalCenter;
                            verticalItemAlignment: Grid.AlignVCenter;
                            horizontalItemAlignment: Grid.AlignLeft;
                            anchors.top: senderInputs.bottom;
                            anchors.topMargin: 10;
                            Text{
                                id : senderInput2;
                                text:qsTr("Address")+translator.emptyString;
                            }
                            TextField{
                                id:senderAddress2;
                                text:interaction.getDefaultVisionSenderAddress2();width:parent.width - senderInput.width - parent.columnSpacing;
                            }
                            Text{
                                text:qsTr("Port")+translator.emptyString;
                            }
                            TextField{
                                id:senderPort2;
                                text:interaction.getDefaultVisionSenderPort2();width:parent.width - senderInput.width - parent.columnSpacing;
                            }
                        }
                    }
                    Grid{
                        enabled: vision.en;
                        id : controlGrid;
                        anchors.top: visionSender.bottom;
                        anchors.topMargin: 10;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        columns:3;
                        columnSpacing: 20;
                        rowSpacing: 5;
                        Text{ text:qsTr("Small") + translator.emptyString; }
                        Switch{
                            id:fieldOption;
                            style: SwitchStyle {
                                groove: Rectangle {
                                     implicitWidth: 120
                                     implicitHeight: 20
                                     color:"black";
                                     border.width: 1
                                }
                                handle: Rectangle {
                                    implicitWidth: 60
                                    implicitHeight: 20
                                    color:enabled ? "#f3f3f3" : "#e0e0e0";
                                    border.color:"#a0a0a0";
                                    border.width: 1;
                                    radius: 1;
                                }
                            }
                            checked: true;
                            onCheckedChanged: {
                                fieldCanvas.ifBig = fieldOption.checked;
                                operationPanel.fieldOptionChange(fieldOption.checked);
                                interaction.fieldChange(fieldOption.checked);
                            }
                        }
                        Text{ text:qsTr("Big") + translator.emptyString; }
                    }
                    Button{
                        id:getterButton;
                        text:(visionAddress.visionGetter ? qsTr("Stop") : qsTr("Start")) + translator.emptyString;
                        width:visionSender.width;
                        anchors.top: controlGrid.bottom;
                        anchors.topMargin: 20;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        onClicked: changeGetterState();
                        function changeGetterState(){
                            visionAddress.visionGetter = !visionAddress.visionGetter;
                            run();
                        }
                        function run(){
                            if(visionAddress.visionGetter){
                                vision.en =  false;
                                interaction.startVision(interfaces.currentIndex,address.text,parseInt(port.text),senderAddress.text,parseInt(senderPort.text),senderAddress2.text,parseInt(senderPort2.text));
                            }else{
                                vision.en = true;
                                interaction.stopVision();
                            }
                        }
                        Component.onCompleted: run();
                    }
                }
            }
            Tab{
                anchors.fill: parent;
                property string title: qsTr("Demo") + translator.emptyString;
                Rectangle{
                    property bool fieldIfBig : true;
                    id:demo;
                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                    color : "lightgrey";
                    GroupBox{
                        anchors.top: parent.top;
                        width: parent.width*0.9;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        title:qsTr("Demo")+translator.emptyString;
                        property bool ifYellow : false;
                        Grid{
                            id : teamGrid;
                            anchors.top: parent.top;
                            anchors.horizontalCenter: parent.horizontalCenter;
                            verticalItemAlignment: Grid.AlignVCenter;
                            columns:3;
                            columnSpacing: 20;
                            rowSpacing: 5;
                            Text{ text:qsTr("Yellow") + translator.emptyString; }
                            Switch{
                                id:teamSwitch;
                                style: SwitchStyle {
                                    groove: Rectangle {
                                         implicitWidth: 120
                                         implicitHeight: 20
                                         Rectangle {
                                             implicitWidth: 60;
                                             implicitHeight: 20;
                                             color:"blue";
                                             anchors.left: parent.left;
                                         }
                                         Rectangle {
                                             implicitWidth: 60;
                                             implicitHeight: 20;
                                             color:"yellow";
                                             anchors.right: parent.right;
                                         }
                                         border.width: 1;
                                    }
                                    handle: Rectangle {
                                        implicitWidth: 60
                                        implicitHeight: 20
                                        color:enabled ? "#f3f3f3" : "#e0e0e0";
                                        border.color:"#a0a0a0";
                                        border.width: 1;
                                        radius: 1;
                                    }
                                }
                                checked: true;
                            }
                            Text{ text:qsTr("Blue") + translator.emptyString; }
                        }
                        Grid{
                            id:demoGrid;
                            width:parent.width;
                            columns: 2;
                            columnSpacing: 5;
                            rowSpacing: 5;
                            anchors.horizontalCenter: parent.horizontalCenter;
                            verticalItemAlignment: Grid.AlignVCenter;
                            horizontalItemAlignment: Grid.AlignLeft;
                            anchors.top: teamGrid.bottom;
                            anchors.topMargin: 5;
                            property int itemWidth : (width - columnSpacing*(columns-1)) / columns;
                            property int triggerIndex : -1;
                            Repeater{
                                id : buttons;
                                model:[qsTr("dribble")+translator.emptyString,qsTr("pass")+translator.emptyString,
                                qsTr("advance")+translator.emptyString,qsTr("chip")+translator.emptyString,
                                qsTr("attack")+translator.emptyString,qsTr("defend")+translator.emptyString];
                                Button{
                                    text:modelData;
                                    width:demoGrid.itemWidth;
                                    onClicked: demoGrid.clickEvent(index);
                                }
                            }
                            function clickEvent(index){
                                if (triggerIndex === -1){
                                    interaction.demoStart(teamSwitch.checked,index,operationPanel.fieldIfBig);
                                    for(var i=0;i<buttons.model.length;i++){
                                        buttons.itemAt(i).enabled = false;
                                    }
                                    teamGrid.enabled = false;
                                    buttons.itemAt(index).enabled = true;
                                    buttons.itemAt(index).text = qsTr("Stop")+translator.emptyString;
                                    triggerIndex = index;
                                }else if(triggerIndex === index){
                                    interaction.demoStop(teamSwitch.checked,index,operationPanel.fieldIfBig);
                                    for(var i=0;i<buttons.model.length;i++){
                                        buttons.itemAt(i).enabled = true;
                                    }
                                    teamGrid.enabled = true;
                                    buttons.itemAt(index).text = buttons.model[index];
                                    triggerIndex = -1;
                                }else{
                                    console.log("Demo Model ERROR!");
                                }
                            }
                        }
                    }

                }
            }
        }
        Canvas{
            width:fieldCanvas.width;
            height:window.height - fieldCanvas.height;
            id:monitorCanvas;
        }
        Rectangle{
            width:window.width - fieldCanvas.width;
            height:window.height - fieldCanvas.height;
            id:terminal;
            color:"lightGreen";
            Rectangle{
                width:parent.width;
                height:parent.height > 100 ? 30 : 0;
                anchors.bottom:parent.bottom;
                TextField{
                    id:terminalInput;
                    anchors.fill:parent;
                    placeholderText: qsTr("Enter Command") + translator.emptyString;
                    style: TextFieldStyle {
                        textColor: "black";
                        background: Rectangle {
                            radius: 2;
                            border.color: terminal.color;
                            border.width: 2;
                        }
                    }
                    Keys.onReturnPressed: enter(event);
                    Keys.onEnterPressed: enter(event);
                    function enter(event){
                        var text = terminalInput.text;
                        if(text != ""){
                            commandParser.sendCommand(text);
                            terminalInput.text = "";
                        }
                    }
                }
            }
        }
    }
/*
//    Button{
//        id : language;
//        anchors.bottom: parent.bottom;
//        anchors.right: parent.right;
//        property bool ifEnglish : true;
//        width:30;
//        height:20;
//        text:"";
//        style: ButtonStyle {
//            label: Text {
//                verticalAlignment: Text.AlignVCenter
//                horizontalAlignment: Text.AlignHCenter
//                font.pointSize: 16
//                text:language.text;
//            }
//            background: Rectangle {
//                border.width: 0;
//                color:"transparent";
//            }
//        }
//        onClicked: switchLanguage();
//        function switchLanguage(){
//            var en,zh;
//            if(Qt.platform.os == "osx"){
//                en = "🇬🇧";
//                zh = "🇨🇳";
//            }else{
//                en = "EN";
//                zh = "ZH"
//            }
//            language.ifEnglish = !language.ifEnglish;
//            translator.selectLanguage(language.ifEnglish ? "en" : "zh");
//            language.text = language.ifEnglish ? en : zh;
//        }
//        Component.onCompleted: {
//            language.switchLanguage();
//        }
//    }
*/
    Component.onCompleted:{
        translator.selectLanguage("zh");
        if(Qt.platform.os == "windows"){
            line.visible = true;
        }
    }
    Component{
        id:crazyComponent;
        Item{
            width:parent.width;
            height:25;
            property int itemIndex: index;
            Text{
                anchors.left:parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.leftMargin: 10;
                height:parent.height;
                text: modelData;
                lineHeight: parent.height;
            }
            ComboBox{
                anchors.right:parent.right;
                width:parent.width*0.5;
                height:parent.height;
                model:serial.getCrazySetting(itemIndex);
                currentIndex : serial.getDefaultIndex(itemIndex);
                onActivated: serial.sendCrazySetting(itemIndex,index);
            }
        }
    }
}


