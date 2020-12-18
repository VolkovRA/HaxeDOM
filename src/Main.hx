package;

import dom.display.Stage;
import dom.ui.Image;
import dom.ui.Button;
import dom.ui.Label;
import dom.utils.NativeJS;
import js.Browser;

class Main
{   
    static public function main() {
        trace("Поддержка ResizeObserver: " + NativeJS.isResizeObserverSupported());
        var stage = new Stage(Browser.document.body);

        var lb = new Label("Label");
        var img = new Image("http://www.flasher.ru/forum/images/russian/flasher_logo_2013.gif");
        //var bt = new Button("Button");

        stage.addChild(lb);
        stage.addChild(img);
        //stage.addChild(bt);
    }
}