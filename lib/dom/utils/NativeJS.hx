package dom.utils;

import js.Syntax;
import js.html.Element;

/**
 * Нативный JS.  
 * Статический класс с нативными JavaScript функциями.
 */
@:dce
class NativeJS
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
            if (isUndefined(getNodeID(el)))
                continue;
            if (map[getNodeID(el)] == null)
                parent.removeChild(el);
        }
    }

    /**
     * Проверка на: `undefined`  
     * Возвращает `true`, если переданное значение равно: `undefined`
     * @param value Проверяемое значение.
     * @return Результат проверки.
     */
    inline static public function isUndefined(value:Dynamic):Bool {
        return Syntax.code('({0} === undefined)', value);
    }

    /**
     * Точка остановки.  
     * Вставляет точку остановки для активации дебаггера и отладки.
     */
    inline static public function debugger():Void {
        Syntax.code('debugger;');
    }

    /**
     * Приведение к: `String`  
     * Приводит любое значение к строке.
     * @param v Значение.
     * @return Строка.
     */
    static public inline function str(v:Dynamic):String {
        return Syntax.code("({0} + '')", v);
    }

    /**
     * Вставка в произвольное место массива.  
     * Вставка в указанную позицию в массиве со сдвигом элементов вправо.
     * @param arr Изменяемый массив.
     * @param index Позиция для вставки.
     * @param value Вставляемое значение.
     */
    inline static public function arrInsert(arr:Array<Dynamic>, index:Int, value:Dynamic):Void {
        Syntax.code('{0}.splice({1}, 0, {2})', arr, index, value);
    }

    /**
     * Удалить указанный индекс в массиве.  
     * @param arr Изменяемый массив.
     * @param index Позиция для вставки.
     * @param value Вставляемое значение.
     */
    inline static public function arrRemove(arr:Array<Dynamic>, index:Int):Void {
        Syntax.code('{0}.splice({1}, 1)', arr, index);
    }

    /**
     * Проверить поддержку DOM API [ResizeObserver]()  
     * @return Возвращает `true`, если этот класс определён, `false` в остальных случаях.
     */
    inline static public function isResizeObserverSupported():Bool {
        return Syntax.code('window["ResizeObserver"] !== undefined');
    }

    /**
     * Получить текущее время. *(mc)*  
     * Метод возвращает количество миллисекунд, прошедших с 1 января 1970
     * года 00:00:00 по UTC по текущий момент времени в качестве числа.
     * @return Текущее время.
     * @see Date.now() https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/Date/now
     */
    inline static public function stamp():Float {
        return Syntax.code('Date.now()');
    }

    /**
     * Распарсить число.  
     * Считывает переданную строку и возвращает число или: `NaN`
     * @param value Строка.
     * @return Число.
     */
    inline static public function parseFloat(value:Dynamic):Float {
        return Syntax.code('parseFloat({0})', value);
    }

    /**
     * Нативный вызов: `isNaN()`  
     * @param value Число, проверяемое на: `NaN`
     * @return Переданное число является: `NaN`
     */
    inline static public function isNaN(value:Float):Bool {
        return Syntax.code('isNaN({0})', value);
    }

    /**
     * Нативный вызов: `delete`  
     * Удаляет в указанной мапе указанный ключ.
     * @param map Мапа.
     * @param key Удаляемый ключ.
     */
    inline static public function delete(map:Dynamic, key:Dynamic):Void {
        Syntax.code('delete {0}[{1}]', map, key);
    }

    /**
     * Получить количество знаком в числе после запятой.  
     * Парсит число и возвращает количество знаков после запятой.
     * @param value Число или строка с числом.
     * @return Количество знаков после запятой.
     */
    static public function dec(value:Dynamic):Int {
        var v = str(value);
        var i = v.indexOf(".");
        if (i == -1)
            return 0;

        return v.length - i - 1;
    }

    /**
     * Округлить число до заданного количества знаков после запятой.
     * @param value Округляемое число.
     * @param n Количество знаков после запятой.
     * @return Округлённое число с заданным количеством знаком после запятой.
     */
    static public function round(value:Float, n:Int):Float {
        var m = Math.pow(10,n);
        return Math.round(value*m)/m;
    }
}