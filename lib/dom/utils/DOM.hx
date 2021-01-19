package dom.utils;

import js.Syntax;
import js.html.Element;
import tools.NativeJS;

/**
 * Вспомогательные методы для работы с DOM API.  
 * Статический класс.
 */
class DOM
{
    /**
     * Следующий, уникальный ID для обрабатываемого узла DOM.  
     * Используется для оптимизации алгоритмов работы с DOM API.
     */
    static private var autoID(default, null):Int = 0;

    /**
     * Получить ID HTML элемента.  
     * Возвращает уникальный идентификатор переданного элемента
     * или `undefined`, если элемент не был проиндексирован.
     * @param element HTML DOM Элемент.
     * @return Уникальный ID элемента или `undefined`
     * @see Индексация DOM элементов: `dom.utils.NativeJS.setNodeID()`
     */
    inline static public function getNodeID(element:Element):Null<Int> {
        return untyped element.__nodeID;
    }

    /**
     * Индексировать DOM элемент: `element.__nodeID`  
     * Прописывает в переданный элемент уникальный ID в рамках
     * Haxe приложения и возвращает этот элемент. Это позволяет
     * оптимизировать алгоритмы для работы с DOM API, в
     * частности, метод: `dom.utils.NativeJS.set()`
     * @param element Индексируемый HTML DOM элемент.
     * @return Возвращает элемент для дальнейшей работы с ним.
     */
    static public function setNodeID<T:Element>(element:T):T {
        Syntax.code('if({0}.__nodeID===undefined){0}.__nodeID=++{1}', element, autoID);
        return element;
    }

    /**
     * Установить список детей в ноде.  
     * Используйте этот методы, чтобы привести список детей ноды 
     * в соответствие с переданным масивом.
     * - Добавляет в `parent` всех детей из списка: `childs`, если они
     *   ещё не добавлены.
     * - Удаляет из `parent` всех детей, не содержащихся в `childs`.
     * - Сортирует все элементы `parent` в соответствии с их порядком
     *   в `childs`.
     * - Манипулирует DOM только в случае необходимости, чтоб не
     *   перестраивать его без надобности.
     * - Этот метод обрабатывает только проиндексированные DOM
     *   элементы в `parent`, не затрагивая пользовательские, которые
     *   могли быть добавлены произвольно, чтобы они не были удалены.
     * - Этот метод также индексирует все ноды в `childs`.
     * @param parent Обновляемый узел.
     * @param childs Список детей.
     * @see Индексация DOM элементов: `NativeJS.setNodeID()`
     */
    static public function set(parent:Element, childs:Array<Element>):Void {

        // Добавляем новые узлы, сортируем:
        var len = childs.length;
        var i = len;
        var map:Dynamic = {};
        while (i-- != 0) {
            var el:Element = childs[i];

            // Индексация нод для быстрого поиска:
            setNodeID(el);
            map[getNodeID(el)] = el;

            // Добавление и сортировка без лишнего манипулирования DOM:
            if (el.parentNode == parent) {
                if (i == len-1) {
                    if (el.nextSibling != null)
                        parent.insertBefore(el, null);
                }
                else {
                    if (el.nextSibling != childs[i+1])
                        parent.insertBefore(el, childs[i+1]);
                }
            }
            else {
                if (i == len-1)
                    parent.appendChild(el);
                else
                    parent.insertBefore(el, childs[i+1]);
            }
        }

        // Удаление лишних нод:
        len = parent.children.length;
        while (len-- != 0) {
            var el:Element = parent.children.item(len);
            if (NativeJS.isUnd(getNodeID(el)))
                continue;
            if (map[getNodeID(el)] == null)
                parent.removeChild(el);
        }
    }
}