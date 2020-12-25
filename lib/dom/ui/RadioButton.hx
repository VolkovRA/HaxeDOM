package dom.ui;

import dom.enums.CSSClass;
import dom.enums.InputType;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.LabelElement;
import js.html.InputElement;

/**
 * Радио-кнопка.  
 * Позволяет пользователю выбрать единственный вариант из
 * группы доступных, когда используется вместе с другими
 * элементами управления RadioButton.
 * 
 * В DOM представлена тегом: `<label class="ui_radio">`
 */
@:dce
class RadioButton extends UIComponent<RadioButton, LabelElement>
{
    /**
     * Создать новый экземпляр.
     * @param label Отображаемый текст.
     */
    public function new(?label:String) {
        super(Browser.document.createLabelElement());
        this.node.classList.add(CSSClass.UI_RADIO);

        this.nodeInput = Browser.document.createInputElement();
        this.nodeInput.type = InputType.RADIO;
        this.nodeInput.addEventListener("change", onInputChange);

        if (label != null)
            this.label = label;
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
     * Дочерний узел для элемента ввода. `<input>`  
     * Создаётся автоматически и никогда не может быть удалён.
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
    override private function updateDOM():Void {
        var arr:Array<Element> = [nodeInput];
        if (ico != null)                        arr.push(ico);
        if (nodeLabel != null)                  arr.push(nodeLabel);
        if (required && nodeRequire != null)    arr.push(nodeRequire);
        if (incorrect && nodeError != null)     arr.push(nodeError);
        NativeJS.set(node, arr);
    }

    /**
     * Ввод пользователем в элемент.
     * @param e Событие.
     */
    private function onInputChange(e:Event):Void {
        onChange.emit(this);
    }

    override function set_disabled(value:Bool):Bool {
        nodeInput.disabled = value;
        return super.set_disabled(value);
    }

    override function set_required(value:Bool):Bool {
        nodeInput.required = value;
        return value;
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