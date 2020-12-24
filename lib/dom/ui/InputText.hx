package dom.ui;

import dom.display.Component;
import dom.enums.CSSClass;
import dom.enums.InputType;
import dom.utils.NativeJS;
import js.Browser;
import js.html.LabelElement;
import js.html.Element;
import js.html.InputElement;
import js.html.SpanElement;

/**
 * Поле для ввода однострочного текста.  
 * В DOM представлен тегами: `<label class="ui_input_text">`
 * @see Документация: https://developer.mozilla.org/ru/docs/Web/HTML/Element/Input
 */
@:dce
class InputText extends Component<InputText, LabelElement>
{
    /**
     * Создать новый экземпляр.
     * @param value Введённый текст.
     */
    public function new(?value:String) {
        super(Browser.document.createLabelElement());
        this.node.classList.add(CSSClass.UI_INPUT_TEXT);

        this.nodeInput = NativeJS.indexNode(Browser.document.createInputElement());
        this.nodeInput.type = InputType.TEXT;
        this.node.appendChild(this.nodeInput);

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
     * Текстовое описание поля.  
     * При добавлении текстового описания в DOM добавляется
     * тег `<span>` с переданным описанием.
     * 
     * По умолчанию: `null` *(Без описания поля)*
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
     * Сообщение об ошибке в этом текстовом поле.  
     * Используется для показа ошибки заполнения пользователю.
     * При добавлении текстового описания в DOM добавляется
     * тег `<span>` с переданным описанием.
     * 
     * По умолчанию: `null` *(Без описания поля)*
     */
    public var error(default, set):String = null;
    function set_error(value:String):String {
        if (value == error)
            return value;

        if (value == null) {
            if (nodeError != null)
                nodeError = null;
        }
        else {
            if (nodeError == null) {
                nodeError = Browser.document.createSpanElement();
                nodeError.classList.add(CSSClass.ERROR);
            }
            nodeError.textContent = value;
        }
        error = value;

        updateDOM();
        return value;
    }

    /**
     * Сообщение об необходимости заполнения этого текстового поля.  
     * Используется для показа пользователю текста с сообщением
     * об обязательном требовании заполнения этого поля.
     * При добавлении текстового описания в DOM добавляется
     * тег `<span>` с переданным описанием.
     * 
     * По умолчанию: `null` *(Без текста требования)*
     */
    public var require(default, set):String = null;
    function set_require(value:String):String {
        if (value == require)
            return value;

        if (value == null) {
            if (nodeRequire != null)
                nodeRequire = null;
        }
        else {
            if (nodeRequire == null) {
                nodeRequire = Browser.document.createSpanElement();
                nodeRequire.classList.add(CSSClass.REQUIRE);
            }
            nodeRequire.textContent = value;
        }
        require = value;

        updateDOM();
        return value;
    }

    /**
     * Обязательное требование заполнения этого текстового поля.  
     * Влияет на результат вызова метода этого компонента: `validate()`
     * 
     * По умолчанию: `false` *(Заполнение не обязательно)*
     */
    public var required(get, set):Bool;
    inline function get_required():Bool {
        return nodeInput.required;
    }
    function set_required(value:Bool):Bool {
        if (value)
            node.classList.add(CSSClass.REQUIRED);
        else
            node.classList.remove(CSSClass.REQUIRED);
        nodeInput.required = value;
        return value;
    }

    /**
     * Наличие ошибок заполнения.  
     * Свойство используется для отображения ошибки заполнения.
     * - Если `true`, корневой DOM элемент помечается классом:
     *   `wrong`. Так же показывается сообщение об ошибке, если
     *   задано свойство: `error`
     * - Если `false`, класс с ошибкой удаляется вместе с
     *   сообщением об ошибки.
     * - Это значение каждый раз автоматически изменяется при
     *   вызове метода: `validate()`
     * 
     * По умолчанию: `false` *(Всё хорошо)*
     */
    public var isWrong(default, set):Bool = false;
    function set_isWrong(value:Bool):Bool {
        if (value == isWrong)
            return value;
        isWrong = value;
        if (value)
            node.classList.add(CSSClass.WRONG);
        else
            node.classList.remove(CSSClass.WRONG);
        updateDOM();
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
     * Создаётся автоматический и никогда не может быть удалён.
     * 
     * Не может быть: `null`
     */
    public var nodeInput(default, null):InputElement;

    /**
     * Дочерний узел для отображения текстовой метки. `<span>`  
     * Создаётся или удаляется автоматический в зависимости от
     * наличия указанного значения в свойстве: `InputText.label`
     * 
     * По умолчанию: `null`
     */
    public var nodeLabel(default, null):SpanElement;

    /**
     * Дочерний узел для отображения текстовой метки с текстом
     * обязательного требования. `<span>`  
     * Создаётся или удаляется автоматический в зависимости от
     * наличия указанного значения в свойстве: `InputText.require`
     * 
     * По умолчанию: `null`
     */
    public var nodeRequire(default, null):SpanElement;

    /**
     * Дочерний узел для отображения текстовой метки с текстом
     * ошибки заполнения поля. `<span>`  
     * Создаётся или удаляется автоматический в зависимости от
     * наличия указанного значения в свойстве: `InputText.error`
     * 
     * По умолчанию: `null`
     */
    public var nodeError(default, null):SpanElement;

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
        if (nodeLabel != null)              arr.push(nodeLabel);
                                            arr.push(nodeInput);
        if (nodeRequire != null)            arr.push(nodeRequire);
        if (isWrong && nodeError != null)   arr.push(nodeError);
        NativeJS.set(node, arr);
    }

    override function set_disabled(value:Bool):Bool {
        nodeInput.disabled = value;
        return super.set_disabled(value);
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