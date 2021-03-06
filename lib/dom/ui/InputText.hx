package dom.ui;

import dom.enums.Style;
import dom.enums.InputType;
import dom.utils.DOM;
import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.InputEvent;
import js.html.InputElement;
import tools.Dispatcher;

/**
 * Поле для ввода однострочного текста.  
 * В DOM представлен тегами: `<label class="input_text">`
 * @see Документация: https://developer.mozilla.org/ru/docs/Web/HTML/Element/Input
 */
@:dce
class InputText extends UIInputComponent
{
    /**
     * Создать новый экземпляр.
     * @param value Введённый текст.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<label>`
     */
    public function new(?value:String, ?node:Element) {
        super(node==null?Browser.document.createLabelElement():node);
        this.node.classList.add(Style.INPUT_TEXT);

        this.nodeInput = DOM.setNodeID(Browser.document.createInputElement());
        this.nodeInput.type = InputType.TEXT;
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
     * Подсказка пользователю о том, что можно ввести в элемент управления.  
     * Текст-заполнитель не должен содержать символов возврата каретки или
     * перевода строки. Этот атрибут применяется, когда значение **типа**
     * атрибута: `text`, `search`, `tel`, `url` или `email`. В противном
     * случае игнорируется.
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
     * Шаблон для ввода.  
     * Регулярное выражение, по которому проверяется значение элемента
     * управления. Шаблон должен соответствовать всему значению, а не
     * только некоторому подмножеству. Используйте атрибут **title**,
     * чтобы описать шаблон, чтобы помочь пользователю. Этот атрибут
     * применяется, когда значение **типа** атрибута `text`, `search`,
     * `tel`, `url` или `email`. В противном случае игнорируется.
     * 
     * Язык регулярных выражений такой же, как и в JavaScript. Шаблон
     * не окружен косой чертой.
     */
    public var pattern(get, set):String;
    inline function get_pattern():String {
        return nodeInput.pattern;
    }
    inline function set_pattern(value:String):String {
        nodeInput.pattern = value;
        return value;
    }

    /**
     * Дочерний узел для элемента ввода. `<input>`  
     * Создаётся автоматически и никогда не может быть удалён.
     * 
     * Не может быть: `null`
     */
    public var nodeInput(default, null):InputElement;

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
    public var evChange(default, never):Dispatcher<InputText->Void> = new Dispatcher();

    /**
     * Событие ввода данных.  
     * - Посылается каждый раз, когда вводится новый символ.
     * - Это событие не посылается при ручном изменении данных:
     *   `value="Hello"`
     * - Событие не посылается, если компонент выключен: `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evInput(default, never):Dispatcher<InputText->Void> = new Dispatcher();

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