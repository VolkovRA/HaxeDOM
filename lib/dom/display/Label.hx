package dom.display;

import dom.enums.CSSClass;
import js.Browser;
import js.html.SpanElement;

/**
 * Простой текст.  
 * В DOM представлена тегом: `<span class="label">`
 */
@:dce
class Label extends Component<Label, SpanElement>
{
    /**
     * Создать новый экземпляр.
     * @param value Отображаемый текст.
     */
    public function new(?value:String) {
        super(Browser.document.createSpanElement());
        this.node.classList.add(CSSClass.LABEL);

        if (value != null)
            this.value = value;
    }

    /**
     * Текст.  
     * По умолчанию: `""` *(Пустая строка)*
     */
    public var value(get, set):String;
    inline function get_value():String {
        return node.innerText;
    }
    inline function set_value(value:String):String {
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