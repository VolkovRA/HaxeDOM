package dom.utils;

import js.Syntax;

/**
 * Нативный JS.  
 * Статический класс с нативными JavaScript функциями.
 */
@:dce
class NativeJS
{
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
}