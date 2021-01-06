package dom.utils;

import js.html.InputElement;

/**
 * Класс для кросс-браузерных решений.  
 * К сожалению, в 2020 всё ещё не все стандартные методы
 * и функций DOM API работают нормально и одинаково.
 * 
 * Статический класс.
 */
@:dce
class Cross
{
    /**
     * Безопасный вызов метода: `InputElement.stepUp()`
     * @param element HTML Элемент.
     */
    static public function stepUp(element:InputElement):Void {
        try {
            element.stepUp();
        }
        catch(err:Dynamic) {
            // IE, Edge - не поддерживают нормальное API:
            var m = NativeJS.parseFloat(element.max);
            var s = NativeJS.parseFloat(element.step);
            var v = NativeJS.parseFloat(element.value);
            var n = NativeJS.dec(element.step);
            if (NativeJS.isNaN(m)) m = null;
            if (NativeJS.isNaN(s)) s = 1;
            if (NativeJS.isNaN(v)) v = 0;
    
            if (m == null)
                element.value = untyped NativeJS.round(v + s, n);
            else
                element.value = untyped Math.min(m, NativeJS.round(v + s, n));
        }
    }

    /**
     * Безопасный вызов метода: `InputElement.stepDown()`
     * @param element HTML Элемент.
     */
    static public function stepDown(element:InputElement):Void {
        try {
            element.stepDown();
        }
        catch (err:Dynamic) {
            // IE, Edge - не поддерживают нормальное API:
            var m = NativeJS.parseFloat(element.min);
            var s = NativeJS.parseFloat(element.step);
            var v = NativeJS.parseFloat(element.value);
            var n = NativeJS.dec(element.step);
            if (NativeJS.isNaN(m)) m = null;
            if (NativeJS.isNaN(s)) s = 1;
            if (NativeJS.isNaN(v)) v = 0;

            if (m == null)
                element.value = untyped NativeJS.round(v - s, n);
            else
                element.value = untyped Math.max(m, NativeJS.round(v - s, n));
        }
    }
}