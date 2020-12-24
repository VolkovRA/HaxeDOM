package dom.ui;

import dom.display.Component;
import dom.enums.CSSClass;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.MouseEvent;
import js.html.SpanElement;

/**
 * Обычная кнопка.  
 * В DOM представлена тегом: `<button class="ui_button">`
 */
@:dce
class Button extends Component<Button, ButtonElement>
{
    /**
     * Создать новый экземпляр.
     * @param label Текст на кнопке.
     */
    public function new(?label:String) {
        super(Browser.document.createButtonElement());
        this.node.classList.add(CSSClass.UI_BUTTON);
        this.node.addEventListener("click", onButtonClick);

        if (label != null)
            this.label = label;
        else
            updateDOM();
    }

    /**
     * Текст на кнопке.  
     * При добавлении текстового описания в DOM добавляется
     * тег `<span>` с переданным описанием.
     * 
     * По умолчанию: `null` *(Кнопка без текста)*
     */
    public var label(default, set):String = null;
    function set_label(value:String):String {
        if (value == label)
            return value;

        if (value == null) {
            if (nodeLabel != null)
                nodeLabel = null;
        }
        else {
            if (nodeLabel == null) {
                nodeLabel = Browser.document.createSpanElement();
                nodeLabel.classList.add(CSSClass.LABEL);
            }
            nodeLabel.textContent = value;
        }
        label = value;

        updateDOM();
        return value;
    }

    /**
     * Иконка на кнопке.  
     * Вы можете указать произвольный DOM элемент, который
     * будет использоваться в качестве иконки или картинки.
     * Этот элемент автоматически добавится в DOM.
     * 
     * По умолчанию: `null`
     */
    public var ico(default, set):Element = null;
    function set_ico(value:Element):Element {
        if (value == ico)
            return value;
        ico = value;
        updateDOM();
        return value;
    }

    /**
     * Дочерний узел для отображения текстовой метки. `<span>`  
     * Создаётся или удаляется автоматический в зависимости от
     * наличия указанного значения в свойстве: `Button.label`
     * 
     * По умолчанию: `null`
     */
    public var nodeLabel(default, null):SpanElement;

    /**
     * Событие клика на кнопку.  
     * - Диспетчерезируется при нажатии на кнопку пользователем.
     * - Это событие не посылается, если кнопка выключена: `Button.disabled=true`
     * 
     * Не может быть: `null`
     */
    public var onClick(default, null):Dispatcher<Button->Void> = new Dispatcher();

    override function set_disabled(value:Bool):Bool {
        node.disabled = value;
        return super.set_disabled(value);
    }

    /**
     * Нативное событие клика.
     * @param e Событие.
     */
    private function onButtonClick(e:MouseEvent):Void {
        if (!disabled)
            onClick.emit(this);
    }

    /**
     * Обновить DOM для этого компонента.
     */
    private function updateDOM():Void {
        var arr:Array<Element> = [];
        if (ico != null)        arr.push(ico);
        if (nodeLabel != null)  arr.push(nodeLabel);
        NativeJS.set(node, arr);
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Button]";
    }
}