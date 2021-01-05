package dom.control;

import dom.geom.Vec;
import dom.utils.NativeJS;

/**
 * Контроллер для расчёта ускорения.  
 * Используется для расчёта итогового ускорения на
 * основе ранее заданных точек и прошедшего времени.
 * 
 * Способ использования:
 * - Добавляйте точки с помощью метода: `add()`, чтобы
 *   сохранить историю перемещения указателя или объекта.
 * - Вызовите метод: `get()`, чтобы получить итоговое
 *   ускорение, с которым должен двигаться объект или
 *   указатель.
 * - Вызовите метод: `clear()`, если вам нужно просто
 *   очистить историю.
 * 
 * Пример использования:
 * ```
 * // Сохраняем точки:
 * var a = new Acceleration();
 * a.add(12, 50);
 * a.add(16, 150);
 * a.add(0, 10);
 * 
 * // Расчитываем ускорение:
 * trace(a.get());
 * ```
 */
@:dce
class Acceleration
{
    /**
     * Создать новый экземпляр.
     */
    public function new() {
    }

    /**
     * История ввода данных.  
     * Не может быть: `null`
     */
    private var arr:Array<Point> = [];

    /**
     * Количество введённых данных.  
     * По умолчанию: `0`
     */
    private var len:Int = 0;

    /**
     * Время захвата. *(mc)*  
     * Это промежуток времени в прошлом на момент вызова
     * расчёта итогового ускорения, в котором будут учтены
     * сохранённые точки. Точки, которые были добавлены
     * ранее - игнорируются.
     * 
     * По умолчанию: `300`
     */
    public var delay:Float = 300;

    /**
     * Акселерация выключена.  
     * Свойство позволяет временно отключить поведение.
     * - Если `true`, метод: `get()` всегда возвращает
     *   нулевой вектор, а метод: `add()` не сохраняет
     *   историю перемещения.
     * - При выключении вся история очищается.
     * 
     * По умолчанию: `false`
     */
    public var disabled(default, set):Bool = false;
    function set_disabled(value:Bool):Bool {
        if (value == disabled)
            return value;

        disabled = value;
        if (value)
            clear();

        return value;
    }

    /**
     * Добавить новую точку.  
     * На основе добавленных точек в дальнейшем при вызове
     * метода: `get()` будет расчитано итоговое ускорение.
     * @param x Позиция по X.
     * @param y Позиция по Y.
     */
    public function add(x:Float, y:Float):Void {
        if (disabled)
            return;
        arr[len++] = { x:x, y:y, t:NativeJS.stamp() };
    }

    /**
     * Расчитать ускорение.  
     * Метод производит вычисление итогового ускорения на основе ранее
     * заданных точек, даты их добавления и собственных алгоритмов расчёта.
     * - Если точки не были заданы, возвращается нулевое ускорение: `x:0, y:0`
     * - Если в метод передаётся вектор, результат записывается в него. Иначе
     *   создаётся новый вектор для записи.
     * - История заданных точек очищается.
     * - Результатом вызова не может быть: `null`
     * @param vec Объект для записи результата. Если не передан, создаётся новый.
     * @return Итоговое ускорение.
     */
    public function get(?vec:Vec):Vec {
        if (vec == null)
            vec = new Vec(0, 0);
        else
            vec.set(0, 0);

        if (len == 0)
            return vec;

        var t = NativeJS.stamp() - delay;
        var p = arr[--len];
        var dx = p.x;
        var dy = p.y;
        while (len > 0) {
            p = arr[--len];
            if (p.t < t) {
                len = 0;
                return vec;
            }
            vec.x += dx - p.x;
            vec.y += dy - p.y;
        }
        
        return vec;
    }

    /**
     * Очистить историю заданных точек.  
     * Удобно, если вам нужно начать новую запись истории.
     */
    public function clear():Void {
        len = 0;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String {
        return "[Acceleration]";
    }
}

/**
 * Сохранённая точка.
 */
@:noCompletion
private typedef Point = 
{
    /**
     * Позиция по X. *(px)*
     */
    var x:Float;

    /**
     * Позиция по Y. *(px)*
     */
    var y:Float;

    /**
     * Дата фиксаций. *(mc)*
     */
    var t:Float;
}