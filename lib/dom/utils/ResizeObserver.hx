package dom.utils;

import js.Browser;
import js.Syntax;
import js.html.Element;

/**
 * Класс для наблюдения за изменением размеров DOM элементов.  
 * Используется для вызова колбека при изменении размеров
 * наблюдаемых DOM элементов.  
 * По возможности используется нативная реализацию:
 * [ResizeObserver](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver)
 * 
 * Пример использования:
 * ```
 * // Добавление прослушки:
 * var el = Browser.document.createDivElement();
 * var cb = function(element){ trace("Размер изменён!"); };
 * 
 * ResizeObserver.on(el, cb);  // Подписка
 * ResizeObserver.off(el, cb); // Отписка
 * ```
 * 
 * Статический класс.
 */
@:dce
class ResizeObserver
{
    /**
     * Частота вызова цикла проверки изменений. (mc)  
     * Используется при ручной реализации слушателя ресайза.
     */
    inline static private var DELAY:Int = 200;

    /**
     * Список отслеживаемых элементов. (ElementID -> ResizeObserverItem)  
     * Не может быть: `null`
     */
    static private var map:Dynamic = {};

    /**
     * ID Интервала, используемого для постоянной проверки
     * наблюдаемых элементов.
     */
    static private var intervalID:Int = 0;

    /**
     * Нативная реализация отслеживания изменений в DOM элементах.  
     * - Если `true`, используется нативное API для отслеживания изменений: [ResizeObserver](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver)
     * - Если `false`, используется кастомная реализация на основе циклов и периодических опросов.
     * 
     * Это свойство определяется автоматический.
     */
    static public var isNative(get, never):Bool;
    static function get_isNative():Bool {
        return Syntax.code('window["ResizeObserver"] !== undefined');
    }

    /**
     * Начать прослушку события изменения размеров.  
     * Указанный колбек будет вызван при изменении размеров элемента.
     * - Переданный элемент индексируется, для быстрого поиска. См.: `NativeJS.setNodeID()`
     * - Вы можете добавить несколько разных колбеков для одного элемента.
     * - Добавление одного и тогоже колбека одному элементу игнорируется.
     * - Вызов игнорируется, если хоть один из параметров не передан.
     * @param element Наблюдаемый элемент.  
     * @param callback Функция обратного вызова.
     */
    static public function on(element:Element, callback:Element->Void):Void {
        if (element == null || callback == null)
            return;

        // Индексация элемента чтоб быстро искать:
        var id = NativeJS.getNodeID(element);
        if (id == null)
            id = NativeJS.getNodeID(NativeJS.setNodeID(element));

        // Запись отслеживаемого объекта:
        var p:ResizeObserverItem = map[id];
        if (p != null) {
            if (p.cb.indexOf(callback) == -1)
                p.cb.push(callback);
            return;
        }

        // Новая запись:
        p = {
            el: element,
            cb: [callback],
            w: 0,
            h: 0,
            ob: null,
        }
        map[id] = p;

        // Регистрация:
        if (isNative) {

            // Замыкание для того, чтоб в обработчике сохранить
            // ссылку на отслеживаемый элемент. Массив items,
            // судя по доке, может быть не передан, из-за различий
            // в поддержке этого API разными браузерами.

            p.ob = new NativeResizeObserver(function(items, observer) {
                dispatch(p);
            });
            p.ob.observe(element);
        }
        else {
            var b = element.getBoundingClientRect();
            p.w = b.width;
            p.h = b.height;

            if (intervalID == 0)
                intervalID = Browser.window.setInterval(onInterval, DELAY);
        }
    }

    /**
     * Отменить прослушку события изменения размеров DOM элемента.
     * @param element Наблюдаемый элемент.  
     * @param callback Функция обратного вызова.
     * @return Прослушиватель был найден и удалён.
     */
    static public function off(element:Element, callback:Element->Void):Bool {
        if (element == null || callback == null)
            return false;

        // Индекс элемента:
        var id = NativeJS.getNodeID(element);
        if (id == null)
            return false;

        // Поиск записи:
        var p:ResizeObserverItem = map[id];
        if (p == null)
            return false;

        // Поиск:
        var index = p.cb.indexOf(callback);
        if (index == -1)
            return false;

        // Удаление:
        if (p.cb.length == 1) {
            NativeJS.delete(map, id);
            if (p.ob != null)
                p.ob.disconnect();
        }
        else {
            p.cb.splice(index, 1);
        }

        return true;
    }

    /**
     * Цикл для проверки изменений в наблюдаемых объектах.
     */
    static private function onInterval():Void {
        var finish = true;
        var key:Dynamic = null;
        Syntax.code('for ({0} in {1}) {', key, map);
            var p:ResizeObserverItem = map[key];
            var b = p.el.getBoundingClientRect();
            if (p.w != b.width || p.h != b.height) {
                p.w = b.width;
                p.h = b.height;
                dispatch(p);
            }
            finish = false;
        Syntax.code('}');

        // Завершаем вызовы, если наблюдаемых объетов больше нет:
        if (finish && intervalID > 0) {
            Browser.window.clearInterval(intervalID);
            intervalID = 0;
        }
    }

    /**
     * Диспетчерезировать событие изменения размеров элемента.
     * @param item Запись с данными по отслеживаемому элементу.
     */
    static private function dispatch(item:ResizeObserverItem):Void {

        // Создаём копию, так-как исходный массив может быть
        // изменён между вызовами.

        var s = item.cb.copy();
        var i = s.length;
        while (i-- != 0)
            s[i](item.el);
    }
}

/**
 * Наблюдаемый элемент.
 */
@:dce
@:noCompletion
private typedef ResizeObserverItem =
{
    /**
     * Наблюдаемый элемент.  
     * Не может быть: `null`
     */
    var el:Element;

    /**
     * Колбеки для обратного вызова.  
     * Не может быть: `null`
     */
    var cb:Array<Element->Void>;

    /**
     * Интерфейс наблюдателя.  
     * Может быть: `null`
     */
    var ob:NativeResizeObserver;

    /**
     * Ширина элемента.  
     * Не может быть: `null`
     */
    var w:Float;

    /**
     * Высота элемента.  
     * Не может быть: `null`
     */
    var h:Float;
}

/**
 * Нативный JavaScript объект [ResizeObserver](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver).  
 * Используется для наблюдения за изменениями размеров
 * DOM элементов.
 * 
 * **Обратите внимание**, что не все браузеры поддерживают
 * это API. В рамках Haxe приложения вам рекомендуется
 * использовать обёртку: `dom.utils.ResizeObserver`
 */
@:dce
@:noCompletion
@:native("ResizeObserver")
private extern class NativeResizeObserver
{
    /**
     * Создать нового наблюдателя.
     * @param callback Функция для обратного вызова.
     */
    public function new(callback:NativeObserverCallback);

    /**
     * Начать наблюдение изменении размеров.
     * @param target Цель наблюдения.
     * @param options Дополнительные параметры.
     */
    public function observe(target:Element, ?options:NativeObserveParams):Void;

    /**
     * Завершить наблюдение за указанной целью.
     * @param target Наблюдаемая цель.
     */
    public function unobserve(target:Element):Void;

    /**
     * Отключить наблюдение изменений размеров.
     */
    public function disconnect():Void;
}

/**
 * Функция обратного вызова для уведомления об изменениях.
 * @param entries Массив ResizeObserverEntry объектов, который можно использовать
 *                для доступа к новым размерам элемента после каждого изменения.
 * @param observer Ссылка на объект наблюдателя.
 */
@:noCompletion
private typedef NativeObserverCallback = Array<NativeResizeObserverEntry>->NativeResizeObserver->Void;

/**
 * Параметры наблюдения.
 */
@:noCompletion
private typedef NativeObserveParams =
{
    /**
     * Модель наблюдаемых изменений.  
     * Возможные значения:
     * - `content-box` (По умолчанию)
     * - `border-box`
     */
    @:optional var box:String;
}

/**
 * Интерфейс для доступа к новым габаритам элемента.
 */
@:noCompletion
private typedef NativeResizeObserverEntry =
{
    /**
     * Объект, содержащий новый размер рамки наблюдаемого элемента при
     * выполнении обратного вызова.
     */
    var borderBoxSize:Dynamic;

    /**
     * Объект, содержащий новый размер окна содержимого наблюдаемого элемента
     * при выполнении обратного вызова.
     */
    var contentBoxSize:Dynamic;

    /**
     * Объект, содержащий новый размер наблюдаемого элемента, когда обратный
     * вызов запускается. Обратите внимание, что это лучше поддерживается, чем
     * два вышеупомянутых свойства, но оно осталось от более ранней реализации
     * Resize Observer API, по-прежнему включено в спецификацию по причинам
     * веб-совместимости и может быть устаревшим в будущих версиях.
     */
    var contentRect:Dynamic;

    /**
     * Наблюдаемая цель.
     */
    var target:Element;
}