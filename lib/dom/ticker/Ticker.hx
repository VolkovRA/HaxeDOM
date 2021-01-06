package dom.ticker;

import dom.utils.NativeJS;
import js.Browser;

/**
 * Тикер для анимаций.  
 * Используется для создания эффектов анимаций путём
 * вызова метода: `IAnimated.tick()` каждый кадр у всех
 * добавленных в него объектов.
 */
@:dce
class Ticker
{
    /**
     * Создать новый экземпляр.
     */
    public function new() {
    }

    /**
     * Глобальный тикер.  
     * Не может быть: `null`
     */
    static public var global(default, null):Ticker = new Ticker();

    /**
     * Скорость воспроизведения.  
     * По умолчанию: `1` *(100%)*
     */
    public var speed:Float = 1;

    /**
     * Максимальное прошедшее время. (sec)  
     * Используется для ограничения на передачу прошедшего времени.
     * 
     * По умолчанию: `1`
     */
    public var dtMax:Float = 1;

    /**
     * Минимальное прошедшее время. (sec)  
     * Используется для ограничения на передачу прошедшего времени.
     * 
     * По умолчанию: `-1`
     */
    public var dtMin:Float = -1;

    /**
     * Список анимированных объектов.  
     * Не может быть: `null`
     */
    private var items:Array<IAnimated> = new Array();

    /**
     * ID Запланированной анимации.  
     * По умолчанию: `0`
     */
    private var animationID:Int = 0;

    /**
     * Дата последнего цикла анимаций.  
     * По умолчанию: `0`
     */
    private var stamp:Float = 0;

    /**
     * Добавить новый объект для анимации.
     * - Вызов игнорируется, если передан: `null`
     * - Вызов игнорируется, если переданный объект уже содержится в списке.
     * - Объект удаляется из списка, если он добавлен в другой экземпляр тикера.
     * @param object Анимируемый объект.
     */
    public function add(object:IAnimated):Void {
        if (object == null)
            return;
        if (object.ticker != null) {
            if (object.ticker.o == this)
                return;
            object.ticker.o.remove(object);
        }

        var len = items.length;
        object.ticker = {
            o: this,
            i: len,
        }
        items[len] = object;

        if (animationID == 0) {
            stamp = NativeJS.stamp();
            animationID = Browser.window.requestAnimationFrame(update);
        }
    }

    /**
     * Удалить анимируемый объект.
     * - Вызов игнорируется, если передан: `null`
     * - Вызов игнорируется, если объект не добавлен в этот тикер.
     * @param object Анимируемый объект.
     */
    public function remove(object:IAnimated):Void {
        if (object == null)             return;
        if (object.ticker == null)      return;
        if (object.ticker.o != this)    return;
        
        items[object.ticker.i] = null;
        object.ticker = null;
    }

    /**
     * Цикл обновления.
     * @param time Прошедшее время с момента запуска страницы. (mc)
     */
    private function update(time:Float):Void {
        var next = false;
        var now = NativeJS.stamp();
        var dt = ((now - stamp) * speed) / 1000;
        if (dt > dtMax) dt = dtMax;
        if (dt < dtMin) dt = dtMin;
        stamp = now;

        // Основной цикл обновления:
        var i = 0;
        var j = 0;
        var len = items.length;
        while (i < len) {
            if (items[i] == null) {
                i ++;
                continue;
            }
            if (i == j) {
                if (items[i].tick(dt)) {
                    remove(items[i++]);
                }
                else {
                    next = true;
                    i ++;
                    j ++;
                }
                continue;
            }

            items[j] = items[i++];
            items[j].ticker.i = j;

            if (items[j].tick(dt)) {
                remove(items[j]);
            }
            else {
                next = true;
                j ++;
            }
        }

        // Сдвигаем новые, если те были добавлены в ходе обновления в основном цикле:
        len = items.length;
        if (i != len) {
            while (i < len) {
                items[j] = items[i];
                items[j].ticker.i = j;
                i ++;
                j ++;
            }
        }

        // Обрезаем null'ы справа:
        if (i != j)
            items.resize(j);

        // Планируем новый цикл, если ещё остались объекты для анимации:
        if (next)
            animationID = Browser.window.requestAnimationFrame(update);
        else
            animationID = 0;
    }
}