package dom.control;

import haxe.DynamicAccess;
import dom.utils.NativeJS;

/**
 * Контроллер якорей. (Точки привязки)  
 * Используется как вспомогательный класс для определения
 * "прилипания" точки к заранее заданным координатам.
 * 
 * Способ использования:
 * - Задать якоря для прилипания с помощью метода: `add()`
 * - Задать минимальную дистанцию прилипания, если нужно.
 * - Вызвать один из методов: `testPoint()` или `testMove()`,
 *   для определения прилипания к якорю искомой точки.
 * 
 * Класс используется как композиция.
 */
@:dce
class AnchorRuler
{
    /**
     * Создать новый экземпляр.
     */
    public function new() {
    }

    /**
     * Дистанция прилипания. (px)  
     * Чем больше дистанция, тем раньше точка прилипнет
     * к одному из якорей.
     * - Это значение не может быть меньше: `0`
     * 
     * По умолчанию: `2`
     */
    public var dist(default, set):Float = 2;
    function set_dist(value:Float):Float {
        if (value > 0)
            dist = value;
        else
            dist = 0;
        return value;
    }

    /**
     * Якоря выключены.  
     * Свойство позволяет временно отключить поведение.
     * - Если `true`, методы: `testPoint()` и `testMove()`
     *   не возвращают якоря.
     * 
     * По умолчанию: `false`
     */
    public var disabled(default, set):Bool = false;
    function set_disabled(value:Bool):Bool {
        if (value == disabled)
            return value;
        disabled = value;
        return value;
    }

    /**
     * Якоря для прилипания.  
     * Не может быть: `null`
     */
    private var arr:Array<Float> = [];

    /**
     * Хеш мапа индексов якорей для быстрого поиска.  
     * Не может быть: `null`
     */
    private var map:DynamicAccess<Int> = {};

    /**
     * Грязный список.  
     * Используется для ленивой инициализации списка
     * в случае внесения изменений извне.
     * 
     * По умолчанию: `false` *(Изменений нет)*
     */
    private var dirty:Bool = false;

    /**
     * Добавить новый якорь.  
     * - Вызов игнорируется, если передан: `null`
     * - Вызов игнорируется, если этот якорь уже был добавлен.
     * @param anchor Якорь для прилипания.
     */
    public function add(anchor:Anchor):Void {
        if (anchor == null)
            return;

        var key:String = NativeJS.str(anchor);
        if (map[key] == null) {
            map[key] = arr.length;
            arr.push(anchor);
            dirty = true;
        }
    }

    /**
     * Удалить якорь.  
     * - Вызов игнорируется, если передан: `null`
     * - Вызов игнорируется, если этого якоря нет в списке.
     * @param anchor Якорь для прилипания.
     */
    public function remove(anchor:Anchor):Void {
        if (anchor == null)
            return;

        var key:String = NativeJS.str(anchor);
        var index:Int = map[key];
        if (index == null)
            return;

        dirty = true;
        arr[index] = null;
        NativeJS.delete(map, key);
    }

    /**
     * Удалить все якоря.  
     * Удобно для быстрой очистки.
     */
    public function clear():Void {
        dirty = false;
        arr = [];
        map = {};
    }

    /**
     * Провести проверку на прилипание точки к одному из якорей.  
     * Метод возвращает якорь, если переданная точка находится
     * слишком близко к одному из них. Если такого нет,
     * возвращается: `null` Метод возвращает ближайший якорь.
     * @param point Проверяемая точка.
     * @return Ближайший якорь или `null`, если таковых нет.
     */
    public function testPoint(point:Float):Anchor {
        if (dirty)
            upd();
        if (point == null || arr.length == 0 || disabled)
            return null;

        return testPointByIndex(point, search(point, arr));
    }

    /**
     * Провести проверку точки с использованием индекса.  
     * Отдельный метод нужен, чтоб не вызывать поиск два раза: `search()`
     * @param p Проверяемая точка.
     * @param i Индекс для сравнения, возвращаемый методом: `search()`
     * @return Ближайший якорь или `null`, если таковых нет.
     */
    private function testPointByIndex(p:Float, i:Int):Anchor {

        // Проверяем якоря: index и index+1 на слипание с точкой.
        // Частный случай 1 - Все якоря справа:
        if (i == -1) {
            if (p + dist < arr[0])
                return null;
            return arr[0];
        }

        // Частный случай 2 - Число точно равно якорю:
        if (arr[i] == p)
            return p;

        // Частный случай 3 - Все якоря слева:
        if (i+1 == arr.length) {
            if (p - dist > arr[i])
                return null;
            return arr[i];
        }

        // Частный случай 4 - Число лежит между якорями и оно не равно им:
        var d1 = p - arr[i];    // <-- Модуль расстояния до левой точки
        var d2 = arr[i+1] - p;  // <-- Модуль расстояния до правой точки
        if (d1 > d2) {
            if (d2 > dist)
                return null;
            return arr[i+1];    // <-- Правый якорь ближе.
        }
        else {
            if (d1 > dist)
                return null;
            return arr[i];      // <-- Левый якорь ближе.
        }
    }

    /**
     * Провести проверку на прилипание во время движения.  
     * Метод возвращает якорь, если из точки `from` до точки
     * `to` встречается таковой, иначе вернёт `null`. Метод
     * возвращает ближайший якорь.
     * @param from Начальная точка.
     * @param to Конечная точка.
     * @return Ближайший якорь на пути или `null`, если таковых нет.
     */
    public function testMove(from:Float, to:Float):Anchor {
        if (dirty)
            upd();
        if (from == null || to == null || arr.length == 0 || disabled)
            return null;

        // Проверка начальной позиции:
        var i = search(from, arr);
        var r = testPointByIndex(from, i);
        if (r != null)
            return r; // <-- Точка привязалась в начале пути

        // Движение вперёд: -->
        if (from < to) {
            if (i+1 != arr.length && to + dist >= arr[i+1])
                return arr[i+1];
            return null;
        }

        // Движение назад: <--
        if (from > to) {
            if (i != -1 && to - dist <= arr[i])
                return arr[i];
            return null;
        }

        // Нет движения и нет совпадений:
        return null;
    }

    /**
     * Актуализировать список.
     */
    private function upd():Void {
        dirty = false;
        arr.sort(compare);

        // Обновляем список:
        // 1. Удаляем null'ы, которые могли появиться после вызова remove()
        // 2. Обновляем индексы, если они изменились.
        var i = 0;
        var j = 0;
        var len = arr.length;
        while (i < len) {
            if (arr[i] == null) {
                i ++;
                continue;
            }
            if (i == j) {
                i ++;
                j ++;
                continue;
            }
            map[NativeJS.str(arr[i])] = j;
            arr[j++] = arr[i++];
        }
        if (i != j)
            arr.resize(j);
    }

    /**
     * Функция сортировки.
     * @param x Значение 1.
     * @param y Значение 2.
     * @return Результат.
     */
    static private function compare(x:Float, y:Float):Int {
        if (x > y) return 1;
        if (x < y) return -1;
        return 0;
    }

    /**
     * Поиск элемента в массиве.  
     * Возвращает индекс искомого элемента в массиве или,
     * если такого нет - индекс ближайшего значения слева.
     * @param v Искомое значение.
     * @param a Массив.
     * @return Индекс элемента или соседа слева.
     */
    static private function search(value:Float, arr:Array<Float>):Int {
        // todo: Тут можно написать бинарный поиск для оптимизации
        var i = 0;
        var len = arr.length;
        while (i < len) {
            if (arr[i] > value)
                return i-1;
            i ++;
        }
        return i-1;
    }
}

/**
 * Якорь.  
 * Представляет собою координату на одной из осей.  
 * По сути, это просто число с плавающей точкой,
 * которое может быть: `null`
 */
@:dce
typedef Anchor = Null<Float>;