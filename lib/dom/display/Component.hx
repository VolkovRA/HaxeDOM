package dom.display;

import dom.enums.CSSClass;
import dom.geom.Rect;
import dom.theme.Theme;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.lib.Error;
import js.html.Element;

/**
 * HTML Компонент.  
 * Компоненты используются для добавления дополнительных возможностей
 * обычным html элементам:
 * - Событие добавления/удаления в родительский контейнер.
 * - Событие добавления/удаления на страницу (DOM).
 * 
 * Может использоваться самостоятельно или как базовый класс.
 */
@:dce
class Component
{
    /**
     * Авто-ID для всех новых компонентов.  
     * Автоматически увеличивается на 1 при создании нового компонента.
     */
    @:noCompletion
    static private var autoID(default, null):Int = 0;

    /**
     * Создать новый экземпляр.
     * @param node Используемый DOM узел для этого экземпляра.
     * @throws Error HTML Элемент не должен быть: `null`
     */
    public function new(node:Element) {
        if (node == null)
            throw new Error("HTML Элемент не должен быть null");

        this.node = NativeJS.setNodeID(node);

        this.onAdded = new Dispatcher<Component->Void>();
        this.onRemoved = new Dispatcher<Component->Void>();
        this.onAddedToStage = new Dispatcher<Component->Void>();
        this.onRemovedFromStage = new Dispatcher<Component->Void>();
    }



    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * ID Компонента.  
     * Уникальный ключ, однозначно идентифицирующий этот экземпляр
     * объекта в рамках Haxe приложения.
     * 
     * Не может быть: `null`
     */
    public var componentID(default, null):Int = ++autoID;

    /**
     * Корневой узел этого компонента.  
     * Используется для представления этого компонента в DOM.
     * - Может содержать произвольное количество дочерних узлов,
     *   управляемых автоматически.
     * - Создаётся вместе с компонентом и никогда не удаляется.
     * - Вы можете добавлять в него собственные узлы без страха
     *   их удаления или перезаписи.
     * 
     * Не может быть: `null`
     */
    public var node(default, null):Element;

    /**
     * Тип компонента.  
     * Используется для дополнительной стилизации.
     * 
     * По умолчанию: `null` *(Дополнительное декорирование не используется)*
     * 
     * @see Темы оформления: `dom.theme.Theme`
     */
    public var type(default, set):String = null;
    function set_type(value:String):String {
        if (theme != null) {
            theme.clean(this);
            theme = null;
        }
        type = value;
        if (value != null && Theme.current != null) {
            theme = Theme.current;
            theme.apply(this);
        }
        return value;
    }

    /**
     * Используемая тема оформления.  
     * Свойство используется для автоматической очистки
     * дополнительной стилизации. (См.: `type`)
     * 
     * По умолчанию: `null`
     */
    @:noCompletion
    private var theme:Theme;

    /**
     * Компонент выключен.  
     * Переключение этого свойства может влиять на работу некоторых
     * UI компонентов.
     * - Если `true`, компонент в DOM будет помечен классом: `class="disabled"`
     *   Это также влияет на срабатывания событий некоторых компонентов, например,
     *   не будут посылаться события нажатия на кнопку.
     * - Если `false`, в DOM разметке будет удалён класс `class="disabled"` (Если есть).
     *   Компонент будет работать как обычно.
     * 
     * По умолчанию: `false` *(Компонент активен)*
     */
    public var disabled(get, set):Bool;
    function get_disabled():Bool {
        return untyped NativeJS.dnot(node.disabled);
    }
    function set_disabled(value:Bool):Bool {
        if (value) {
            untyped node.disabled = true;
            node.classList.add(CSSClass.DISABLED);
        }
        else {
            untyped node.disabled = false;
            node.classList.remove(CSSClass.DISABLED);
        }
        return value;
    }

    /**
     * Имя компонента.  
     * Вы можете задать произвольное имя вашему компоненту.
     * Больше никак не используется.
     * 
     * По умолчанию: `null`
     */
    public var name(default, set):String = null;
    function set_name(value:String):String {
        name = value;
        return value;
    }

    /**
     * Родительский контейнер.  
     * Автоматически устанавливается при добавлений или удалений этого
     * компонента из контейнера.
     * 
     * По умолчанию: `null`
     */
    public var parent(default, null):Container = null;

    /**
     * Основная сцена.  
     * Если компонент находится на главной сцене, это свойство будет
     * содержать на неё ссылку.
     * 
     * По умолчанию: `null`
     */
    public var stage(default, null):Stage = null;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Получить границы элемента.  
     * Метод вычисляет габариты элемента на странице и возвращает
     * стандартизированный объект - прямоугольник, который
     * содержит описание размеров и его положение относительно
     * **окна просмотра**.
     * @param rect Объект для записи. Если не передан - создаётся новый.
     * @return Прямоугольник с описанием размеров элемента.
     * @see Размер элемента: [getBoundingClientRect](https://developer.mozilla.org/ru/docs/Web/API/Element/getBoundingClientRect)
     */
    public function getBounds(?rect:Rect):Rect {
        if (rect == null)
            rect = new Rect();
        
        var r = node.getBoundingClientRect();
        rect.x = r.left;
        rect.y = r.top;

        // Кроссбраузерно, width может не быть, но он предпочтительнее
        // из-за отсутствия доп. вычислений с плавающей точкой:
        if (r.width == null) {
            rect.w = r.right-r.left;
            rect.h = r.bottom-r.top;
        }
        else {
            rect.w = r.width;
            rect.h = r.height;
        }

        return rect;
    }

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
     * Не может быть: `null`
     */
    public var onAdded(default, null):Dispatcher<Component->Void>;

    /**
     * Удаление из родительского контейнера. (Событие)  
     * Посылается при удалении этого компонента из контейнера: `parent`
     * 
     * Не может быть: `null`
     */
    public var onRemoved(default, null):Dispatcher<Component->Void>;

    /**
     * Добавление на сцену. (Событие)  
     * Посылается при добалении этого компонента в корневой DOM контейнер
     * Stage, отдельно или в качестве дочернего узла добавленного контейнера.
     * 
     * Не может быть: `null`
     */
    public var onAddedToStage(default, null):Dispatcher<Component->Void>;

    /**
     * Удаление со сцены. (Событие)  
     * Посылается при удалении этого компонента из корневого узла отдельно,
     * или в качестве дочернего элемента удалённого контейнера.
     * 
     * Не может быть: `null`
     */
    public var onRemovedFromStage(default, null):Dispatcher<Component->Void>;



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
     * Установка нового родителя.
     * @param value Новый родитель.
     */
    @:noCompletion
    private function setParent(value:Container):Void {
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