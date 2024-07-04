import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 360
    height: 640
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowSystemMenuHint
    title: qsTr("Calculator")

    property string displayText: ""
    property string resultText: "0"
    property string expression: ""
    property bool parenthesisState: false
    property bool waitingForSecret: false
    property bool longPressDetected: false

    function appendNumber(number) {
        if (number === "()") {
            if (parenthesisState === false) {
                displayText === "" ? displayText = "(" : displayText += "(";
                parenthesisState = true;
            } else if (parenthesisState === true) {
                displayText += ")";
                parenthesisState = false;
            }
        }
        else {
            if (displayText.length >= 25) {
                return;
            }
            if (displayText === "") {
                displayText = number;
            } else {
                displayText += number;
            }
        }
        checkSecret();
    }

    function appendOperator(operator) {
        if (operator === "%") {
            let tokens = displayText.split(/([+\-*/])/);
            if (tokens.length === 1) {
                resultText = String(parseFloat(displayText) / 100);
            } else if (tokens.length === 3) {
                let base = parseFloat(tokens[0]);
                let op = tokens[1];
                let percent = parseFloat(tokens[2]);
                let result;
                switch (op) {
                    case "+":
                        result = base + base * percent / 100;
                        break;
                    case "-":
                        result = base - base * percent / 100;
                        break;
                    case "*":
                        result = base * percent / 100;
                        break;
                    case "/":
                        result = base / percent * 100;
                        break;
                }
                resultText = String(result);
                displayText = "";
            }
        } else {
            if (displayText.length >= 25) {
                return;
            }
            displayText += operator;
        }
    }

    function calculate() {
        if (displayText === ""){
            return;
        }
            expression = displayText;
            try {
                resultText = eval(expression);
                if (resultText.includes('e')){
                    resultText = Number(resultText).toExponential(4);
                }
                if (resultText.includes('.')){
                    let parts = resultText.split('.');
                    if(parts[0].length < 8){
                    resultText = Number(resultText).toFixed(9 - parts[0].length);
                    }
                    else{
                        resultText = Number(resultText).toExponential(4);
                    }
                }
                else if (resultText.length > 8){
                    resultText = Number(resultText).toExponential(4);
                }
            } catch (e) {
                resultText = "Error";
            }
            expression = "";
        }

    function clear() {
        displayText = "";
        resultText = "0"
        expression = "";
        longPressDetected = false;
        waitingForSecret = false;
    }

    function checkSecret() {
        if (waitingForSecret && displayText.endsWith("123")) {
            secretWindow.visible = true;
            waitingForSecret = false;
        }
    }

    function toggleSign() {
        if (displayText === "") return;
        let i = displayText.length - 1;
        while (i >= 0) {
            let ch = displayText[i];
            if (ch === '-') {
                if (displayText[i] === 0 || ['+', '*', '/', ')', '('].includes(displayText[i - 1])) {
                    displayText = displayText.substring(0, i) + displayText.substring(i + 1);
                } else {
                    displayText = displayText.substring(0, i) + '+' + displayText.substring(i + 1);
                }
                return;
            } else if (['+', '*', '/', ')', '('].includes(ch)) {
                displayText = displayText.substring(0, i + 1) + '-' + displayText.substring(i + 1);
                return;
            }
            i--;
        }
    }

    Timer {
        id: longPressTimer
        interval: 4000
        repeat: false
        running: false
        onTriggered: {
            longPressDetected = true;
        }
    }

    Timer {
        id: secretInputTimer
        interval: 5000
        repeat: false
        running: false
        onTriggered: {
            waitingForSecret = false;
        }
    }

    Rectangle {
        color: "#024873"
        width: 360
        height: 640
    }

    Rectangle {
        color: "#04bfad"
        width: 360
        height: 200
        y: -20
        radius: 20

    }
    Rectangle {
        anchors.margins: 24
        width: 280
        height: 30
        color: "transparent"
        y: 68

        Text {
            id: display
            text: displayText
            font.pixelSize: 20
            horizontalAlignment: Text.AlignRight
            width: parent.width
            height: parent.height
            color: "white"
        }
    }

    Rectangle {
        anchors.margins: 24
        width: 281
        height: 61
        color: "transparent"
        y: 106

        Text {
            text: resultText
            font.pixelSize: 50
            horizontalAlignment: Text.AlignRight
            width: parent.width
            height: parent.height
            color: "white"
        }
    }

    Rectangle {
        width: 312
        height: 396
        y: 180 + 24
        x: 24
        color: "transparent"

        GridLayout {
            id: grid
            columns: 4
            rows: 5
            rowSpacing: 24
            columnSpacing: 24

            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "()"; onClicked: appendNumber("()"); palette.button: down ? "#f7e425" : "#0889a6"; palette.buttonText: "white"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "+/-"; onClicked: toggleSign(); palette.button: down ? "#f7e425" : "#0889a6"; palette.buttonText: "white"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "%"; onClicked: appendOperator("%"); palette.button: down ? "#f7e425" : "#0889a6"; palette.buttonText: "white"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "÷"; onClicked: appendOperator("/"); palette.button: down ? "#f7e425" : "#0889a6"; palette.buttonText: "white"}

            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "7"; onClicked: appendNumber("7"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "8"; onClicked: appendNumber("8"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "9"; onClicked: appendNumber("9"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "×"; onClicked: appendOperator("*"); palette.button: down ? "#f7e425" : "#0889a6"; palette.buttonText: "white"}

            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "4"; onClicked: appendNumber("4"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "5"; onClicked: appendNumber("5"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "6"; onClicked: appendNumber("6"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "-"; onClicked: appendOperator("-"); palette.button: down ? "#f7e425" : "#0889a6"; palette.buttonText: "white"}

            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "1"; onClicked: appendNumber("1"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "2"; onClicked: appendNumber("2"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "3"; onClicked: appendNumber("3"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "+"; onClicked: appendOperator("+"); palette.button: down ? "#f7e425" : "#0889a6"; palette.buttonText: "white"}

            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "C"; onClicked: clear(); palette.button: down ? "#f8aeae" : "#f25e5e"; palette.buttonText: "white"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "0"; onClicked: appendNumber("0"); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton { font.pixelSize: 30; implicitWidth: 60; implicitHeight: 60; text: "."; onClicked: appendNumber("."); palette.button: down ? "#04bfad" : "#b0d1d8"; palette.buttonText: down ? "white" : "#024873"}
            RoundButton {
                id: secretButton
                font.pixelSize: 30
                implicitWidth: 60
                implicitHeight: 60
                text: "="
                onPressed: {
                    longPressTimer.start();
                }
                onReleased: {
                    if (longPressDetected) {
                        secretInputTimer.start();
                        waitingForSecret = true;
                    } else {
                        calculate();
                    }
                    longPressTimer.stop();
                    longPressDetected = false;
                }
                palette.button: down ? "#f7e425" : "#0889a6"
                palette.buttonText: "white"
            }
        }
    }

    SecretWindow {
        id: secretWindow
    }
}
