package dom.ui;

import dom.display.Component;
import dom.enums.InputType;
import dom.utils.NativeJS;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.html.InputElement;
import js.html.SpanElement;

/**
 * Поле для ввода однострочного текста.  
 * В DOM представлен тегами: `<div class="input_text">`
 * @see Документация: https://developer.mozilla.org/ru/docs/Web/HTML/Element/Input
 */
@:dce
class InputText extends Component<InputText, DivElement>
{
    /**
     * Создать новый экземпляр.
     * @param value Введённый текст.
     */
    public function new(?value:String) {
        super(Browser.document.createDivElement());

        this.node.classList.add("input_text");
        this.nodeInput = NativeJS.indexNode(Browser.document.createInputElement());
        this.nodeInput.type = InputType.TEXT;
        this.node.appendChild(this.nodeInput);

        this.nodeLabel = NativeJS.indexNode(Browser.document.createSpanElement());
        this.nodeLabel.classList.add("label");

        this.nodeRequire = NativeJS.indexNode(Browser.document.createSpanElement());
        this.nodeRequire.classList.add("required");

        this.nodeError = NativeJS.indexNode(Browser.document.createSpanElement());
        this.nodeError.classList.add("error");

        if (value != null)
            this.value = value;
    }

    /**
     * Дочерний `<input>` узел для ввода текста.  
     * Не может быть: `null`
     */
    public var nodeInput(default, null):InputElement;

    /**
     * Дочерний `<span>` узел для отображения текстовой метки.  
     * Не может быть: `null`
     */
    public var nodeLabel(default, null):SpanElement;

    /**
     * Дочерний `<span>` узел для отображения текста обязательного ввода.  
     * Не может быть: `null`
     */
    public var nodeRequire(default, null):SpanElement;

    /**
     * Дочерний `<span>` узел для отображения текста с ошибкой.  
     * Не может быть: `null`
     */
    public var nodeError(default, null):SpanElement;

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
     * Наименование текстового поля.  
     * По умолчанию: `null`
     */
    public var label(default, set):String = null;
    function set_label(value:String):String {
        if (value == label)
            return value;
        label = value;
        if (value == null)
            nodeLabel.textContent = "";
        else
            nodeLabel.textContent = value;
        updateDOM();
        return value;
    }

    /**
     * Сообщение об ошибке в этом текстовом поле.  
     * По умолчанию: `null`
     */
    public var error(default, set):String = null;
    function set_error(value:String):String {
        if (value == error)
            return value;
        error = value;
        if (value == null)
            nodeError.textContent = "";
        else
            nodeError.textContent = value;
        updateDOM();
        return value;
    }

    /**
     * Сообщение о требованиях для этого текстового поля.  
     * По умолчанию: `null`
     */
    public var require(default, set):String = null;
    function set_require(value:String):String {
        if (value == require)
            return value;
        require = value;
        if (value == null)
            nodeRequire.textContent = "";
        else
            nodeRequire.textContent = value;
        updateDOM();
        return value;
    }

    /**
     * Обязательное требование заполнения этого текстового поля.  
     * Влияет на результат вызова метода этого компонента: `validate()`
     * 
     * По умолчанию: `false` *(Не обязательно)*
     */
    public var required(default, set):Bool = false;
    function set_required(value:Bool):Bool {
        nodeInput.required = value;
        return value;
    }

    /**
     * Наличие ошибок.  
     * Свойство используется для отображения ошибки заполнения.
     * - Если `true`, этот DOM узел помечается атрибутом: `<div wrong="wrong">`.
     *   Также показывается сообщение об ошибке, если оно задано в
     *   свойстве: `error`
     * - Если `false`, атрибут `wrong` удаляется, как и сообщение об ошибке.
     * - Это значение автоматически изменяется при вызове метода: `validate()`
     * 
     * По умолчанию: `false` *(Всё хорошо)*
     */
    public var isWrong(default, set):Bool = false;
    function set_isWrong(value:Bool):Bool {
        if (value == isWrong)
            return value;
        isWrong = value;
        if (value)
            node.setAttribute("wrong", "wrong");
        else
            node.removeAttribute("wrong");
        updateDOM();
        return value;
    }

    /**
     * Подсказка пользователю о том, что можно ввести в элемент управления.  
     * Текст-заполнитель не должен содержать символов возврата каретки или
     * перевода строки. Этот атрибут применяется, когда значение **типа**
     * атрибута `text`, `search`, `tel`, `url` или `email`. В противном
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
     * Проверить корректность заполнения поля.  
     * - Возвращает: `true`, если поле заполнено корректно.
     * - Возвращает: `false`, если есть какие либо ошибки заполнения.
     * - Вызов этого метода автоматически переключает свойство: `isWrong`.
     * @return Поле заполнено корректно.
     */
    public function validate():Bool {
        isWrong = false;
        return true;
    }

    /**
     * Обновить DOM этого компонента.
     */
    private function updateDOM():Void {
        var arr:Array<Element> = [];
        if (label != null)              arr.push(nodeLabel);
                                        arr.push(nodeInput);
        if (require != null)            arr.push(nodeRequire);
        if (isWrong && error != null)   arr.push(nodeError);
        NativeJS.set(node, arr);
    }

    override function set_disabled(value:Bool):Bool {
        if (value)
            nodeInput.disabled = true;
        else
            nodeInput.disabled = false;

        return super.set_disabled(value);
    }

    override function set_name(value:String):String {
        nodeInput.name = value;
        return super.set_name(value);
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[InputText]";
    }
}