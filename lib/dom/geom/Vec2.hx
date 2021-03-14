package dom.geom;

/**
 * Вектор.  
 * Описывает скорость и направление движения в
 * двумерном, евклидовом пространстве.  
 * п.с. Вектор также может выступать в качестве
 * точки: `dom.geom.Point`
 */
@:dce
class Vec2
{
    /**
     * Создать вектор.  
     * @param x Ось X.
     * @param y Ось Y.
     */
    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }

    /**
     * Ось X.  
     * По умолчанию: `0`
     */
    public var x:Float;

    /**
     * Ось Y.  
     * По умолчанию: `0`
     */
    public var y:Float;

    /**
     * Получить копию вектора.  
     * @return Возвращает копию исходного объекта.
     */
    public function copy():Vec2 {
        return new Vec2(x, y);
    }

    /**
     * Получить длину вектора.  
     * @return Длина вектора.
     */
    public function len():Float {
        return Math.sqrt(x*x + y*y);
    }

    /**
     * Нормализовать вектор.  
     * Приводит длину вектора к единице. Вектор не изменяется,
     * если его длина равна нулю. (`x=0 && y=0`)
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function nrm():Vec2 {
        if (x == 0 && y == 0)
            return this;
        var len = Math.sqrt(x*x + y*y);
        x /= len;
        y /= len;
        return this;
    }

    /**
     * Задать вектор.  
     * @param x Ось X.
     * @param y Ось Y.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function set(x:Float, y:Float):Vec2 {
        this.x = x;
        this.y = y;
        return this;
    }

    /**
     * Скопировать параметры из другого объекта.  
     * Копирует в этот вектор все значения из указанного объекта.
     * @param obj Другой вектор или объект.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function setFrom(obj:Dynamic):Vec2 {
        x = obj.x==null?0:obj.x;
        y = obj.y==null?0:obj.y;
        return this;
    }

    /**
     * Сделать вектор модульным. (Удалить знаки минус)  
     * ```
     * x = |x|
     * y = |y|
     * ```
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function abs():Vec2 {
        if (x < 0) x = -x;
        if (y < 0) y = -y;
        return this;
    }

    /**
     * Сложение осей вектора с указанным значением.  
     * ```
     * x + v
     * y + v
     * ```
     * @param v Добавляемое значение.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function add(v:Float):Vec2 {
        this.x += v;
        this.y += v;
        return this;
    }

    /**
     * Вычитание из осей вектора указанного значения.  
     * ```
     * x - v
     * y - v
     * ```
     * @param v Вычитаемое значение.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function sub(v:Float):Vec2 {
        this.x -= v;
        this.y -= v;
        return this;
    }

    /**
     * Умножение осей вектора на скалярное значение.  
     * ```
     * x * v
     * y * v
     * ```
     * @param v Скалярное значение.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function mul(v:Float):Vec2 {
        this.x *= v;
        this.y *= v;
        return this;
    }

    /**
     * Деление осей вектора на скалярное значение.  
     * ```
     * x / v
     * y / v
     * ```
     * @param v Скалярное значение.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function div(v:Float):Vec2 {
        this.x /= v;
        this.y /= v;
        return this;
    }

    /**
     * Сложение векторов.  
     * Складывает текущий вектор с переданным и возвращает текущий вектор.
     * ```
     * x + x2
     * y + y2
     * ```
     * @param vec Добавляемый вектор.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function addVec(vec:Point):Vec2 {
        x += vec.x;
        y += vec.y;
        return this;
    }

    /**
     * Вычитание векторов.  
     * Вычитает из текущего вектора переданный и возвращает текущий вектор.
     * ```
     * x - x2
     * y - y2
     * ```
     * @param vec Вычитаемый вектор.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function subVec(vec:Point):Vec2 {
        x -= vec.x;
        y -= vec.y;
        return this;
    }

    /**
     * Умножение векторов.  
     * Перемножение осей векторов.
     * ```
     * x * x2
     * y * y2
     * ```
     * @param vec Второй вектор.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function mulVec(vec:Point):Vec2 {
        x *= vec.x;
        y *= vec.y;
        return this;
    }

    /**
     * Деление векторов.  
     * Деление осей векторов.
     * ```
     * x / x2
     * y / y2
     * ```
     * @param vec Второй вектор.
     * @return Текущий экземпляр для записи операций в одну строку.
     */
    public function divVec(vec:Point):Vec2 {
        x /= vec.x;
        y /= vec.y;
        return this;
    }
}