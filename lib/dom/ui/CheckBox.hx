package dom.ui;

import dom.enums.Style;
import dom.enums.InputType;
import dom.ui.base.InputUI;
import dom.utils.DOM;
import js.Browser;
import js.html.Event;
import js.html.Element;
import js.html.InputElement;
import tools.Dispatcher;

/**
 * Отображает состояние выбора элемента.  
 * Позволяет пользователю выбрать один или несколько
 * вариантов из группы доступных, когда используется
 * вместе с другими элементами управления CheckBox.
 * 
 * В DOM представлен тегом: `<label class="checkbox">`
 */
@:dce
class CheckBox extends InputUI
{
    /**
     * Создать новый экземпляр.
     * @param label Отображаемый текст.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<label>`
     */
    public function new(?label:String, ?node:Element) {
        super(node==null?Browser.document.createLabelElement():node);
        this.node.classList.add(Style.CHECKBOX);

        this.nodeInput = Browser.document.createInputElement();
        this.nodeInput.type = InputType.CHECKBOX;
        this.nodeInput.addEventListener("change", onChange);

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
    public var evChange(default, never):Dispatcher<Event->Void> = new Dispatcher();

    /**
     * Обновить DOM компонента.  
     * Выполняет перестроение дерева DOM этого элемента
     * интерфейса. Каждый компонент определяет собственное
     * поведение.
     */
    override public function updateDOM():Void {
        DOM.setChilds(node, [
            nodeInput,
            ico==null?                        null:ico,
            nodeLabel==null?                  null:nodeLabel,
            (nodeRequire==null || !required)? null:nodeRequire,
            (nodeError==null || !wrong)?      null:nodeError,
        ]);
    }

    /**
     * Ввод пользователем в элемент.
     * @param e Событие.
     */
    private function onChange(e:Event):Void {
        evChange.emit(e);
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