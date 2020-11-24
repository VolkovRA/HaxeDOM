package dom.utils;

import js.Syntax;

/**
 * Нативный JS.  
 * Статический класс с нативными JavaScript функциями.
 */
class NativeJS
{
    /**
     * Получить имя конструктора. (Нативный JS)  
     * @param value Проверяемое значение.
     * @return Возвращает тип JavaScript значения.
     */
    inline static public function constructorName(value:Dynamic):String {
        return Syntax.code("({0}.constructor.name)", value);
    }

    /**
     * Проверка на `undefined`. (Нативный JS)  
     * Возвращает `true`, если переданное значение равно `undefined`.
     * @param value Проверяемое значение.
     * @return Результат проверки.
     */
    inline static public function isUndefined(value:Dynamic):Bool {
        return Syntax.code('({0} === "undefined")', value);
    }

    /**
     * Вставка в произвольное место массива. (Нативный JS)  
     * Вставка в указанную позицию в массиве со сдвигом элементов вправо.
     * @param arr Изменяемый массив.
     * @param index Позиция для вставки.
     * @param value Вставляемое значение.
     */
    inline static public function arrInsert(arr:Array<Dynamic>, index:Int, value:Dynamic):Void {
        Syntax.code('{0}.splice({1}, 0, {2})', arr, index, value);
    }

    /**
     * Удалить указанный индекс в массиве. (Нативный JS)  
     * @param arr Изменяемый массив.
     * @param index Позиция для вставки.
     * @param value Вставляемое значение.
     */
    inline static public function arrRemove(arr:Array<Dynamic>, index:Int):Void {
        Syntax.code('{0}.splice({1}, 1)', arr, index);
    }
}