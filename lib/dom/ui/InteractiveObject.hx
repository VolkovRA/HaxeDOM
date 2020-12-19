package dom.ui;

import dom.display.Container;
import js.html.Element;

/**
 * Интерактивный объект.  
 * Используется как базовый класс для всех компонентов
 * пользовательского интерфейса. Содержит базовые методы
 * и свойства всех UI.
 */
@:dce
class InteractiveObject<T:InteractiveObject<T,E>, E:Element> extends Container<T,E>
{
    /**
     * Создать интерактивный объект.
     * @param node Используемый DOM узел для этого экземпляра.
     */
    public function new(node:E) {
        super(node);
    }

    /**
     * Компонент выключен.  
     * Переключение этого свойства может влиять на работу некоторых
     * UI компонентов.
     * - Если `true`, компонент в DOM будет помечен атрибутом: `<a disabled="disabled"></a>`
     *   Это также влияет на срабатывания событий некоторых компонентов, например,
     *   не будет посылаться событие нажатия на кнопку.
     * - Если `false`, в DOM разметке будет удалён атрибут `disabled` (Если есть).
     *   Компонент будет работать как обычно.
     * 
     * По умолчанию: `false` (Компонент активен)
     */
    public var disabled(default, set):Bool = false;
    function set_disabled(value:Bool):Bool {
        if (value) {
            disabled = true;
            node.setAttribute("disabled", "disabled");
        }
        else {
            disabled = false;
            node.removeAttribute("disabled");
        }

        return value;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[InteractiveObject]";
    }
}