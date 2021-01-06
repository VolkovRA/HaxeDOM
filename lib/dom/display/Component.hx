package dom.display;

import dom.enums.CSSClass;
import dom.geom.Rect;
import dom.theme.Theme;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.Browser;
import js.lib.Error;
import js.html.Element;

/**
 * Компонент.  
 * Это конечный узел дерева отображения, который
 * представляет какой-то, конкретный элемент UI.
 * Это может быть кнопка, текстовое поле, скроллбар
 * или т.п.
 * 
 * Компонент используется для добавления дополнительных
 * возможностей стандартному DOM API. Может
 * использоваться самостоятельно или как базовый класс.
 * 
 * В DOM по умолчанию представлен тегом: `<div>`
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
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        this.node = NativeJS.setNodeID(node==null?Browser.document.createDivElement():node);
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



    /////////////////
    //   СОБЫТИЯ   //
    /////////////////

    /**
     * Событие добавления в родительский контейнер.  
     * Посылается при добалении этого компонента в контейнер.  
     * 
     * Не может быть: `null`
     */
    public var evAdded(default, never):Dispatcher<Component->Void> = new Dispatcher();

    /**
     * Событие удаления из родительского контейнера.  
     * Посылается при удалении этого компонента из
     * родительского контейнера.
     * 
     * Не может быть: `null`
     */
    public var evRemoved(default, never):Dispatcher<Component->Void> = new Dispatcher();

    /**
     * Событие добавления на сцену.  
     * Посылается при добавлении этого компонента или одного
     * из его родителей на сцену. (Добавлен в DOM)
     * 
     * Не может быть: `null`
     */
    public var evAddedToStage(default, never):Dispatcher<Component->Void> = new Dispatcher();

    /**
     * Событие удаления со сцены.  
     * Посылается при удалении этого компонента или одного из
     * его родителей со сцены. (Удалён из DOM)
     * 
     * Не может быть: `null`
     */
    public var evRemovedFromStage(default, never):Dispatcher<Component->Void> = new Dispatcher();



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

            if (e1) evRemoved.emit(this);
            if (e2) evRemovedFromStage.emit(this);

            return;
        }

        if (componentID == value.componentID)
            throw new Error("Нельзя добавить элемент в самого себя");

        if (parent == null) {
            // Добавление в родителя:
            var e1 = stage != value.stage;
            parent = value;
            stage = value.stage;

            evAdded.emit(this);
            if (e1) evAddedToStage.emit(this);
        }
        else {
            // Смена родителя:
            var e1 = stage!=null&&value.stage==null;
            var e2 = stage==null&&value.stage!=null;
            parent = value;
            stage = value.stage;

            evRemoved.emit(this);
            evAdded.emit(this);
            if (e1) evRemovedFromStage.emit(this);
            if (e2) evAddedToStage.emit(this);
        }
    }
}