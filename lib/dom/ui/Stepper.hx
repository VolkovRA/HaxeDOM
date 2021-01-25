package dom.ui;

import dom.enums.CSSClass;
import dom.enums.InputType;
import dom.utils.Cross;
import dom.utils.DOM;
import dom.utils.LongCall;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.Event;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.PointerEvent;
import tools.Dispatcher;
import tools.NativeJS;

/**
 * Обычная кнопка.  
 * В DOM представлена тегом: `<div class="stepper">`
 */
@:dce
class Stepper extends UIInputComponent
{
    /**
     * Создать новый экземпляр.
     * @param label Текст на кнопке.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        super(node);
        this.node.classList.add(CSSClass.STEPPER);

        this.nodeInput = Browser.document.createInputElement();
        this.nodeInput.type = InputType.NUMBER;
        this.nodeInput.addEventListener("input", onInput);
        this.nodeInput.addEventListener("change", onChange);

        this.nodeDecrement = Browser.document.createButtonElement();
        this.nodeDecrement.classList.add(CSSClass.DECREMENT);
        this.nodeDecrement.addEventListener("pointerdown", onDecDown);
        this.nodeDecrement.textContent = "-";

        this.nodeIncrement = Browser.document.createButtonElement();
        this.nodeIncrement.classList.add(CSSClass.INCREMENT);
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
     * Событие изменения значения.  
     * - Это событие посылается, когда пользователь завершил
     *   ввод данных в степпер.
     * - Это событие не посылается при ручном изменении значения
     *   в: `value`
     * - Это событие не посылается, если компонент выключен:
     *   `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evChange(default, never):Dispatcher<Stepper->Void> = new Dispatcher();

    /**
     * Событие ввода данных.  
     * - Посылается каждый раз, когда вводится новый символ. (Цифра)
     * - Это событие не посылается при ручном изменении значения
     *   в: `value`
     * - Это событие не посылается, если компонент выключен:
     *   `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evInput(default, never):Dispatcher<Stepper->Void> = new Dispatcher();

    /**
     * Обновить DOM для этого компонента.
     */
    override private function updateDOM():Void {
        var arr:Array<Element> = [nodeDecrement, nodeInput, nodeIncrement];
        if (ico != null)                        arr.push(ico);
        if (nodeLabel != null)                  arr.push(nodeLabel);
        if (required && nodeRequire != null)    arr.push(nodeRequire);
        if (incorrect && nodeError != null)     arr.push(nodeError);
        DOM.set(node, arr);
    }

    /**
     * Нативное событие ввода значения.
     * @param e Событие.
     */
    private function onInput(e:InputEvent):Void {
        if (!disabled)
            evInput.emit(this);
    }

    /**
     * Нативное событие изменения значения.
     * @param e Событие.
     */
    private function onChange(e:Event):Void {
        if (!disabled)
            evChange.emit(this);
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
}