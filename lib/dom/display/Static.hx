package dom.display;

import js.Browser;
import js.html.Element;

/**
 * Статический HTML контент.  
 * В DOM представлен тегом: `<div>`. *(По умолчанию)*
 */
@:dce
class Static extends Component
{
    /**
     * Создать новый экземпляр.
     * @param html HTML Контент.
     * @param node HTML DOM Элемент, представляющий этот объект. *(По умолчанию: `<div>`)*
     */
    public function new(?html:String, ?node:Element) {
        super(node==null?Browser.document.createDivElement():node);

        if (html != null)
            this.html = html;
    }

    /**
     * HTML Контент.  
     * Это свойство полностью эквивалентно: `node.innerHTML`
     * 
     * По умолчанию: `""`
     */
    public var html(get, set):String;
    inline function get_html():String {
        return node.innerHTML;
    }
    inline function set_html(value:String):String {
        node.innerHTML = value;
        return value;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Static]";
    }
}