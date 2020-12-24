package;

import dom.ui.RadioButton;
import dom.display.Stage;
import dom.theme.Theme;
import dom.ui.Button;
import dom.ui.Label;
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
        stage.addChild(lb);
        stage.addChild(bt);
        stage.addChild(inputText);
        stage.addChild(radio1);
        stage.addChild(radio2);
        inputText.name = "Ly2";
        inputText.label = "Wat?";
        inputText.placeholder = "Wy not?";
        inputText.error = "Error msg";
        inputText.isWrong = true;
        inputText.require = "Ну надо";
        inputText.required = true;
        radio1.group = "1";
        radio2.group = "1";
        bt.ico = img;

        bt.onClick.on(function(bt){
            trace("click!");
        });
    }
}