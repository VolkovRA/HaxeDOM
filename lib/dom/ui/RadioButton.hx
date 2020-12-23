package dom.ui;

import dom.enums.InputType;
import dom.display.Component;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.html.LabelElement;
import js.html.PointerEvent;
import js.html.SpanElement;
import js.html.InputElement;
import js.lib.Error;

/**
 * Кнопка с исключающим выбором.  
 * Позволяет пользователю выбрать единственный вариант из
 * группы доступных, когда используется вместе с другими
 * элементами управления RadioButton.
 * 
 * В DOM представлена тегом: `<label class="radio">`
 */
@:dce
class RadioButton extends Component<RadioButton, LabelElement>
{
    /**
     * Создать новый экземпляр.
     * @param text Текст на кнопке.
     */
    public function new(?text:String) {
        super(Browser.document.createLabelElement());
        this.node.classList.add("radio");

        this.nodeLabel = Browser.document.createSpanElement();
        this.nodeLabel.classList.add("label");

        this.nodeInput = Browser.document.createInputElement();
        this.nodeInput.classList.add("input");
        this.nodeInput.type = InputType.RADIO;

        if (text != null)
            this.label = text;
        else
            updateDOM();
    }

    /**
     * Элемент выбран.  
     * Возвращает или задает значение, указывающее, выбран
     * ли данный элемент управления.
     */
    public var checked(default, set):Bool = false;
    function set_checked(value:Bool):Bool {
        if (value == checked)
            return value;
        checked = value;
        nodeInput.value = "11";
        updateDOM();
        onChecked.emit(this);
        return value;
    }

    /**
     * Текст на кнопке.  
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
     * Группа радиокнопок.  
     * Используется для группировки кнопок в рамках Haxe
     * приложения
     */
    public var group(default, set):String = null;
    function set_group(value:String):String {
        if (value == group)
            return value;


        return value;
    }

    /**
     * Иконка на кнопке.  
     * Вы можете указать произвольный элемент, который будет
     * добавлен в DOM дерево радио-кнопки.
     * 
     * По умолчанию: `null`
     */
    public var ico(default, set):Element = null;
    function set_ico(value:Element):Element {
        if (value == ico)
            return value;
        ico = value;
        if (value != null)
            NativeJS.indexNode(value);
        updateDOM();
        return value;
    }

    /**
     * Дочерний `<span>` узел для отображения текстовой метки.  
     * Не может быть: `null`
     */
    public var nodeLabel(default, null):SpanElement;

    /**
     * Дочерний `<span>` узел для отображения текстовой метки.  
     * Не может быть: `null`
     */
    public var nodeInput(default, null):InputElement;

    /**
     * Событие переключения выбора.  
     * Посылается при изменении значения в свойстве: `RadioButton.checked`
     * 
     * Не может быть: `null`
     */
    public var onChecked(default, null):Dispatcher<RadioButton->Void> = new Dispatcher();

    /**
     * Обновить DOM для этого компонента.
     */
    private function updateDOM():Void {
        if (checked) {
            if (node.getAttribute("checked") != "true")
                node.setAttribute("checked", "true");
        }
        else {
            if (node.getAttribute("checked") != "false")
                node.setAttribute("checked", "false");
        }

        var arr:Array<Element> = [nodeInput];
        if (ico != null)    arr.push(ico);
        if (label != null)  arr.push(nodeLabel);
        NativeJS.set(node, arr);
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[RadioButton]";
    }
}