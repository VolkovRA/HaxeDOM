package;

import dom.display.Stage;
import dom.theme.Theme;
import dom.ui.Image;
import dom.ui.Button;
import dom.ui.Label;
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
        stage.addChild(lb);
        stage.addChild(img);
        stage.addChild(bt);
        bt.type = "button";
    }
}