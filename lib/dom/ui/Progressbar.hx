package dom.ui;

import dom.display.Component;
import dom.enums.CSSClass;
import dom.utils.DOM;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.lib.Error;

/**
 * Прогрессбар.  
 * В DOM представлен тегом: `<div class="progressbar">`
 */
class Progressbar extends Component
{
    /**
     * Создать новый экземпляр.  
     * @param value Отображаемое значение. *(По умолчанию: `0`, от `0` до `100`)*
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?value:Float, ?node:Element) {
        super(node);
        this.node.classList.add(CSSClass.PROGRESSBAR);

        this.nodeProgress = Browser.document.createDivElement();
        this.nodeProgress.classList.add(CSSClass.FILL);

        if (value == null)
            this.value = 0;
        else
            this.value = value;
    }

    /**
     * Отображаемое значение прогресса.  
     * - Это значение не может быть меньше: `min`
     * - Это значение не может быть больше: `max`
     * 
     * По умолчанию: `0`
     */
    public var value(default, set):Float;
    function set_value(value:Float):Float {
        var v = value;
        if (v < min)
            v = min;
        else if (v > max)
            v = max;
        if (v == this.value)
            return value;
        this.value = v;
        updateDOM();
        return value;
    }

    /**
     * Минимальное значение прогрессбара.  
     * - Это значение ограничивает свойство: `value`
     * - Это значение не может быть больше: `max`
     * - При установке нового значения, обновляется
     *   свойство: `value`, если то меньше заданного
     *   минимума.
     * 
     * По умолчанию: `0`
     * 
     * @throws Error Минимальное значение не должно быть больше максимума: `max`
     */
    public var min(default, set):Float = 0;
    function set_min(value:Float):Float {
        if (value > max)
            throw new Error("Минимальное значение: " + value + " не должно быть больше минимума: " + max);
        if (value == min)
            return value;
        min = value;
        if (this.value < min)
            this.value = min;
        else
            updateDOM();
        return value;
    }

    /**
     * Максимальное значение прогрессбара.  
     * - Это значение ограничивает свойство: `value`
     * - Это значение не может быть меньше: `min`
     * - При установке нового значения, обновляется
     *   свойство: `value`, если то превышает заданный
     *   максимум.
     * 
     * По умолчанию: `100`
     * 
     * @throws Error Максимальное значение не должно быть меньше минимума: `min`
     */
    public var max(default, set):Float = 100;
    function set_max(value:Float):Float {
        if (value < min)
            throw new Error("Максимальное значение: " + value + " не должно быть меньше минимума: " + min);
        if (value == max)
            return value;
        max = value;
        if (this.value > max)
            this.value = max;
        else
            updateDOM();
        return value;
    }

    /**
     * Дочерний узел для полоски прогресса.  
     * Создаётся автоматический.
     * 
     * Не может быть: `null`
     */
    public var nodeProgress(default, null):DivElement;

    /**
     * Обновить DOM компонента.
     */
    private function updateDOM():Void {
        var p:Float = 0;
        if (max > min)
            p = (value / (max - min)) * 100;
        nodeProgress.style.width = p + "%";
        DOM.set(node, [nodeProgress]);
    }
}