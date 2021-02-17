package dom.ui;

import dom.enums.Style;
import dom.utils.DOM;
import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.TextAreaElement;
import js.html.InputEvent;
import tools.Dispatcher;

/**
 * Поле для ввода многострочного текста.  
 * В DOM представлен тегами: `<label class="textarea">`
 * @see Документация: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea
 */
@:dce
class Textarea extends UIInputComponent
{
    /**
     * Создать новый экземпляр.
     * @param value Введённый текст.
     */
     public function new(?value:String) {
        super(Browser.document.createLabelElement());
        this.node.classList.add(Style.TEXTAREA);

        this.nodeInput = DOM.setNodeID(Browser.document.createTextAreaElement());
        this.nodeInput.addEventListener("input", onInput);
        this.nodeInput.addEventListener("change", onChange);

        if (value != null)
            this.value = value;
        else
            updateDOM();
    }

    /**
     * Введённый текст.  
     * По умолчанию: `""`
     */
    public var value(get, set):String;
    inline function get_value():String {
        return nodeInput.value;
    }
    inline function set_value(value:String):String {
        nodeInput.value = value;
        return value;
    }

    /**
     * Подсказка пользователю о том, что можно ввести в
     * элемент управления. Возврат каретки или перевод
     * строки в тексте-заполнителе должен рассматриваться
     * как разрывы строки при отображении подсказки.
     */
    public var placeholder(get, set):String;
    inline function get_placeholder():String {
        return nodeInput.placeholder;
    }
    inline function set_placeholder(value:String):String {
        nodeInput.placeholder = value;
        return value;
    }

    /**
     * Дочерний узел для элемента ввода. `<textarea>`  
     * Создаётся автоматически и никогда не может быть удалён.
     * 
     * Не может быть: `null`
     */
    public var nodeInput(default, null):TextAreaElement;

    /**
     * Событие изменения введённых данных.  
     * - Посылается при завершении ввода данных в поле. Например,
     *   при потере фокуса после окончания ввода.
     * - Это событие не посылается при ручном изменении данных:
     *   `value="Hello"`
     * - Событие не посылается, если компонент выключен: `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evChange(default, never):Dispatcher<Textarea->Void> = new Dispatcher();

    /**
     * Событие ввода данных.  
     * - Посылается каждый раз, когда вводится новый символ.
     * - Это событие не посылается при ручном изменении данных:
     *   `value="Hello"`
     * - Событие не посылается, если компонент выключен: `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evInput(default, never):Dispatcher<Textarea->Void> = new Dispatcher();

    /**
     * Нативное событие ввода значения.
     * @param e Событие.
     */
    private function onInput(e:InputEvent):Void {
        if (!disabled)
            evInput.emit(this);
    }

    /**
     * Нативное событие изменения значения.
     * @param e Событие.
     */
    private function onChange(e:Event):Void {
        if (!disabled)
            evChange.emit(this);
    }

    /**
     * Обновить DOM этого компонента.
     */
    override private function updateDOM():Void {
        var arr:Array<Element> = [];
        if (ico != null)                        arr.push(ico);
        if (nodeLabel != null)                  arr.push(nodeLabel);
                                                arr.push(nodeInput);
        if (required && nodeRequire != null)    arr.push(nodeRequire);
        if (incorrect && nodeError != null)     arr.push(nodeError);
        DOM.set(node, arr);
    }

    override function set_disabled(value:Bool):Bool {
        nodeInput.disabled = value;
        return super.set_disabled(value);
    }

    override function set_required(value:Bool):Bool {
        nodeInput.required = value;
        return value;
    }
}