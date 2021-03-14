package dom.ui;

import dom.enums.Style;
import dom.enums.InputType;
import dom.ui.base.InputUI;
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
class InputText extends InputUI
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
        this.autocomplete = true;

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
     * Авто-заполнение поля браузером.  
     * Если не не указано, тогда браузер использует атрибут
     * `autocomplete` формы, которая является родительской
     * для данного компонента.
     * - Если: `null`, авто-заполнение по умолчанию используется.
     * - Если: `true`, авто-заполнение принудительно используется.
     * - Если: `false`, авто-заполнение принудительно выключено.
     * 
     * По умолчанию: `null` *(Авто-заполнение включено по умолчанию)*
     * 
     * @see https://developer.mozilla.org/ru/docs/Web/HTML/Element/Input
     */
    public var autocomplete(default, set):Bool = null;
    function set_autocomplete(value:Bool):Bool {
        if (value == autocomplete)
            return value;

        if (value == null) {
            autocomplete = null;
            nodeInput.removeAttribute("autocomplete");
        }
        else if (value) {
            autocomplete = true;
            nodeInput.setAttribute("autocomplete", "on");
        }
        else {
            autocomplete = false;
            nodeInput.setAttribute("autocomplete", "off");
        }
        return value;
    }

    /**
     * Автоматический фокус на это поле.  
     * Позволяет указать браузеру, что это поле должно
     * иметь фокус по умолчанию для ввода на странице.
     * - Только один элемент на старнице должен иметь авто-фокус.
     * - Авто-фокус нельзя указать для скрытых элементов ввода. 
     * 
     * По умолчанию: `false` *(Авто-фокус не задан)*
     */
    public var autofocus(default, set):Bool = false;
    function set_autofocus(value:Bool):Bool {
        if (value == autofocus)
            return value;

        if (value) {
            autocomplete = true;
            nodeInput.autofocus = true;
        }
        else {
            autocomplete = false;
            nodeInput.removeAttribute("autofocus");
        }
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
    public var evChange(default, never):Dispatcher<Event->Void> = new Dispatcher();

    /**
     * Событие ввода данных.  
     * - Посылается каждый раз, когда вводится новый символ.
     * - Это событие не посылается при ручном изменении данных:
     *   `value="Hello"`
     * - Событие не посылается, если компонент выключен: `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evInput(default, never):Dispatcher<InputEvent->Void> = new Dispatcher();

    /**
     * Нативное событие ввода значения.
     * @param e Событие.
     */
    private function onInput(e:InputEvent):Void {
        evInput.emit(e);
    }

    /**
     * Нативное событие изменения значения.
     * @param e Событие.
     */
    private function onChange(e:Event):Void {
        evChange.emit(e);
    }

    /**
     * Обновить DOM компонента.  
     * Выполняет перестроение дерева DOM этого элемента
     * интерфейса. Каждый компонент определяет собственное
     * поведение.
     */
    override public function updateDOM():Void {
        DOM.setChilds(node, [
            ico==null?                        null:ico,
            nodeLabel==null?                  null:nodeLabel,
            nodeInput,
            (nodeRequire==null || !required)? null:nodeRequire,
            (nodeError==null || !wrong)?      null:nodeError,
        ]);
    }

    override function set_disabled(value:Bool):Bool {
        if (value == disabled)
            return value;

        if (value) {
            super.disabled = true;
            nodeInput.disabled = true;
        }
        else {
            super.disabled = false;
            nodeInput.disabled = false;
        }
        return value;
    }

    override function set_required(value:Bool):Bool {
        if (value == required)
            return value;

        if (value) {
            super.required = true;
            nodeInput.required = true;
        }
        else {
            super.required = false;
            nodeInput.required = false;
        }
        return value;
    }
}