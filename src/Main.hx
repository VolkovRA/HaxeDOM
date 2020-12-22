package;

import dom.display.Stage;
import dom.theme.Theme;
import dom.ui.Image;
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

        var lb = new Label("Label");
        lb.disabled = true;
        var img = new Image("http://www.flasher.ru/forum/images/russian/flasher_logo_2013.gif");
        var bt = new Button();
        bt.label = "Привет";
        bt.ico = Browser.document.createImageElement();
        untyped bt.ico.src = "https://avatanplus.com/files/resources/small/5a3f65e5b960e16087a6097f.png";
        var inputText = new InputText();
        stage.addChild(lb);
        stage.addChild(img);
        stage.addChild(bt);
        stage.addChild(inputText);
        bt.type = "button";

        trace(inputText.value == "");
        //inputText.disabled = true;
        inputText.name = "Ly2";
        inputText.label = "Wat?";
        inputText.require = "Require text";
        inputText.isWrong = true;
        inputText.placeholder = "Wy not?";
        inputText.error = "Ошибко";
        //inputText.isWrong = false;
        trace(inputText.toString());

    }
}