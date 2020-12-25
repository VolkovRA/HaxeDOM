package dom.ui;

import js.html.PointerEvent;
import dom.enums.CSSClass;
import dom.enums.InputType;
import dom.utils.Cross;
import dom.utils.Dispatcher;
import dom.utils.LongCall;
import dom.utils.NativeJS;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.DivElement;

/**
 * Обычная кнопка.  
 * В DOM представлена тегом: `<div class="ui_stepper">`
 */
@:dce
class Stepper extends UIComponent<Stepper, DivElement>
{
    /**
     * Создать новый экземпляр.
     * @param label Текст на кнопке.
     */
    public function new() {
        super(Browser.document.createDivElement());
        this.node.classList.add(CSSClass.UI_STEPPER);

        this.nodeInput = Browser.document.createInputElement();
        this.nodeInput.type = InputType.NUMBER;
        this.nodeInput.addEventListener("input", onNativeInput);
        this.nodeInput.addEventListener("change", onNativeChange);

        this.nodeDecrement = Browser.document.createButtonElement();
        this.nodeDecrement.classList.add(CSSClass.UI_BUTTON_DEC);
        this.nodeDecrement.addEventListener("pointerdown", onDecDown);
        this.nodeDecrement.textContent = "-";

        this.nodeIncrement = Browser.document.createButtonElement();
        this.nodeIncrement.classList.add(CSSClass.UI_BUTTON_INC);
        this.nodeIncrement.addEventListener("pointerdown", onIncDown);
        this.nodeIncrement.textContent = "+";

        updateDOM();
    }

    /**
     * Значение счётчика.  
     */
    public var value(get, set):Null<Float>;
    function get_value():Null<Float> {
        var v = NativeJS.parseFloat(nodeInput.value);
        return NativeJS.isNaN(v)?null:v;
    }
    inline function set_value(value:Null<Float>):Null<Float> {
        nodeInput.value = untyped value;
        return value;
    }

    /**
     * Минимальное значение.  
     * Если значение `value` меньше этого значения, элемент
     * не проходит [проверку ограничения](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5/Constraint_validation).
     * 
     * Это значение должно быть меньше или равно значению `max`
     * атрибута.
     * 
     * По умолчанию: `null` *(Минимум не задан)*
     */
    public var min(get, set):Null<Float>;
    function get_min():Null<Float> {
        var v = NativeJS.parseFloat(nodeInput.min);
        return NativeJS.isNaN(v)?null:v;
    }
    inline function set_min(value:Null<Float>):Null<Float> {
        nodeInput.min = untyped value;
        return value;
    }

    /**
     * Максимальное значение.  
     * Если значение `value` превышает это значение, элемент
     * не проходит [проверку ограничения](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5/Constraint_validation).
     * 
     * Это значение должно быть больше или равно значению `min`
     * атрибута.
     * 
     * По умолчанию: `null` *(Максимум не ограничен)*
     */
    public var max(get, set):Null<Float>;
    function get_max():Null<Float> {
        var v = NativeJS.parseFloat(nodeInput.max);
        return NativeJS.isNaN(v)?null:v;
    }
    inline function set_max(value:Null<Float>):Null<Float> {
        nodeInput.max = untyped value;
        return value;
    }

    /**
     * Шаг.  
     * Шаговый интервал, используемый при использовании стрелок
     * вверх и вниз для настройки значения, а также для проверки.
     * 
     * По умолчанию: `null` *(Шаг не задан)*
     */
    public var step(get, set):Null<Float>;
    function get_step():Null<Float> {
        var v = NativeJS.parseFloat(nodeInput.step);
        return NativeJS.isNaN(v)?null:v;
    }
    function set_step(value:Null<Float>):Null<Float> {
        nodeInput.step = untyped value;
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
     * Дочерний узел для кнопки **плюс**  
     * Создаётся автоматически.
     * 
     * Не может быть: `null`
     */
    public var nodeIncrement(default, null):ButtonElement;

    /**
     * Дочерний узел для кнопки **минус**  
     * Создаётся автоматически.
     * 
     * Не может быть: `null`
     */
    public var nodeDecrement(default, null):ButtonElement;

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
     * Событие ввода данных.
     * - Посылается каждый раз, когда вводится новый символ.
     * - Это событие не посылается при ручном изменении данных:
     *   `value="Hello"`
     * - Событие не посылается, если компонент выключен: `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var onInput(default, null):Dispatcher<InputText->Void> = new Dispatcher();

    /**
     * Обновить DOM для этого компонента.
     */
    override private function updateDOM():Void {
        var arr:Array<Element> = [nodeDecrement, nodeInput, nodeIncrement];
        if (ico != null)                        arr.push(ico);
        if (nodeLabel != null)                  arr.push(nodeLabel);
        if (required && nodeRequire != null)    arr.push(nodeRequire);
        if (incorrect && nodeError != null)     arr.push(nodeError);
        NativeJS.set(node, arr);
    }

    /**
     * Нативное событие ввода значения.
     * @param e Событие.
     */
    private function onNativeInput(e:InputEvent):Void {
        if (!disabled)
            onInput.emit(this);
    }

    /**
     * Нативное событие изменения значения.
     * @param e Событие.
     */
    private function onNativeChange(e:Event):Void {
        if (!disabled)
            onChange.emit(this);
    }

    /**
     * Нативное нажатие на инкремент.
     * @param e Событие.
     */
    private function onIncDown(e:PointerEvent):Void {
        if (disabled)
            return;
        e.preventDefault();
        Cross.stepUp(nodeInput);
        LongCall.stepper(componentID, function() {
            Cross.stepUp(nodeInput);
        });
    }

    /**
     * Нативное нажатие на декремент.
     * @param e Событие.
     */
    private function onDecDown(e:PointerEvent):Void {
        if (disabled)
            return;
        e.preventDefault();
        Cross.stepDown(nodeInput);
        LongCall.stepper(componentID, function() {
            Cross.stepDown(nodeInput);
        });
    }

    override function set_disabled(value:Bool):Bool {
        nodeInput.disabled = value;
        nodeIncrement.disabled = value;
        nodeDecrement.disabled = value;

        if (!value)
            LongCall.stop(componentID);

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
        return "[Stepper]";
    }
}