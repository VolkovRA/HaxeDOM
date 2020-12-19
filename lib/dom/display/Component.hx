package dom.display;

import js.lib.Error;
import js.html.Element;
import dom.enums.Units;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;

/**
 * HTML Компонент.  
 * Компоненты используются для добавления дополнительных возможностей
 * обычным html элементам:
 * - Позицианирование элементов по `x` и `y` координатам.
 * - Событие добавления/удаления в родительский контейнер.
 * - Событие добавления/удаления на страницу (DOM).
 * 
 * Может использоваться самостоятельно или как базовый класс.
 */
@:dce
class Component<T:Component<T,E>, E:Element>
{
    /**
     * Авто-ID для всех новых компонентов.  
     * Автоматически увеличивается на 1 при создании нового компонента.
     */
    @:noCompletion
    static private var AUTO_ID:Int = 0;

    /**
     * Создать HTML компонент.
     * @param node Используемый DOM узел для этого экземпляра.
     * @throws Error HTML Элемент не должен быть: `null`
     */
    public function new(node:E) {
        if (node == null)
            throw new Error("HTML Элемент не должен быть null");

        this.node = node;
    }



    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * ID Компонента.  
     * Уникальный ключ, однозначно идентифицирующий этот экземпляр.
     * 
     * Не может быть `null`
     */
    @:noCompletion
    private var componentID(default, null):Int = ++AUTO_ID;

    /**
     * HTML Элемент, представляющий этот компонент.  
     * Не может быть `null`
     */
    public var node(default, null):E;

    /**
     * Позиция элемента по оси X.  
     * Позволяет позицианировать этот компонент в ручном режиме.
     * - Если задано, html компоненту устанавливается CSS свойство: `left: {x}px`
     * - Если передано `null`, у компонента удаляется CSS свойство: `left`
     * - Единицы имзерения по умолчанию: `px` Может быть изменено в свойстве: `units`
     * 
     * По умолчанию: `null`
     */
    public var x(default, set):Float = null;
    function set_x(value:Float):Float {
        if (value == x)
            return value;

        x = value;
        updateCSS_x();
        return value;
    }

    /**
     * Позиция элемента по оси Y. (px)  
     * Позволяет позицианировать этот компонент в ручном режиме.
     * - Если задано, html компоненту устанавливается CSS свойство: `top: {x}px`
     * - Если передано `null`, у компонента удаляется CSS свойство: `top`
     * - Единицы имзерения по умолчанию: `px` Может быть изменено в свойстве: `units`
     * 
     * По умолчанию: `null`
     */
    public var y(default, set):Float = null;
    function set_y(value:Float):Float {
        if (value == y)
            return value;

        y = value;
        updateCSS_y();
        return value;
    }

    /**
     * Ширина элемента. (px)  
     * При указании значения добавляет соответствующее CSS свойство.  
     * Позволяет жёстко задать размер.
     * - Если задано, html компоненту устанавливается CSS свойство: `width: {width}px`
     * - Если передано `null`, у компонента удаляется CSS свойство: `width`
     * - Единицы имзерения по умолчанию: `px` Может быть изменено в свойстве: `units`
     * 
     * По умолчанию: `null`
     */
    public var width(default, set):Float = null;
    function set_width(value:Float):Float {
        if (value == width)
            return value;

        width = value;
        updateCSS_width();
        return value;
    }

    /**
     * Высота элемента. (px)  
     * При указании значения добавляет соответствующее CSS свойство.  
     * Позволяет жёстко задать размер.
     * - Если задано, html компоненту устанавливается CSS свойство: `height: {height}px`
     * - Если передано `null`, у компонента удаляется CSS свойство: `height`
     * - Единицы имзерения по умолчанию: `px` Может быть изменено в свойстве: `units`
     * 
     * По умолчанию: `null`
     */
    public var height(default, set):Float = null;
    function set_height(value:Float):Float {
        if (value == height)
            return value;

        height = value;
        updateCSS_height();
        return value;
    }

    /**
     * Привязка позиции компонента к ближайшему пикселю.  
     * Это значение используется для округления устанавливаемого CSS значения
     * для: `x`, `y`, `width` и `height`, чтобы изображение не размывалось.  
     * Используется только для единиц измерения: `px`
     * 
     * По умолчанию: `true` (Округлять)
     */
    public var pixelSnapping(default, set):Bool = true;
    function set_pixelSnapping(value:Bool):Bool {
        if (value == pixelSnapping)
            return value;

        pixelSnapping = value;
        updateCSS();
        return value;
    }

    /**
     * Единицы измерения, используемые этим компонентом.  
     * Используется при заданий размеров компонента, позиций и т.п.
     * CSS парамтеров.
     * 
     * Единицы измерения CSS:
     * - `px` Пиксели. Базовая, абсолютная и окончательная единица
     *    измерения.
     * - `em` Относительно шрифта. `1em` – текущий размер шрифта.
     * - `%` Проценты.
     * - `rem` Относительно шрифта в корне. Размер расчитывается от
     *    размерша шрифта в теге: `<html>`
     * 
     * По умолчанию: `px`
     */
    public var units(default, set):String = Units.PX;
    function set_units(value:String):String {
        if (value == units)
            return value;

        units = value;
        updateCSS();
        return value;
    }

    /**
     * Родительский контейнер.  
     * Автоматически устанавливается при добавлений или удалений этого
     * компонента из контейнера.
     * 
     * По умолчанию: `null`
     */
    public var parent(default, null):Container<Dynamic, Dynamic> = null;

    /**
     * Основная сцена.  
     * Если компонент находится на главной сцене, это свойство будет
     * содержать на неё ссылку.
     * 
     * По умолчанию: `null`
     */
    public var stage(default, null):Stage<Dynamic> = null;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String {
        return "[Component]";
    }



    /////////////////
    //   СОБЫТИЯ   //
    /////////////////

    /**
     * Добавление в родительский контейнер. (Событие)  
     * Посылается при добалении этого компонента в контейнер: `parent`
     * 
     * Не может быть `null`
     */
    public var onAdded(default, null):Dispatcher<T->Void> = new Dispatcher();

    /**
     * Удаление из родительского контейнера. (Событие)  
     * Посылается при удалении этого компонента из контейнера: `parent`
     * 
     * Не может быть `null`
     */
    public var onRemoved(default, null):Dispatcher<T->Void> = new Dispatcher();

    /**
     * Добавление на сцену. (Событие)  
     * Посылается при добалении этого компонента в корневой DOM контейнер
     * Stage, отдельно или в качестве дочернего узла добавленного контейнера.
     * 
     * Не может быть `null`
     */
    public var onAddedToStage(default, null):Dispatcher<T->Void> = new Dispatcher();

    /**
     * Удаление со сцены. (Событие)  
     * Посылается при удалении этого компонента из корневого узла отдельно,
     * или в качестве дочернего элемента удалённого контейнера.
     * 
     * Не может быть `null`
     */
    public var onRemovedFromStage(default, null):Dispatcher<T->Void> = new Dispatcher();



    ////////////////
    //   ПРИВАТ   //
    ////////////////

    /**
     * Индекс этого компонента в родительском контейнере.  
     * Используется внутренней реализацией для оптимизации поиска при удалений.
     */
    @:noCompletion
    private var parentIndex:Int = -1;

    /**
     * Обновить все CSS свойства.
     */
    inline private function updateCSS():Void {
        updateCSS_x();
        updateCSS_y();
        updateCSS_width();
        updateCSS_height();
    }

    /**
     * Обновить значение CSS свойства для переменной: `x`
     */
    private function updateCSS_x():Void {
        if (x == null)
            node.style.left = "";
        else if (units == Units.PX)
            node.style.left = NativeJS.str(pixelSnapping?Math.round(x):x) + Units.PX;
        else 
            node.style.left = x + units;
    }

    /**
     * Обновить значение CSS свойства для переменной: `y`
     */
    private function updateCSS_y():Void {
        if (y == null)
            node.style.top = "";
        else if (units == Units.PX)
            node.style.top = NativeJS.str(pixelSnapping?Math.round(y):y) + Units.PX;
        else
            node.style.top = y + units;
    }

    /**
     * Обновить значение CSS свойства для переменной: `width`
     */
    private function updateCSS_width():Void {
        if (width == null)
            node.style.width = "";
        else if (units == Units.PX)
            node.style.width = NativeJS.str(pixelSnapping?Math.round(width):width) + Units.PX;
        else
            node.style.width = width + units;
    }

    /**
     * Обновить значение CSS свойства для переменной: `height`
     */
    private function updateCSS_height():Void {
        if (height == null)
            node.style.height = "";
        else if (units == Units.PX)
            node.style.height = NativeJS.str(pixelSnapping?Math.round(height):height) + Units.PX;
        else
            node.style.height = height + units;
    }

    /**
     * Установка нового родителя.
     * @param value Новый родитель.
     */
    @:noCompletion
    private function setParent(value:Container<Dynamic, Dynamic>):Void {
        if (parent == value)
            return;

        // Удаление из родителя:
        if (value == null) {
            var e1 = parent != null;
            var e2 = stage != null;

            parent = null;
            stage = null;

            if (e1) onRemoved.emit(this);
            if (e2) onRemovedFromStage.emit(this);

            return;
        }

        if (componentID == value.componentID)
            throw new Error("Нельзя добавить элемент в самого себя");

        if (parent == null) {
            // Добавление в родителя:
            var e1 = stage != value.stage;
            parent = value;
            stage = value.stage;

            onAdded.emit(this);
            if (e1) onAddedToStage.emit(this);
        }
        else {
            // Смена родителя:
            var e1 = stage!=null&&value.stage==null;
            var e2 = stage==null&&value.stage!=null;
            parent = value;
            stage = value.stage;

            onRemoved.emit(this);
            onAdded.emit(this);
            if (e1) onRemovedFromStage.emit(this);
            if (e2) onAddedToStage.emit(this);
        }
    }
}