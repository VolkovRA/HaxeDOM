package dom.ui;

import dom.display.Component;
import dom.enums.Style;
import dom.utils.DOM;
import js.Browser;
import js.html.Element;
import js.html.SpanElement;

/**
 * Компонент пользовательского интерфейса.  
 * Это абстрактный, базовый класс для всех компонентов
 * пользовательского интерфейса. Он добавляет некоторые
 * общие, специфичные для всех UI свойства и методы.
 * 
 * *п.с.: Скорее всего, вам будет интересен не этот
 * класс, а один из его потомков.*
 */
@:dce
class UIComponent extends Component
{
    /**
     * Создать новый экземпляр.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        super(node);
    }

    /**
     * Иконка.  
     * Вы можете указать произвольный DOM элемент, который
     * будет использоваться в качестве иконки или картинки.
     * Этот элемент автоматически будет добавлен в DOM
     * компонента.
     * 
     * По умолчанию: `null` *(Без иконки)*
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
     * Текстовая метка.  
     * При указании этого свойства в DOM компонента будет
     * автоматически добавлен узел: `<span>` с переданным
     * содержимым.
     * 
     * По умолчанию: `null` *(Без текста)*
     */
    public var label(get, set):String;
    function get_label():String {
        return nodeLabel==null?null:nodeLabel.textContent;
    }
    function set_label(value:String):String {
        if (value == null) {
            if (nodeLabel != null)
                nodeLabel = null;
        }
        else {
            if (nodeLabel == null) {
                nodeLabel = Browser.document.createSpanElement();
                nodeLabel.classList.add(Style.LABEL);
            }
            nodeLabel.textContent = value;
        }
        updateDOM();
        return value;
    }

    /**
     * Дочерний узел для отображения текстовой метки: `<span>`  
     * Создаётся и удаляется автоматически, в зависимости от
     * наличия указанного значения в свойстве: `label`
     * 
     * По умолчанию: `null`
     */
    public var nodeLabel(default, null):SpanElement = null;

    /**
     * Обновить DOM этого компонента.
     */
    private function updateDOM():Void {
        var arr:Array<Element> = [];
        if (ico != null)        arr.push(ico);
        if (nodeLabel != null)  arr.push(nodeLabel);
        DOM.set(node, arr);
    }
}