package dom.ui.base;

import dom.enums.Style;
import dom.utils.DOM;
import js.Browser;
import js.html.Element;
import js.html.SpanElement;

/**
 * Компонент пользовательского интерфейса с текстом и иконкой.
 * 
 * Это базовый, абстрактный класс для всех компонетнов
 * пользовательского интерфейса, которые имеют возможность
 * указать иконку и текст с описанием.
 * 
 * Используется для инкапсулирования общего поведения всех
 * компонентов в одном месте.
 * 
 * *Скорее всего, вам будет интересен не этот
 * класс, а один из его потомков.*
 */
@:dce
class LabelUI extends UI
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
     * будет использоваться в качестве иконки. Этот элемент
     * автоматически будет добавлен в DOM.
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
     * *п.с. Доступ предоставлен для удобства.*
     * 
     * По умолчанию: `null`
     */
    public var nodeLabel(default, null):SpanElement = null;

    /**
     * Обновить DOM компонента.  
     * Выполняет перестроение дерева DOM этого элемента
     * интерфейса. Каждый компонент определяет собственное
     * поведение.
     */
    override public function updateDOM():Void {
        DOM.setChilds(node, [
            ico==null?       null:ico,
            nodeLabel==null? null:nodeLabel,
        ]);
    }
}