package;

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
        item.node.classList.add("beautiful");
    }

    private function cleanButton(item:Button):Void {
        item.node.classList.remove("beautiful");
    }
}