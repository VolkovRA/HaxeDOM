package dom.geom;

/**
 * Прямоугольник.  
 * Класс описывает прямоугольную область и методы
 * для работы с ней.
 */
@:dce
class Rect
{
    /**
     * Создать новый прямоугольник.
     * @param x Позиция по X.
     * @param y Позиция по Y.
     * @param w Ширина.
     * @param h Высота.
     */
    public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float) {
        this.x = x==null?0:x;
        this.y = y==null?0:y;
        this.w = w==null?0:w;
        this.h = h==null?0:h;
    }

    /**
     * Позиция по X.
     */
    public var x:Float;

    /**
     * Позиция по Y.
     */
    public var y:Float;

    /**
     * Ширина.
     */
    public var w:Float;

    /**
     * Высота.
     */
    public var h:Float;

    /**
     * Получить копию прямоугольника.  
     * @return Возвращает копию исходного объекта.
     */
    public function copy():Rect {
        return new Rect(x, y, w, h);
    }

    /**
     * Задать прямоугольник.  
     * @param x Позиция по X.
     * @param y Позиция по Y.
     * @param w Ширина.
     * @param h Высота.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function set(x:Float, y:Float, w:Float, h:Float):Rect {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        return this;
    }

    /**
     * Скопировать параметры из другого объекта.  
     * Копирует в этот прямоугольник все значения из указанного объекта.
     * @param obj Другой прямоугольник или объект.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function setFrom(obj:Dynamic):Rect {
        x = obj.x==null?0:obj.x;
        y = obj.y==null?0:obj.y;
        w = obj.w==null?0:obj.w;
        h = obj.h==null?0:obj.h;
        return this;
    }

    /**
     * Проверка на пересечение с точкой.  
     * Возвращает `true`, если указанная точка находится внутри или
     * на грани текущего прямоугольника.
     * @param point Проверяемая точка.
     */
    public function hitPoint(point:Point):Bool {
        // Проверка оси X с учётом отрицательных размеров:
        if (w < 0) {
            if (point.x < x + w)    return false;
            if (point.x > x)        return false;
        }
        else {
            if (point.x < x)        return false;
            if (point.x > x + w)    return false;
        }

        // Проверка оси Y с учётом отрицательных размеров:
        if (h < 0) {
            if (point.y < y + h)    return false;
            if (point.y > y)        return false;
        }
        else {
            if (point.y < y)        return false;
            if (point.y > y + h)    return false;
        }

        return true;
    }

    /**
     * Проверка на пересечение с другим прямоугольником.  
     * Возвращает `true`, если переданный прямоугольник пересекает текущий.
     * @param rect Другой прямоугольник для проверки на пересечение.
     * @return Прямоугольники пересекаются.
     */
    public function hitRect(rect:Rect):Bool {
        // Проверка оси X с учётом отрицательных размеров:
        if (w < 0) {
            if (rect.w < 0) {
                if (x < rect.x + rect.w)        return false;
                if (x + w > rect.x)             return false;
            }
            else {
                if (x < rect.x)                 return false;
                if (x + w > rect.x + rect.w)    return false;
            }
        }
        else {
            if (rect.w < 0) {
                if (x + w < rect.x + rect.w)    return false;
                if (x > rect.x)                 return false;
            }
            else {
                if (x + w < rect.x)             return false;
                if (x > rect.x + rect.w)        return false;
            }
        }

        // Проверка оси Y с учётом отрицательных размеров:
        if (h < 0) {
            if (rect.h < 0) {
                if (y < rect.y + rect.h)        return false;
                if (y + h > rect.y)             return false;
            }
            else {
                if (y < rect.y)                 return false;
                if (y + h > rect.y + rect.h)    return false;
            }
        }
        else {
            if (rect.h < 0) {
                if (y + h < rect.y + rect.h)    return false;
                if (y > rect.y)                 return false;
            }
            else {
                if (y + h < rect.y)             return false;
                if (y > rect.y + rect.h)        return false;
            }
        }

        return true;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String {
        return "[Rect x=" + x + " y=" + y + " w=" + w + " h=" + h + "]";
    }
}