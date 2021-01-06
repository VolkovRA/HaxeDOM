package dom.ui;

import dom.control.Acceleration;
import dom.control.AnchorRuler;
import dom.control.DragAndDrop;
import dom.display.Component;
import dom.display.Container;
import dom.enums.CSSClass;
import dom.enums.Orientation;
import dom.enums.Overflow;
import dom.geom.Rect;
import dom.geom.Vec;
import dom.ticker.IAnimated;
import dom.ticker.Ticker;
import dom.utils.NativeJS;
import dom.utils.ResizeObserver;
import js.Browser;
import js.html.Element;

/**
 * Скроллер.  
 * Это обычный контейнер с возможностью перетаскивания
 * содержимого. Может использоваться как базовый класс
 * для других компонентов с перетаскиваемым содержимым.
 * 
 * В DOM представлен тегом: `<div class="scroller">`
 */
@:dce
class Scroller extends Container implements IAnimated
{
    /**
     * Создать новый экземпляр.
     * @param content Контейнер с содержимым.
     */
    public function new(?content:Container) {
        super(Browser.document.createDivElement());
        this.node.classList.add(CSSClass.SCROLLER);

        // Контент:
        if (content == null)
            content = new Container(Browser.document.createDivElement());
        this.content = content;
        this.content.node.classList.add(CSSClass.CONTENT);
        addChild(content);

        // Перетаскивание:
        this.drag.target = this.content.node;
        this.drag.outBottom = this.drag.outLeft = this.drag.outRight = this.drag.outTop = 120;
        this.drag.evStart.on(onDragStart);
        this.drag.evMove.on(onDragMove);
        this.drag.evDrop.on(onDragDrop);
        this.drag.evStop.on(onDragStop);

        // Скроллбар V:
        this.scrollV.orient = Orientation.VERTICAL;
        this.scrollV.step = 50;
        this.scrollV.evChange.on(onScrollV);

        // Скроллбар H:
        this.scrollH.orient = Orientation.HORIZONTAL;
        this.scrollH.step = 50;
        this.scrollH.evChange.on(onScrollH);

        // События:
        this.evAddedToStage.on(onAdded);
        this.evRemovedFromStage.on(onRemoved);
    }



    ////////////////////
    //   КОМПОЗИЦИЯ   //
    ////////////////////

    /**
     * Контейнер с содержимым.  
     * Не может быть: `null`
     */
    public var content(default, null):Container;

    /**
     * Якори на оси X.  
     * Используются для "прилипания" контента к конкретным
     * координатам. Добавьте точки, к которым должен липнуть
     * ваш контент.
     * 
     * Не может быть: `null`
     */
    public var anchorsX(default, never):AnchorRuler = new AnchorRuler();

    /**
     * Якори на оси Y.  
     * Используются для "прилипания" контента к конкретным
     * координатам. Добавьте точки, к которым должен липнуть
     * ваш контент.
     * 
     * Не может быть: `null`
     */
    public var anchorsY(default, never):AnchorRuler = new AnchorRuler();

    /**
     * Скроллбар горизонтальный.  
     * Не может быть: `null`
     */
    public var scrollH(default, never):Scrollbar = new Scrollbar();

    /**
     * Скроллбар вертикальный.  
     * Не может быть: `null`
     */
    public var scrollV(default, never):Scrollbar = new Scrollbar();

    /**
     * Контроллер ускорения при *"броске перетаскивания"*.  
     * Используется для расчёта ускорения, полученного в
     * результате "броска" контента пользователем при его
     * перетаскиваний.
     * 
     * Элемент композиции выделен в паблик для возможности
     * дополнительной настройки.
     * 
     * Не может быть: `null`
     */
    public var acceleration(default, never):Acceleration = new Acceleration();

    /**
     * Контроллер перетаскивания контента.  
     * Элемент композиции выделен в паблик для возможности
     * дополнительной настройки.
     * 
     * Не может быть: `null`
     */
    public var drag(default, never):DragAndDrop = new DragAndDrop();



    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * Объект для расчётов, чтоб не создавать каждый раз новый.  
     */
    static private var VEC(default, never):Vec = new Vec();

    /**
     * Данные тикера.  
     * Используется внутренней реализацией тикера, вы не должны
     * изменять параметры этого объекта!
     * 
     * По умолчанию: `null`
     */
    private var ticker:Dynamic = null;

    /**
     * Кешированный размер скроллера.  
     * Автоматически обновляется при изменений размеров онного.
     * Используется для внутренних расчётов.  
     * 
     * Не может быть: `null`
     */
    private var size(default, never):Rect = new Rect();

    /**
     * Кешированный размер контента.  
     * Автоматически обновляется при изменений размеров онного.
     * Используется для внутренних расчётов.  
     * 
     * Не может быть: `null`
     */
    private var sizeC(default, never):Rect = new Rect();

    /**
     * Кешированный размер вертикального скроллбара.  
     * Автоматически обновляется при изменений размеров онного.
     * Используется для внутренних расчётов.  
     * 
     * Не может быть: `null`
     */
    private var sizeSV(default, never):Rect = new Rect();

    /**
     * Кешированный размер горизонтального скроллбара.  
     * Автоматически обновляется при изменений размеров онного.
     * Используется для внутренних расчётов.  
     * 
     * Не может быть: `null`
     */
    private var sizeSH(default, never):Rect = new Rect();

    /**
     * Максимальная скорость для стыковки контента с якорем. (px/sec)  
     * Если контент проходит точку на этой скорости или ниже,
     * он будет автоматически захвачен ей.
     * 
     * По умолчанию: `50`
     */
    public var anchorsCatchSpeed:Float = 50;

    /**
     * Режим отображения горизонтального скроллбара.  
     * По умолчанию: `Overflow.AUTO`
     */
    public var overflowX(default, set):Overflow = Overflow.AUTO;
    function set_overflowX(value:Overflow):Overflow {
        if (overflowX == value)
            return value;
        overflowX = value;
        Ticker.global.add(this);
        return value;
    }

    /**
     * Режим отображения вертикального скроллбара.  
     * По умолчанию: `Overflow.AUTO`
     */
    public var overflowY(default, set):Overflow = Overflow.AUTO;
    function set_overflowY(value:Overflow):Overflow {
        if (overflowY == value)
            return value;
        overflowY = value;
        Ticker.global.add(this);
        return value;
    }

    /**
     * Скорость перемещения контента. (px/sec)  
     * Используется для создания анимации перемещения содержимого.  
     * - Обратите внимание, что при передаче этому свойству нового
     *   вектора, данные из нового **копируются**, экземпляр при
     *   этом не подменяется. Это действие автоматически запускает
     *   анимацию, в отличие от прямого изменения:
     *   `velocity.x = 32`
     * - Если вы передадите: `null`, текущий вектор будет
     *   установлен в: `x=0 y=0`
     * 
     * Не может быть: `null`
     */
    public var velocity(default, set):Vec = new Vec();
    public function set_velocity(value:Vec):Vec {
        if (value == null)
            velocity.set(0, 0);
        else
            velocity.setFrom(value);
        Ticker.global.add(this);
        return value;
    }

    /**
     * Понижение скорости с течением времени. (percent/sec)  
     * Используется для плавного затухания скорости
     * перемещения контента.  
     * 
     * По умолчанию: `1` *(Полная остановка за 1 секунду)*
     */
    public var movementDemp:Float = 1;

    /**
     * Минимальная скорость перемещения контента для полной
     * остановки. (px/sec)  
     * Если скорость контента опустится ниже этого значения,
     * он автоматически остановится.
     * 
     * По умолчанию: `1`
     */
    public var movementStop:Float = 1;

    /**
     * Минимальная скорость перемещения контента. (px/sec)  
     * Если задать это свойство, перемещение контента никогда
     * не остановится в ходе плавного затухания скорости.
     * 
     * Контент остановится, если только:
     * - Скорость перемещения опустится ниже значения в:
     *   `movementStop`, тогда он будет автоматически остановлен.
     * - Контент будет "примагничен" к одной из точек в:
     *   `anchorsX` или `anchorsY`
     * - Контент достиг края допустимой области.
     * - Скорость `velocity` была обнулена вручную.
     * 
     * По умолчанию: `0` *(Бесконечное движение не используется)*
     */
    public var movementMin:Float = 0;

    /**
     * Скорость возврата контента на своё место при его броске
     * за допустимой областью.  
     * По умолчанию: `30` *(3000%)*
     */
    public var dragBackSpeed:Float = 30;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Обновление.  
     * Метод вызывается каждый кадр и передаёт прошедшее
     * время для возможности создания эффекта анимации.
     * @param dt Прошедшее время с последнего цикла обновления. (sec)
     * @return Закончить анимацию. Передайте `true`, чтобы
     * удалить этот объект из последующих вызовов.
     */
    public function tick(dt:Float):Bool {
        var finish = true;
        //trace(dt);

        // Обновление состояния:
        // 1. Передвинуть контент.
        // 2. Показать или убрать скроллбары.
        // 3. Обновить размеры области вывода и драга.
        // 4. Вернуть контент на место при овердраге.
        // 5. Прилипить контент к якорям.
        // 6. Уменьшать скорость контента.
        // 7. Обновить ограничения области для драга.

        // Определяем необходимость наличия скроллбаров:
        var sx:Bool = overflowX==Overflow.SCROLL || (overflowX==Overflow.AUTO && (sizeC.w>0 && size.w<sizeC.w));
        var sy:Bool = overflowY==Overflow.SCROLL || (overflowY==Overflow.AUTO && (sizeC.h>0 && size.h<sizeC.h));
        
        // Считаем порт вывода:
        var pw = Math.max(0, sx?(size.w-sizeSV.w):size.w); // 0-n
        var ph = Math.max(0, sy?(size.h-sizeSH.h):size.h); // 0-n

        // Ограничения для драга:
        drag.maxX = 0;
        drag.maxY = 0;
        drag.minX = -Math.max(0, sizeC.w-(size.w-(sx?sizeSV.w:0)));
        drag.minY = -Math.max(0, sizeC.h-(size.h-(sy?sizeSH.h:0)));

        // Показываем или скрываем скроллбары:
        if (sy) {
            if (!node.classList.contains(CSSClass.VERTICAL))
                node.classList.add(CSSClass.VERTICAL);
            if (scrollV.parent == null)
                addChildAt(scrollV, 1);
            scrollV.min = 0;
            scrollV.max = sizeC.h-ph;
            scrollV.part = scrollV.max*(ph/sizeC.h);
        }
        else {
            if (node.classList.contains(CSSClass.VERTICAL))
                node.classList.remove(CSSClass.VERTICAL);
            if (scrollV.parent == this)
                removeChild(scrollV);
        }
        if (sx) {
            if (!node.classList.contains(CSSClass.HORIZONTAL))
                node.classList.add(CSSClass.HORIZONTAL);
            if (scrollH.parent == null)
                addChildAt(scrollH, sy?1:2); // Чтоб всегда шли в одном порядке в DOM
            scrollH.min = 0;
            scrollH.max = sizeC.w-pw;
            scrollH.part = scrollH.max*(pw/sizeC.w);
        }
        else {
            if (node.classList.contains(CSSClass.HORIZONTAL))
                node.classList.remove(CSSClass.HORIZONTAL);
            if (scrollH.parent == this)
                removeChild(scrollH);
        }

        // Если контент драгается - ничего не делаем, просто ждём.
        // Обновления будут запущены после дропа.
        if (drag.isDrag)
            return true;

        // Если нет времени - ничего не может произойти, даже мгновение.
        // Ждём следующий вызов.
        if (dt == 0)
            return false;

        // Позиция контента:
        var x = NativeJS.parseFloat(content.node.style.left);
        var y = NativeJS.parseFloat(content.node.style.top);
        if (NativeJS.isNaN(x)) x = 0;
        if (NativeJS.isNaN(y)) y = 0;

        // Торможение:
        var s = velocity.len(); // Скорость
        if (s > 0) {
            s = s-dt*movementDemp*s;
            if (s < movementMin)    s = movementMin;
            if (s <= movementStop)  s = 0;
            if (s > 0)              finish = false;
            velocity.nrm().mul(s);
        }

        // Ось X:
        if (x > drag.maxX) {
            velocity.x = 0;
            var dx = x - drag.maxX;
            if (dx > 0.5) {
                x -= dt*dragBackSpeed*dx;
                if (x < drag.maxX)
                    x = drag.maxX;
                else
                    finish = false;
            }
            else {
                x = drag.maxX;
            }
        }
        else if (x < drag.minX) {
            velocity.x = 0;
            var dx = drag.minX - x;
            if (dx > 0.5) {
                x += dt*dragBackSpeed*dx;
                if (x > drag.minX)
                    x = drag.minX;
                else
                    finish = false;
            }
            else {
                x = drag.minX;
            }
        }
        else if (s > 0) {
            var x1 = x+velocity.x*dt;
            if (anchorsCatchSpeed > 0 && s <= anchorsCatchSpeed) {
                var a = anchorsX.testMove(-x, -x1);
                if (a != null) {
                    x1 = -a;
                    velocity.x = 0;
                }
            }
            x = x1;
            if (x > drag.maxX) {
                x = drag.maxX;
                velocity.x = 0;
            }
            else if (x < drag.minX) {
                x = drag.minX;
                velocity.x = 0;
            }
            else
                finish = false;
            scrollH.value = -x;
        }

        // Ось Y:
        if (y > drag.maxY) {
            velocity.y = 0;
            var dy = y - drag.maxY;
            if (dy > 0.5) {
                y -= dt*dragBackSpeed*dy;
                if (y < drag.maxY)
                    y = drag.maxY;
                else
                    finish = false;
            }
            else {
                y = drag.maxY;
            }
        }
        else if (y < drag.minY) {
            velocity.y = 0;
            var dy = drag.minY - y;
            if (dy > 0.5) {
                y += dt*dragBackSpeed*dy;
                if (y > drag.minY)
                    y = drag.minY;
                else
                    finish = false;
            }
            else {
                y = drag.minY;
            }
        }
        else if (s > 0) {
            var y1 = y+velocity.y*dt;
            if (anchorsCatchSpeed > 0 && s <= anchorsCatchSpeed) {
                var a = anchorsY.testMove(-y, -y1);
                if (a != null) {
                    y1 = -a;
                    velocity.y = 0;
                }
            }
            y = y1;
            if (y > drag.maxY) {
                y = drag.maxY;
                velocity.y = 0;
            }
            else if (y < drag.minY) {
                y = drag.minY;
                velocity.y = 0;
            }
            else
                finish = false;
            scrollV.value = -y;
        }

        // Новые значения:
        content.node.style.left = x + "px";
        content.node.style.top = y + "px";
        return finish;
    }

    /**
     * Добавление на сцену. (evAddedToStage)
     */
    private function onAdded(s:Component):Void {
        ResizeObserver.on(node, onRes);
        ResizeObserver.on(content.node, onResC);
        ResizeObserver.on(scrollV.node, onResSV);
        ResizeObserver.on(scrollH.node, onResSH);

        getBounds(size);
        content.getBounds(sizeC);
        scrollV.getBounds(sizeSV);
        scrollH.getBounds(sizeSH);

        Ticker.global.add(this);
    }

    /**
     * Удалениe со сцены. (evRemovedFromStage)
     */
    private function onRemoved(s:Component):Void {
        drag.stop();

        ResizeObserver.off(node, onRes);
        ResizeObserver.off(content.node, onResC);
        ResizeObserver.off(scrollV.node, onResSV);
        ResizeObserver.off(scrollH.node, onResSH);
    }

    /**
     * Перетаскивание начато.
     */
    private function onDragStart(o:DragAndDrop):Void {
        acceleration.clear();
        velocity.mul(0);
    }

    /**
     * Перетаскивание.
     */
    private function onDragMove(o:DragAndDrop):Void {
        acceleration.add(o.x, o.y);
        scrollH.value = -o.x;
        scrollV.value = -o.y;
    }

    /**
     * Перетаскивание брошено.
     */
    private function onDragDrop(o:DragAndDrop):Void {
        velocity.setFrom(acceleration.get(VEC));
    }

    /**
     * Перетаскивание завершено.
     */
    private function onDragStop(o:DragAndDrop):Void {
        acceleration.clear();
        Ticker.global.add(this);
    }

    /**
     * Скролл горизонтального ползунка.
     */
    private function onScrollH(s:Scrollbar):Void {
        content.node.style.left = -s.value + "px";
        velocity.mul(0);
    }

    /**
     * Скролл вертикального ползунка.
     */
    private function onScrollV(s:Scrollbar):Void {
        content.node.style.top = -s.value + "px";
        velocity.mul(0);
    }

    /**
     * Ресайз самого скроллера.
     */
    private function onRes(e:Element):Void {
        getBounds(size);
        Ticker.global.add(this);
    }

    /**
     * Ресайз контента.
     */
    private function onResC(e:Element):Void {
        content.getBounds(sizeC);
        Ticker.global.add(this);
    }

    /**
     * Ресайз вертикального скроллбара.
     */
    private function onResSV(e:Element):Void {
        scrollV.getBounds(sizeSV);
        Ticker.global.add(this);
    }

    /**
     * Ресайз горизонтального скроллбара.
     */
    private function onResSH(e:Element):Void {
        scrollH.getBounds(sizeSH);
        Ticker.global.add(this);
    }
}