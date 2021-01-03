package dom.ui;

import dom.enums.CSSClass;
import dom.enums.InputType;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.InputElement;

/**
 * Отображает состояние выбора элемента.  
 * Позволяет пользователю выбрать один или несколько
 * вариантов из группы доступных, когда используется
 * вместе с другими элементами управления CheckBox.
 * 
 * В DOM представлен тегом: `<label class="checkbox">`
 */
@:dce
class CheckBox extends UIInputComponent
{
    /**
     * Создать новый экземпляр.
     * @param label Отображаемый текст.
     */
    public function new(?label:String) {
        super(Browser.document.createLabelElement());
        this.node.classList.add(CSSClass.CHECKBOX);

        this.nodeInput = Browser.document.createInputElement();
        this.nodeInput.type = InputType.CHECKBOX;
        this.nodeInput.addEventListener("change", onInputChange);

        this.onChange = new Dispatcher();

        if (label != null)
            this.label = label;
        else
            updateDOM();
    }

    /**
     * Значение флажка.  
     * Это свойство может иметь три типа значения:
     * - Содержит `true`, если пользователь установил флажок.
     * - Содержит `false`, если пользователь снял флажок.
     * - Содержит `null`, если значение флажка не определено.
     *   Такое может быть у флажков, состояние которых зависит
     *   от других флажков, имеющих различные значения.
     * 
     * По умолчанию: `false` *(Флажок не установлен)*
     */
    public var value(get, set):Null<Bool>;
    function get_value():Null<Bool> {
        if (nodeInput.indeterminate)
            return null;
        else if (nodeInput.checked)
            return true;
        else
            return false;
    }
    function set_value(value:Null<Bool>):Null<Bool> {
        if (value == null) {
            nodeInput.indeterminate = true;
        }
        else if (value) {
            nodeInput.indeterminate = false;
            nodeInput.checked = true;
        }
        else {
            nodeInput.indeterminate = false;
            nodeInput.checked = false;
        }
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
     * - Диспетчерезируется при переключении значения флажка
     *   в свойстве: `CheckBox.value`
     * - Это событие не посылается при ручном изменении значения
     *   флажка.
     * 
     * Не может быть: `null`
     */
    public var onChange(default, null):Dispatcher<CheckBox->Void>;

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
        return "[CheckBox]";
    }
}