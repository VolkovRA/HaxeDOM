package dom.ui;

import dom.display.Component;
import dom.enums.CSSClass;
import dom.enums.InputType;
import js.Browser;
import js.html.InputElement;

/**
 * Базовое поле для ввода данных.  
 * В DOM представлен тегом: `<input class="ui_input">`
 * @see Документация: https://developer.mozilla.org/ru/docs/Web/HTML/Element/Input
 */
@:dce
class Input extends Component<Input, InputElement>
{
    /**
     * Создать новый экземпляр.
     * @param type Тип поля ввода.
     */
    public function new(type:InputType) {
        super(Browser.document.createInputElement());
        this.node.type = type;
        this.node.classList.add(CSSClass.UI_INPUT);
    }

    /**
     * Начальное значение элемента управления.  
     * Этот атрибут является необязательным, за исключением случаев, когда
     * значение атрибута **type** равно `radio` или `checkbox`.
     * 
     * Обратите внимание, что при перезагрузке страницы Gecko и IE
     * [будут игнорировать значение, указанное в источнике HTML](https://bugzilla.mozilla.org/show_bug.cgi?id=46845#c186),
     * если значение было изменено до перезагрузки.
     */
    public var value(get, set):String;
    inline function get_value():String {
        return node.value;
    }
    inline function set_value(value:String):String {
        node.value = value;
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
        return node.placeholder;
    }
    inline function set_placeholder(value:String):String {
        node.placeholder = value;
        return value;
    }

    /**
     * Обязательное поле.  
     * Этот атрибут указывает, что пользователь должен заполнить значение
     * перед отправкой формы. Она не может быть использован, когда **тип**
     * атрибута `hidden`, `image` или тип кнопки (`submit`, `reset` или
     * `button`). В [:optional](https://developer.mozilla.org/ru/docs/Web/CSS/:optional)
     * и [:requiredCSS](https://developer.mozilla.org/ru/docs/Web/CSS/:required)
     * псевдо-классы будут применены к полю соответственно.
     * 
     * По умолчанию: `false` *(Заполнение не обязательно)*
     */
    public var required(get, set):Bool;
    inline function get_required():Bool {
        return node.required;
    }
    function set_required(value:Bool):Bool {
        if (value)
            node.classList.add(CSSClass.REQUIRED);
        else
            node.classList.remove(CSSClass.REQUIRED);
        node.required = value;
        return value;
    }

    /**
     * Когда значение атрибута **type** равно `radio` или `checkbox`,
     * наличие этого логического атрибута указывает на то, что элемент
     * управления выбран по умолчанию. В противном случае игнорируется.
     */
    public var checked(get, set):Bool;
    inline function get_checked():Bool {
        return node.checked;
    }
    inline function set_checked(value:Bool):Bool {
        node.checked = value;
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
        return node.pattern;
    }
    inline function set_pattern(value:String):String {
        node.pattern = value;
        return value;
    }

    override function set_disabled(value:Bool):Bool {
        if (value)
            node.disabled = true;
        else
            node.disabled = false;

        return super.set_disabled(value);
    }

    override function set_name(value:String):String {
        node.name = value;
        return super.set_name(value);
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Input]";
    }
}