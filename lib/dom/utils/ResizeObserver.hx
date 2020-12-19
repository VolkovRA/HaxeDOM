package dom.utils;

import js.html.Element;

/**
 * Объект для наблюдения изменений в размерах DOM элемента.  
 * Это экстерн для нативного JavaScript класса [ResizeObserver](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver).
 */
@:dce
@:native("ResizeObserver")
extern class ResizeObserver
{
    /**
     * Создать нового наблюдателя.
     * @param callback Функция для обратного вызова.
     */
    public function new(callback:ObserverCallback);

    /**
     * Начать наблюдение изменении размеров.
     * @param target Цель наблюдения.
     * @param options Дополнительные параметры.
     */
    public function observe(target:Element, ?options:ObserveParams):Void;

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
typedef ObserverCallback = Array<ResizeObserverEntry>->ResizeObserver->Void;

/**
 * Параметры наблюдения.
 */
typedef ObserveParams =
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
typedef ResizeObserverEntry =
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