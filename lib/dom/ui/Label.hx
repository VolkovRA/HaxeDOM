package dom.ui;

import js.Browser;
import js.html.SpanElement;
import dom.display.Component;

/**
 * Текстовая метка.  
 * Представлена обычным span тегом в DOM.
 */
class Label extends Component<Label, SpanElement>
{
    /**
     * Создать обычное, текстовое поле.
     * @param text Текст в текстовом поле.
     */
    public function new(text:String = "") {
        super(Browser.document.createSpanElement());
        this.node.classList.add("label");
        this.text = text;
    }

    /**
     * Текст.  
     * По умолчанию: `""`
     */
    public var text(default, set):String = "";
    function set_text(value:String):String {
        if (value == text)
            return value;

        text = value;
        node.innerText = value;
        return value;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Label]";
    }
}