package;

import dom.ui.CheckBox;
import dom.ui.RadioButton;
import dom.display.Stage;
import dom.display.Label;
import dom.theme.Theme;
import dom.ui.Button;
import dom.ui.InputText;
import dom.utils.NativeJS;
import js.Browser;

class Main
{   
    static public function main() {
        Theme.current = new MyTheme();

        trace("Поддержка ResizeObserver: " + NativeJS.isResizeObserverSupported());
        var stage = new Stage(Browser.document.body);
        var img = Browser.document.createImageElement();
        img.src = "http://www.flasher.ru/forum/images/russian/flasher_logo_2013.gif";

        var lb = new Label("Label");
        var bt = new Button("Привет");
        var inputText = new InputText();
        var radio1 = new RadioButton("");
        var radio2 = new RadioButton("Радио-кнопка 2");
        var chkbox1 = new CheckBox("Флажок 1");
        var chkbox2 = new CheckBox("Флажок 2");
        var chkbox3 = new CheckBox("Флажок 3");
        stage.addChild(lb);
        stage.addChild(bt);
        stage.addChild(inputText);
        stage.addChild(radio1);
        stage.addChild(radio2);
        stage.addChild(chkbox1);
        stage.addChild(chkbox2);
        stage.addChild(chkbox3);
        inputText.name = "Ly2";
        inputText.label = "Wat?";
        inputText.labelError = "Error msg";
        inputText.labelRequire = "Ну надо";
        inputText.placeholder = "Wy not?";
        inputText.incorrect = true;
        inputText.required = true;
        radio1.group = "1";
        radio2.group = "1";
        bt.ico = img;
        chkbox1.group = "2";
        chkbox2.group = "2";
        chkbox3.group = "2";
        chkbox3.value = true;
        chkbox2.disabled = true;

        bt.onClick.on(function(bt){
            trace("click!");
            chkbox3.value = null;
        });
    }
}