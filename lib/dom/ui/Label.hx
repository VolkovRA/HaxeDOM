package dom.ui;

import js.Browser;
import js.lib.Error;
import js.html.Element;
import js.html.SpanElement;
import dom.display.Component;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;

/**
 * Текстовая метка.  
 * Представлена обычным span тегом в DOM.
 */
class Label extends Component<Label, SpanElement>
{
    /**
     * Создать HTML компонент.
     */
    public function new() {
        super(Browser.document.createSpanElement());
        this.node.classList.add("label");
    }



    //////////////////
    //   СВОЙСТВА   //
    //////////////////



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Label]";
    }



    ////////////////
    //   ПРИВАТ   //
    ////////////////

    
}