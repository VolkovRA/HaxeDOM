package;

import dom.ui.Label;
import dom.ui.Image;
import dom.ui.Button;
import dom.theme.Theme;

/**
 * Произвольная тема оформления для примера.
 */
class MyTheme extends Theme
{
    public function new() {
        super();

        add("button", applyButton, cleanButton);
    }

    private function applyButton(item:Button):Void {
        var ico = new Image("https://pngicon.ru/file/uploads/like-256x256.png");
        var label = new Label("Кнопка");
        item.addChild(ico);
        item.addChild(label);
    }

    private function cleanButton(item:Button):Void {
        item.removeChildren();
    }
}