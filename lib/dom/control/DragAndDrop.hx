package dom.control;

import js.Browser;
import js.html.Element;
import js.html.PointerEvent;
import tools.Dispatcher;
import tools.NativeJS;

/**
 * Контроллер перетаскивания.  
 * Используется как единое место, в котором реализован
 * функционал перетаскивания HTML DOM элементов.
 * 
 * Способ использования:
 * - Создать новый экземпляр.
 * - Настроить контроллер, если нужно поведение,
 *   отличное от стандартного.
 * - Указать перетаскиваемый объект.
 * - Подписаться на события и ждать их вызова.
 * 
 * Класс используется как композиция.
 */
@:dce
class DragAndDrop
{
    /**
     * Создать новый экземпляр.  
     * @param target Перетаскиваемая цель.
     */
    public function new(?target:Element) {
        if (target != null)
            this.target = target;
    }

    /**
     * Квадратичная кривая Безье для эффекта избыточного натяжения.
     * @param v Скалярное значение: 0-1.
     * @return Скалярное значение: 0-1 для новой позиции.
     * @see Квадратичные кривые Безье: https://ru.wikipedia.org/wiki/%D0%9A%D1%80%D0%B8%D0%B2%D0%B0%D1%8F_%D0%91%D0%B5%D0%B7%D1%8C%D0%B5
     */
    static private function bz(v:Float):Float {
        return 2*v*(1-v)*0.5 + Math.pow(v,2)*0.5;
    }

    /**
     * Кешированное значение по оси X. (px)  
     * По умолчанию: `0`
     */
    private var cx(default, null):Float = 0;

    /**
     * Кешированное значение по оси Y. (px)  
     * По умолчанию: `0`
     */
    private var cy(default, null):Float = 0;

    /**
     * Координаты элемента на оси X. (px)  
     * Содержит последние координаты, заданные объекту при
     * его перетаскиваний. Обновляются только при
     * перетаскивании.
     * 
     * По умолчанию: `0`
     */
    public var x(default, null):Float = 0;

    /**
     * Координаты элемента на оси Y. (px)  
     * Содержит последние координаты, заданные объекту при
     * его перетаскиваний. Обновляются только при
     * перетаскивании.
     * 
     * По умолчанию: `0`
     */
    public var y(default, null):Float = 0;

    /**
     * Перетаскивание активно.  
     * Флаг принимает значение `true`, когда начинается
     * процесс перетаскивания элемента. Может быть полезно
     * для внешнего кода.
     * 
     * По умолчанию: `false`
     */
    public var isDrag(default, null):Bool = false;

    /**
     * Ограничение минимума для области перетаскивания по оси X. (px)  
     * Если не задано, ограничение не используется.
     * 
     * По умолчанию: `null` *(Без ограничения)*
     */
    public var minX:Null<Float> = null;

    /**
     * Ограничение максимума для области перетаскивания по оси X. (px)  
     * Если не задано, ограничение не используется.
     * 
     * По умолчанию: `null` *(Без ограничения)*
     */
    public var maxX:Null<Float> = null;

    /**
     * Ограничение минимума для области перетаскивания по оси Y. (px)  
     * Если не задано, ограничение не используется.
     * 
     * По умолчанию: `null` *(Без ограничения)*
     */
    public var minY:Null<Float> = null;

    /**
     * Ограничение максимума для области перетаскивания по оси Y. (px)  
     * Если не задано, ограничение не используется.
     * 
     * По умолчанию: `null` *(Без ограничения)*
     */
    public var maxY:Null<Float> = null;

    /**
     * Выход перетаскиваемого объекта за правую область. (px)  
     * Это значение регулирует максимальное расстояние, на
     * которое можно вытащить контент за пределы разрешённой
     * зоны: `maxX`
     * - Если `maxX` не задан, это свойство игнорируется.
     * - Это значение не должно быть меньше нуля.
     * 
     * По умолчанию: `0` *(Выход за область не разрешён)*
     */
    public var outRight:Float = 0;

    /**
     * Выход перетаскиваемого объекта за левую область. (px)  
     * Это значение регулирует максимальное расстояние, на
     * которое можно вытащить контент за пределы разрешённой
     * зоны: `minX`
     * - Если `minX` не задан, это свойство игнорируется.
     * - Это значение не должно быть меньше нуля.
     * 
     * По умолчанию: `0` *(Выход за область не разрешён)*
     */
    public var outLeft:Float = 0;

    /**
     * Выход перетаскиваемого объекта за верхнюю область. (px)  
     * Это значение регулирует максимальное расстояние, на
     * которое можно вытащить контент за пределы разрешённой
     * зоны: `minY`
     * - Если `minY` не задан, это свойство игнорируется.
     * - Это значение не должно быть меньше нуля.
     * 
     * По умолчанию: `0` *(Выход за область не разрешён)*
     */
    public var outTop:Float = 0;

    /**
     * Выход перетаскиваемого объекта за нижнюю область. (px)  
     * Это значение регулирует максимальное расстояние, на
     * которое можно вытащить контент за пределы разрешённой
     * зоны: `maxY`
     * - Если `maxY` не задан, это свойство игнорируется.
     * - Это значение не должно быть меньше нуля.
     * 
     * По умолчанию: `0` *(Выход за область не разрешён)*
     */
    public var outBottom:Float = 0;

    /**
     * Избыточное натяжение по оси X. (От `-1` до `1`)  
     * Этот коэффициент указывает на силу избыточного натяжения
     * пользователем, когда он вытащил контент за рамки
     * допустимой зоны.
     * 
     * С помощью этого значения вы можете добавить дополнительные
     * эффекты интерфейса, указывающие на избыточное натяжение
     * или выход за допустимую область при перетаскиваний.
     * 
     * - Если границы для перетаскивания не заданы, это
     *   значение всегда будет равно нулю.
     * - Если границы заданы жёстко (out'ы равны нулю), то при
     *   выходе курсора за область, это значение всегда будет
     *   иметь `-1` или `1` для каждой из сторон.
     * - Если выход за пределы разрешён на некоторое расстояние
     *   (out'ы больше нуля), это значение будет линейно
     *   скалироваться от нуля в одну из сторон, в которую тянут.
     * 
     * По умолчанию: `0` *(Нет избыточного натяжения)*
     */
    public var tugX(default, null):Float = 0;

    /**
     * Избыточное натяжение по оси Y. (От `-1` до `1`)  
     * Этот коэффициент указывает на силу избыточного натяжения
     * пользователем, когда он вытащил контент за рамки
     * допустимой зоны.
     * 
     * С помощью этого значения вы можете добавить дополнительные
     * эффекты интерфейса, указывающие на избыточное натяжение
     * или выход за допустимую область при перетаскиваний.
     * 
     * - Если границы для перетаскивания не заданы, это
     *   значение всегда будет равно нулю.
     * - Если границы заданы жёстко (out'ы равны нулю), то при
     *   выходе курсора за область, это значение всегда будет
     *   иметь `-1` или `1` для каждой из сторон.
     * - Если выход за пределы разрешён на некоторое расстояние
     *   (out'ы больше нуля), это значение будет линейно
     *   скалироваться от нуля в одну из сторон, в которую тянут.
     * 
     * По умолчанию: `0` *(Нет избыточного натяжения)*
     */
    public var tugY(default, null):Float = 0;

    /**
     * Чувствительность. (px)  
     * Используется для исключения случайного перетаскивания,
     * когда указатель случайно сместился на пару пикселей.
     * Это расстояние, которое должен пройти указатель, чтоб
     * режим перетаскивания был активирован.
     * - Это значение не может быть меньше нуля.
     * 
     * По умолчанию: `5`
     */
    public var sensitive(default, set):Float = 5;
    function set_sensitive(value:Float):Float {
        if (value > 0)
            sensitive = value;
        else
            sensitive = 0;
        return value;
    }

    /**
     * Перетаскиваемый элемент.  
     * Это свойство позволяет задать управляемый этим
     * контроллером объект для перетаскивания.
     * - Если объект уже задан, он будет отключён.
     * - Если задать `null`, имеющийся объект будет отключен.
     * - Никакие событие не посылаются.
     * 
     * По умолчанию: `null` *(Перетаскиваемый элемент не задан)*
     */
    public var target(default, set):Element = null;
    function set_target(value:Element):Element {
        if (value == target)
            return value;
        stop();
        if (target != null)
            target = null;
        target = value;
        if (value != null)
            value.addEventListener("pointerdown", onDown);
        return value;
    }

    /**
     * Перетаскивание выключено.  
     * Свойство позволяет временно отключить перетаскивание.
     * - Если при выключении перетаскивается объект, перетаскивание
     *   прерывается, как при взове метода: `stop()`
     * - События не посылаются.
     * 
     * По умолчанию: `false`
     */
    public var disabled(default, set):Bool = false;
    function set_disabled(value:Bool):Bool {
        if (value == disabled)
            return value;

        disabled = value;
        if (value)
            stop();

        return value;
    }

    /**
     * Событие запуска перетаскивания.  
     * Посылается, когда пользователь начал перетаскивать элемент.
     * - Это событие всегда предшествует событию: `evMove`
     * - Это событие посылается один раз для каждого, нового перетаскивания.
     * 
     * Не может быть: `null`
     */
    public var evStart(default, never):Dispatcher<DragAndDrop->Void> = new Dispatcher();

    /**
     * Событие перетаскивания.  
     * Посылается каждый раз, когда пользователь перетаскивает элемент.
     * - Это событие непрерывно посылается, когда пользователь
     *   "тащит" элемент.
     * 
     * Не может быть: `null`
     */
    public var evMove(default, never):Dispatcher<DragAndDrop->Void> = new Dispatcher();

    /**
     * Событие броска перетаскивания.  
     * Посылается в конце, когда пользователь "положил" элемент.
     * - Это событие всегда посылается после: `evMove`
     * - Это событие всегда предшествует событию: `evStop`
     * - Это событие **может не посылаться**, если пользователь
     *   отменил перетаскивание элемента. (Указатель был отключён или т.п.)
     * 
     * Не может быть: `null`
     */
    public var evDrop(default, never):Dispatcher<DragAndDrop->Void> = new Dispatcher();

    /**
     * Событие завершения перетаскивания.  
     * Посылается в самом конце, когда перетаскивание было завершено
     * или отменено.
     * - Это событие всегда посылается последним.
     * - Это событие посылается всегда, в отличие от: `evDrop`
     * 
     * Не может быть: `null`
     */
    public var evStop(default, never):Dispatcher<DragAndDrop->Void> = new Dispatcher();

    /**
     * Завершить перетаскивание объекта.  
     * Этот вызов прекращает перетаскивание объекта, если оно
     * выполняется в данный момент. Иначе вызов игнорируется.
     * 
     * Вызов этого метода не посылает никаких событий.
     */
    public function stop():Void {
        if (target == null)
            return;

        target.removeEventListener("pointerdown", onDown);
        Browser.window.removeEventListener("pointermove", onMove);
        Browser.window.removeEventListener("pointerup", onUp);
        Browser.window.removeEventListener("pointercancel", onCancel);
        isDrag = false;
        tugX = 0;
        tugY = 0;
    }

    /**
     * Нажатие.
     * @param e Нативное событие.
     */
    private function onDown(e:PointerEvent):Void {
        if (disabled)
            return;
        e.stopImmediatePropagation();

        Browser.window.addEventListener("pointermove", onMove);
        Browser.window.addEventListener("pointerup", onUp);
        Browser.window.addEventListener("pointercancel", onCancel);

        cx = e.clientX;
        cy = e.clientY;
    }

    /**
     * Перетаскивание.
     * @param e Нативное событие.
     */
    private function onMove(e:PointerEvent):Void {
        var es = false;

        // Проверка на прохождение чувствительности.
        // Если курсор не ушёл далеко, драг не запускаем!
        if (!isDrag) {
            var dx = cx - e.clientX;
            var dy = cy - e.clientY;
            if (Math.sqrt(dx*dx + dy*dy) < sensitive)
                return;

            // Запоминаем исходную точку, чтоб от неё позицианироваться:
            cx = e.clientX - target.offsetLeft;
            cy = e.clientY - target.offsetTop;
            es = true;
            isDrag = true;

            // Поправка на margin, если не учесть - точка съезжает:
            var s = Browser.window.getComputedStyle(target);
            var mt = NativeJS.parseFloat(s.marginTop);
            var ml = NativeJS.parseFloat(s.marginLeft);
            if (mt > 0 || mt < 0)
                cx += mt;
            if (ml > 0 || ml < 0)
                cy += ml;
        }

        // Расчитываем новые координаты:
        x = e.clientX - cx;
        y = e.clientY - cy;

        // Ограничения и натяжения:
        tugX = 0;
        tugY = 0;
        if (maxX != null) {
            if (x > maxX) {
                if (outRight > 0) {
                    tugX = Math.min(1,(x-maxX)/(outRight*2));
                    x = maxX + bz(tugX)*outRight*2;
                }
                else {
                    tugX = 1;
                    x = maxX;
                }
            }
        }
        if (minX != null) {
            if (x < minX) {
                if (outLeft > 0) {
                    tugX = -Math.min(1,(minX-x)/(outLeft*2));
                    x = minX - bz(-tugX)*outLeft*2;
                }
                else {
                    tugX = -1;
                    x = minX;
                }
            }
        }
        if (maxY != null) {
            if (y > maxY) {
                if (outBottom > 0) {
                    tugY = Math.min(1,(y-maxY)/(outBottom*2));
                    y = maxY + bz(tugY)*outBottom*2;
                }
                else {
                    tugY = 1;
                    y = maxY;
                }
            }
        }
        if (minY != null) {
            if (y < minY) {
                if (outTop > 0) {
                    tugY = -Math.min(1,(minY-y)/(outTop*2));
                    y = minY - bz(-tugY)*outTop*2;
                }
                else {
                    tugY = -1;
                    y = minY;
                }
            }
        }

        // Установка:
        target.style.left = x + "px";
        target.style.top = y + "px";

        // События:
        if (es)
            evStart.emit(this);
        evMove.emit(this);
    }

    /**
     * Бросок.
     * @param e Нативное событие.
     */
    private function onUp(e:PointerEvent):Void {
        onCancel(e, true);
    }

    /**
     * Отмена.
     * @param e Нативное событие.
     * @param up Вызов из `onUp`.
     */
    private function onCancel(e:PointerEvent, ?up:Bool):Void {
        Browser.window.removeEventListener("pointermove", onMove);
        Browser.window.removeEventListener("pointerup", onUp);
        Browser.window.removeEventListener("pointercancel", onCancel);

        isDrag = false;
        tugX = 0;
        tugY = 0;

        if (up)
            evDrop.emit(this);
        evStop.emit(this);
    }
}