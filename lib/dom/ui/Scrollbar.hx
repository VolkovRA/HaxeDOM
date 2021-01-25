package dom.ui;

import dom.display.Component;
import dom.enums.CSSClass;
import dom.enums.Orientation;
import dom.utils.DOM;
import js.Browser;
import js.html.ButtonElement;
import js.html.Element;
import js.html.PointerEvent;
import tools.Dispatcher;

/**
 * Скроллбар.  
 * В DOM представлен тегом: `<div class="scrollbar">`
 */
@:dce
class Scrollbar extends Component
{
    /**
     * Создать новый экземпляр.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        super(node);
        this.node.classList.add(CSSClass.SCROLLBAR, CSSClass.HORIZONTAL);
        this.node.addEventListener("pointerdown", onBDown);

        this.nodeThumb = Browser.document.createButtonElement();
        this.nodeThumb.classList.add(CSSClass.THUMB);
        this.nodeThumb.addEventListener("pointerdown", onTDown);

        this.evRemovedFromStage.on(onTRemoved);
        updateDOM();
    }

    /**
     * Захват по X.  
     * Используется внутренней реализацией для перетаскивания
     * ползунка скроллбара.
     * 
     * По умолчанию: `0`
     */
    private var clickX:Float = 0;

    /**
     * Захват по X.  
     * Используется внутренней реализацией для перетаскивания
     * ползунка скроллбара.
     * 
     * По умолчанию: `0`
     */
    private var clickY:Float = 0;

    /**
     * Значение скролла.  
     * По умолчанию используются значения от: `0` до `1`.
     * Вы можете изменить это при помощи свойств: `min` и `max`
     * соответственно.
     * - Это значение не может быть меньше: `min`
     * - Это значение не может быть больше: `max`
     * - При изменении этого значения пользователем посылается
     *   событие: `onChange`
     * 
     * По умолчанию: `0`
     */
    public var value(default, set):Float = 0;
    function set_value(value:Float):Float {
        var v = value;
        if (v > max)
            v = max;
        else if (v < min)
            v = min;

        if (this.value == v)
            return value;

        this.value = v;
        updateThumb();
        return value;
    }

    /**
     * Минимальное значение.  
     * Используется для ограничения диапазона значений: `value`
     * - Это значение не может быть больше: `max`
     * - При установке нового значения обновляется свойство: `value`
     * 
     * По умолчанию: `0`
     */
    public var min(default, set):Float = 0;
    function set_min(value:Float):Float {
        if (value > max)
            min = max;
        else
            min = value;

        if (this.value < min)
            this.value = min;
        else
            updateThumb();

        return value;
    }

    /**
     * Максимальное значение.  
     * Используется для ограничения диапазона значений: `value`
     * - Это значение не может быть меньше: `min`
     * - При установке нового значения обновляется свойство: `value`
     * 
     * По умолчанию: `1`
     */
    public var max(default, set):Float = 1;
    function set_max(value:Float):Float {
        if (value < min)
            max = min;
        else
            max = value;

        if (this.value > max)
            this.value = max;
        else
            updateThumb();

        return value;
    }

    /**
     * Размер одной части полного контента.  
     * Используется для масштабирования ползунка. Это значение
     * тесно связано с доступным интервалом: `max-min`. Если
     * значение `part` больше этого интервала, размер ползунка
     * в скроллбаре будет равен 100%. Иначе он будет
     * пропорционально уменьшаться.
     * - Это значение не может быть меньше: `0`
     * - Это значение бессмыслено, если больше: `max-min`
     * 
     * По умолчанию: `0.25` *(Четверть от доступного интервала. Размер ползунка будет 25%)*
     */
    public var part(default, set):Float = 0.25;
    function set_part(value:Float):Float {
        var v:Float = 0;
        if (value > 0)
            v = value;
        if (v == part)
            return value;

        part = v;
        updateThumb();
        return value;
    }

    /**
     * Размер шага.  
     * Вы можете задать силу смещения ползунка при вызове
     * методов: `stepUp()` и `stepDown()`
     * 
     * По умолчанию: `0.2`
     */
    public var step:Float = 0.2;

    /**
     * Ориентация ползунка.  
     * Используется для задания вертикального или
     * горизонтального типа ползунка.
     * 
     * По умолчанию: `Orientation.HORIZONTAL` *(Горизонтальный ползунок)*
     */
    public var orient(default, set):Orientation = Orientation.HORIZONTAL;
    function set_orient(value:Orientation):Orientation {
        if (value == orient)
            return value;

        if (value == Orientation.HORIZONTAL) {
            orient = value;
            node.classList.remove(CSSClass.VERTICAL);
            node.classList.add(CSSClass.HORIZONTAL);
        }
        else {
            orient = value;
            node.classList.remove(CSSClass.HORIZONTAL);
            node.classList.add(CSSClass.VERTICAL);
        }

        nodeThumb.style.width = null;
        nodeThumb.style.height = null;
        nodeThumb.style.top = null;
        nodeThumb.style.left = null;

        updateThumb();
        return value;
    }

    /**
     * Дочерний узел для кнопки ползунка.  
     * Создаётся автоматически.
     * 
     * Не может быть: `null`
     */
    public var nodeThumb(default, null):ButtonElement;

    /**
     * Событие изменения значения.  
     * - Это событие посылается, когда пользователь изменил
     *   значение: `value` своими действиями.
     * - Это событие не посылается при ручном изменении значения
     *   в: `value`
     * - Это событие не посылается, если компонент выключен:
     *   `disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evChange(default, never):Dispatcher<Scrollbar->Void> = new Dispatcher();

    /**
     * Увеличить значение ползунка на один шаг.
     */
    inline public function stepUp():Void {
        value += step;
    }

    /**
     * Уменьшить значение ползунка на один шаг.
     */
    inline public function stepDown():Void {
        value -= step;
    }

    /**
     * Позицианирование ползунка скроллбара.
     */
    private function updateThumb():Void {
        var s:Float = 1; // Размер ползунка в процентах: 0-1
        var o:Float = 0; // Позиция ползунка (отступ) в процентах: 0-1
        var d:Float = max - min; // Диапазон физических значений: от min до max
        if (d > 0 && part < d) {
            s = part / d;
            if (s < 0.1) // Размер ползунка не менее 10%
                s = 0.1;
            o = (1 - s) * ((value - min) / d);
        }

        // Позицианирование:
        if (orient == Orientation.HORIZONTAL) {
            nodeThumb.style.width = (s * 100) + "%";
            nodeThumb.style.left = (o * 100) + "%";
        }
        else {
            nodeThumb.style.height = (s * 100) + "%";
            nodeThumb.style.top = (o * 100) + "%";
        }
    }

    /**
     * Обновить DOM этого компонента.
     */
    private function updateDOM():Void {
        DOM.set(node, [nodeThumb]);
        updateThumb();
    }

    /**
     * Удалениe со сцены.
     */
    private function onTRemoved(s:Component):Void {
        onUp();
    }

    /**
     * Нажатие на фон скролббара.
     */
    private function onBDown(e:PointerEvent):Void {
        if (disabled)
            return;
        e.preventDefault();
        e.stopImmediatePropagation();

        Browser.window.addEventListener("pointermove", onBMove);
        Browser.window.addEventListener("pointerup", onUp);
        Browser.window.addEventListener("pointercancel", onUp);

        onBMove(e);
    }

    /**
     * Драг по фону скроллбара.
     */
    private function onBMove(e:PointerEvent):Void {
        e.preventDefault();
        e.stopImmediatePropagation();

        // Вычисляем новое значение в процентах: 0-1
        var b1 = node.getBoundingClientRect();
        var b2 = nodeThumb.getBoundingClientRect();
        var p:Float = 0; // Новое, отображаемое значение в %. (0-1)
        if (orient == Orientation.HORIZONTAL) {
            var x = e.clientX - b1.left;
            var d = b1.width - b2.width;
            if (d > 0) {
                if (x > b1.width - b2.width / 2)
                    p = 1;
                else if (x > b2.width / 2)
                    p = (x - b2.width / 2) / d;
            }
        }
        else {
            var y = e.clientY - b1.top;
            var d = b1.height - b2.height;
            if (d > 0) {
                if (y > b1.height - b2.height / 2)
                    p = 1;
                else if (y > b2.height / 2)
                    p = (y - b2.height / 2) / d;
            }
        }

        // Устанавливаем новое значение
        // Ничего не делаем, если по факту значение не изменилось
        var v = min + (max - min) * p;
        if (v > max)
            v = max;
        else if (v < min)
            v = min;

        if (value == v)
            return;

        value = v;
        evChange.emit(this);
    }

    /**
     * Нажатие на кнопку скроллбара.
     */
    private function onTDown(e:PointerEvent):Void {
        if (disabled)
            return;
        e.preventDefault();
        e.stopImmediatePropagation();

        Browser.window.addEventListener("pointermove", onTMove);
        Browser.window.addEventListener("pointerup", onUp);
        Browser.window.addEventListener("pointercancel", onUp);

        var b = nodeThumb.getBoundingClientRect();
        clickX = e.clientX - b.left;
        clickY = e.clientY - b.top;
    }

    /**
     * Драг кнопки скроллбара.
     */
    private function onTMove(e:PointerEvent):Void {
        e.preventDefault();
        e.stopImmediatePropagation();

        // Вычисляем новое значение ползунка в процентах: 0-1
        var b1 = node.getBoundingClientRect();
        var b2 = nodeThumb.getBoundingClientRect();
        var p:Float = 0; // Новое, отображаемое значение в %. (0-1)
        if (orient == Orientation.HORIZONTAL) {
            var d = b1.width - b2.width;
            if (d > 0)
                p = ((e.clientX - b1.left) - clickX) / d;
        }
        else {
            var d = b1.height - b2.height;
            if (d > 0)
                p = ((e.clientY - b1.top) - clickY) / d;
        }

        // Устанавливаем новое значение
        // Ничего не делаем, если по факту значение не изменилось
        var v = min + (max - min) * p;
        if (v > max)
            v = max;
        else if (v < min)
            v = min;

        if (value == v)
            return;

        value = v;
        evChange.emit(this);
    }

    /**
     * Отжатие указателя.
     */
    private function onUp(?e:PointerEvent):Void {
        Browser.window.removeEventListener("pointermove", onTMove);
        Browser.window.removeEventListener("pointermove", onBMove);
        Browser.window.removeEventListener("pointerup", onUp);
        Browser.window.removeEventListener("pointercancel", onUp);
    }

    override function set_disabled(value:Bool):Bool {
        nodeThumb.disabled = value;
        if (!value)
            onUp();

        return super.set_disabled(value);
    }
}