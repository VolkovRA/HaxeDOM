package dom.utils;

import haxe.Constraints.Function;

/**
 * Диспетчер событий.  
 * Очень простой диспетчер для возможности уведомления внешних подписчиков.
 * - Вызов на основе колбека, а не объекта события. (Быстродействие)
 * - Типизация слушателей.
 * - Очень простая реализация.
 * 
 * *п.с. На каждый отдельный тип события должен быть создан свой слушатель.*
 */
class Dispatcher<T:Function>
{
    /**
     * Список зарегистрированных слушателей.  
     * Не может быть `null`
     */
    private var listeners = new Array<Listener>();

    /**
     * Создать диспетчер событий.
     */
    public function new() {
    }

    /**
     * Добавить новый слушатель.  
     * - Если слушатель уже зарегистрирован, он будет добавлен ещё раз!
     * - Вызов игнорируется, если передан `null`
     * @param callback Функция для обратного вызова.
     */
    public function on(callback:T):Void {
        if (callback == null)
            return;

        listeners.push({
            callback: callback,
            once: false,
        });
    }

    /**
     * Добавить разовый слушатель.  
     * От обычного отличается только тем, что будет автоматически удалён после первого вызова. 
     * @param callback Функция для обратного вызова.
     */
    public function once(callback:T):Void {
        if (callback == null)
            return;

        listeners.push({
            callback: callback,
            once: true,
        });
    }

    /**
     * Удалить слушатель.  
     * Этот вызов удаляет все добавленные слушатели с этим колбеком.
     * @param callback 
     * @return Возвращает `true`, если был удалён один или более слушателей.
     */
    public function off(callback:T):Bool {
        var i = listeners.length;
        var res = false;
        while (i-- > 0) {
            if (listeners[i] != null && listeners[i].callback == callback) {
                listeners[i] = null;
                res = true;
            }
        }
        return res;
    }

    /**
     * Вызвать все зарегистрированные слушатели.
     * - Слушатели вызываются в порядке их добавления в диспетчер.
     * - Новые слушатели, добавленные во время диспетчерезации - не
     *   вызываются в этом потоке.
     * @param v1 Параметр 1, передаваемый в слушатели. (Опционально, согласно типу слушателя)
     * @param v2 Параметр 2, передаваемый в слушатели. (Опционально, согласно типу слушателя)
     * @param v3 Параметр 3, передаваемый в слушатели. (Опционально, согласно типу слушателя)
     */
    public function emit(?v1:Dynamic, ?v2:Dynamic, ?v3:Dynamic):Void {
        var i = 0;
        var index = 0;
        var length = listeners.length;
        while (i < length) {
            var item = listeners[i];
            if (item == null) {
                i ++;
                continue;
            }

            if (item.once) {
                listeners[i] = null;
            }
            else {
                listeners[i] = null;
                listeners[index++] = item;
            }

            if (!NativeJS.isUndefined(v3))
                item.callback(v1, v2, v3);
            else if (!NativeJS.isUndefined(v2))
                item.callback(v1, v2);
            else if (!NativeJS.isUndefined(v1))
                item.callback(v1);
            else
                item.callback();

            i ++;
        }

        // Добавляем новые слушатели, добавленные во время диспетчерезации
        // (Во время вызова массив мог быть изменён)
        length = listeners.length;
        while (i < length) {
            listeners[index++] = listeners[i++];
        }

        // Подрезаем лишние null в массиве:
        if (index != length)
            listeners.resize(index);
    }

    /**
     * Проверить наличие слушателя. (Линейный поиск)  
     * Метод возвращает `true`, если указанный колбек уже зарегистрирован один или более раз.
     * @param callback Проверяемый слушатель.
     * @return Проверка слушателя на наличие в диспетчере.
     */
    public function has(callback:T):Bool {
        if (callback == null)
            return false;

        var i:Int = listeners.length;
        while (i-- > 0) {
            if (listeners[i] == null)
                continue;
            if (listeners[i].callback == callback)
                return true;
        }

        return false;
    }

    /**
     * Удалить все слушатели.
     */
    public function clear():Void {
        var i:Int = listeners.length;
        while (i-- > 0) {
            listeners[i] = null;
        }
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String {
        return "[Dispatcher]";
    }
}

/**
 * Зарегистрированный слушатель.
 */
private typedef Listener = 
{
    /**
     * Колбек для вызова.
     */
    var callback:Function;

    /**
     * Одиночный вызов.
     */
    var once:Bool;
}