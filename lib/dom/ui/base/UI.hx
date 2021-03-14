package dom.ui.base;

import dom.display.Container;
import dom.enums.Style;
import js.html.Element;

/**
 * Элемент пользовательского интерфейса.  
 * 
 * Это абстрактный, базовый класс для всех элементов
 * пользовательского интерфейса. Содержит общие
 * методы и свойства.
 * 
 * *Скорее всего, вам будет интересен не этот
 * класс, а один из его потомков.*
 */
@:dce
class UI extends Container
{
    /**
     * Создать новый экземпляр.
     * @param node DOM Элемент, представляющий этот элемент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        super(node);
        this.isUI = true;
    }

    /**
     * Компонент выключен.  
     * Используйте это свойство для деактивации элементов
     * интерфейса. Переключение этого свойства **может**
     * влиять на работу компонентов по разному. Например,
     * выключенные кнопки и элементы ввода не будут
     * посылать события нажатия и ввода данных соответственно.
     * 
     * Возможные значения:
     * - Если: `true`, элемент отмечается атрибутом: `disabled`
     * - Если: `false`, у элемента удаляется атрибут: `disabled`
     * 
     * По умолчанию: `false` *(Активен)*
     */
    public var disabled(default, set):Bool = false;
    function set_disabled(value:Bool):Bool {
        if (value == disabled)
            return value;

        if (value) {
            disabled = true;
            node.setAttribute("disabled", "");
        }
        else {
            disabled = false;
            node.removeAttribute("disabled");
        }
        return value;
    }

    /**
     * Обновить DOM компонента.  
     * Выполняет перестроение дерева DOM этого элемента
     * интерфейса. Каждый компонент определяет собственное
     * поведение.
     */
    public function updateDOM():Void {
        // Построение DOM определяется подклассом...
    }
}