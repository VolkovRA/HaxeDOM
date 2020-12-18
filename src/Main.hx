package;

import js.Browser;
import dom.display.Stage;
import dom.ui.Label;
import dom.utils.NativeJS;

class Main
{   
    static public function main() {
        trace("Поддержка ResizeObserver: " + NativeJS.isResizeObserverSupported());
        var stage = new Stage(Browser.document.body);

        var label = new Label("Label");
        stage.addChild(label);
    }
}