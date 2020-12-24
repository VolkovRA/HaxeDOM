package dom.ui;

import dom.enums.InputType;
import dom.display.Component;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.LabelElement;
import js.html.SpanElement;
import js.html.InputElement;

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
    static inline private var ON = "on";
    static inline private var OFF = "off";

    /**
     * Создать новый экземпляр.
     * @param text Текст кнопки.
     */
    public function new(?text:String) {
        super(Browser.document.createLabelElement());
        this.node.classList.add("radio");

        this.nodeInput = Browser.document.createInputElement();
        this.nodeInput.type = InputType.RADIO;
        this.nodeInput.addEventListener("change", onInputChange);

        if (text != null)
            this.label = text;
        else
            updateDOM();
    }

    /**
     * Элемент выбран.  
     * Возвращает или задает значение, указывающее на то,
     * проставлен флажок в этом поле или нет.
     * - Флажок равен `true`, если пользователь выбрал данный
     *   элемент.  
     * - При выборе флажка пользователем посылается событие:
     *   `RadioButton.onChange`. Это событие не посылается
     *   при ручном сбросе флажка или при его автоматическом
     *   сбросе из-за выбора другого флажка той же группы.
     * 
     * По умолчанию: `false` *(Флажок не выбран)*
     */
    public var value(get, set):Bool;
    inline function get_value():Bool {
        return nodeInput.checked;
    }
    inline function set_value(value:Bool):Bool {
        nodeInput.checked = value;
        return value;
    }

    /**
     * Текстовое описание флажка.  
     * При добавлении текстового описания в DOM добавляется
     * тег `<span>` с переданным описанием.
     * 
     * По умолчанию: `null` *(Без описания флажка)*
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
                nodeLabel.classList.add("label");
            }
            nodeLabel.textContent = value;
        }
        label = value;

        updateDOM();
        return value;
    }

    /**
     * Группа радио-кнопок.  
     * Используется для группировки кнопок в рамках HTML
     * страницы.
     * - Если не задано, кнопка ни к кому не привязана и
     *   может быть выбрана независимо от всех остальных.
     * - Если указано, кнопки одной группы могут быть
     *   выбраны только по одному. (Суть радио-кнопок)
     * - Вы можете создать несколько групп радио-кнопок
     *   путём присвоения им уникальных имён групп.
     * 
     * По умолчанию: `""` *(Группа не задана)*
     */
    public var group(get, set):String;
    inline function get_group():String {
        return nodeInput.name;
    }
    inline function set_group(value:String):String {
        nodeInput.name = value;
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
     * наличия указанного значения в свойстве: `RadioButton.label`
     * 
     * По умолчанию: `null`
     */
    public var nodeLabel(default, null):SpanElement;

    /**
     * Дочерний узел для элемента ввода. `<input>`  
     * Создаётся автоматический и никогда не может быть удалён.
     * 
     * Не может быть: `null`
     */
    public var nodeInput(default, null):InputElement;

    /**
     * Событие переключения выбора.  
     * - Это событие посылается только при выборе пользователем,
     *   когда он своими ручками клацнул по кнопке и установил её
     *   в: `RadioButton.value=true`
     * - Это событие не посылается при ручном изменении значения
     *   в свойстве: `RadioButton.value=true`
     * 
     * Не может быть: `null`
     */
    public var onChange(default, null):Dispatcher<RadioButton->Void> = new Dispatcher();

    /**
     * Обновить DOM для этого компонента.
     */
    private function updateDOM():Void {
        var arr:Array<Element> = [nodeInput];
        if (ico != null)        arr.push(ico);
        if (nodeLabel != null)  arr.push(nodeLabel);
        NativeJS.set(node, arr);
    }

    /**
     * Ввод пользователем в элемент.
     * @param e Событие.
     */
    private function onInputChange(e:Event):Void {
        onChange.emit(this);
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