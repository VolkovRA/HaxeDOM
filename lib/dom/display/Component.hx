package dom.display;

import dom.geom.Rect;
import dom.utils.DOM;
import js.Browser;
import js.lib.Error;
import js.html.Element;
import tools.Dispatcher;

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
     * Автоматически увеличивается на 1 при создании
     * нового компонента.
     */
    @:noCompletion
    static private var autoID(default, null):Int = 0;

    /**
     * Создать новый экземпляр.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        this.node = DOM.setNodeID(node==null?Browser.document.createDivElement():node);
    }



    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * ID Компонента.  
     * Уникальный ключ, однозначно идентифицирующий
     * этот экземпляр объекта в рамках Haxe приложения.
     * 
     * Полезен для однозначной идентификации этого
     * компонента в рамках запущеного приложения.
     * 
     * Не может быть: `null`
     */
    public var componentID(default, never):Int = ++autoID;

    /**
     * Корневой узел этого компонента.  
     * Используется как ссылка на елемент дерева DOM,
     * представляющего этот экземпляр компонента. Может
     * быть использована для доступа к нативным DOM API
     * элемента.
     * 
     * Некоторые особенности:
     * - Ссылка задаётся при создании экземпляра компонента
     *   и не может быть изменения в дальнейшем.
     * - Может содержать произвольное количество дочерних
     *   узлов.
     * - Каждый компонент управляет своим узлом на своё
     *   усмотрение. Например, этот узел **может**
     *   содержать другие узлы, управляемые компонентом.
     * - Не может быть: `null`.
     * - По умолчанию используется: `div`, если в конструктор
     *   не было передано иное.
     * 
     * Не может быть: `null`
     */
    public var node(default, null):Element;

    /**
     * Это контейнер!  
     * Используется для быстрой проверки типа в рантайме.  
     * Истина, если это экземпляр: `Container` или один
     * из его потомков.
     */
    public var isContainer(default, null):Bool = false;

    /**
     * Это корневой узел!  
     * Используется для быстрой проверки типа в рантайме.
     * Истина, если это экземпляр: `Stage` или один из
     * его потомков.
     */
    public var isStage(default, null):Bool = false;

    /**
     * Это элемент интерфейса!  
     * Используется для быстрой проверки типа в рантайме.
     * Истина, если это экземпляр: `UI` или один из
     * его потомков.
     */
    public var isUI(default, null):Bool = false;

    /**
     * Имя элемента.  
     * Используется для добавления имени DOM элементу.  
     * Это может быть полезно для нативных методов:
     * `document.getElementsByName()`
     * 
     * - Если указано новое значение, элементу присваивается
     *   атрибут: `name="value"`
     * - Если передан `null` или пустая строка, у элемента
     *   удаляется атрибут: `name`
     * 
     * По умолчанию: `null` *(Имя не задано)*
     */
    public var name(default, set):String = null;
    function set_name(value:String):String {
        if (value == name)
            return value;

        name = value;
        if (value == null || value == "")
            node.removeAttribute("name");
        else
            node.setAttribute("name", value);

        return value;
    }

    /**
     * Отображение компонента.  
     * Это свойство управляет CSS свойством: `display: none`,
     * для удобного показа/сокрытия элемента на странице, не
     * удаляя его из DOM.
     * 
     * Возможные значения:
     * - Если: `false`, DOM элементу устанавливается: `display: none`
     * - Если: `true`, у DOM элемента очищается CSS свойство: `display`
     * 
     * *п.с. Разница между свойствами: **display** и **visible**
     * в том, что в первом случае компонент удаляется из потока
     * визуализации DOM. Во втором случае, скрытый элемент по
     * прежнему занимает место на странице.*
     * 
     * По умолчанию: `true` *(Отображается)*
     */
    public var display(default, set):Bool = true;
    function set_display(value:Bool):Bool {
        if (value == display)
            return value;

        if (value) {
            display = true;
            node.style.display = null;
        }
        else {
            display = false;
            node.style.display = "none";
        }

        return value;
    }

    /**
     * Визуализация компонента.  
     * Это свойство управляет CSS свойством: `visibility: hidden`,
     * для удобного показа/сокрытия элемента на странице, не
     * удаляя его из DOM.
     * 
     * Возможные значения:
     * - Если: `false`, DOM элементу устанавливается: `visibility: hidden`
     * - Если: `true`, у DOM элемента очищается CSS свойство: `visibility`
     * 
     * *п.с. Разница между свойствами: **display** и **visible**
     * в том, что в первом случае компонент удаляется из потока
     * визуализации DOM. Во втором случае, скрытый элемент по
     * прежнему занимает место на странице.*
     * 
     * По умолчанию: `true` *(Отображается)*
     */
    public var visible(default, set):Bool = true;
    function set_visible(value:Bool):Bool {
        if (value == visible)
            return value;

        if (value) {
            visible = true;
            node.style.visibility = null;
        }
        else {
            visible = false;
            node.style.visibility = "hidden";
        }

        return value;
    }

    /**
     * Родительский контейнер.  
     * Автоматически устанавливается при добавлений или
     * удалений этого компонента из контейнера.
     * 
     * По умолчанию: `null`
     */
    public var parent(default, null):Container = null;

    /**
     * Корень сцены.  
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
     * **окна просмотра** браузера.
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
    public var evAdded(default, never):Dispatcher<Void->Void> = new Dispatcher();

    /**
     * Событие удаления из родительского контейнера.  
     * Посылается при удалении этого компонента из
     * родительского контейнера.
     * 
     * Не может быть: `null`
     */
    public var evRemoved(default, never):Dispatcher<Void->Void> = new Dispatcher();

    /**
     * Событие добавления на сцену.  
     * Посылается при добавлении этого компонента или одного
     * из его родителей на сцену. (Добавлен в DOM)
     * 
     * Не может быть: `null`
     */
    public var evAddedToStage(default, never):Dispatcher<Void->Void> = new Dispatcher();

    /**
     * Событие удаления со сцены.  
     * Посылается при удалении этого компонента или одного из
     * его родителей со сцены. (Удалён из DOM)
     * 
     * Не может быть: `null`
     */
    public var evRemovedFromStage(default, never):Dispatcher<Void->Void> = new Dispatcher();



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

        // Этот метод может быть вызван для контейнера.
        // Удаление из родителя:
        if (value == null) {
            var e1 = parent != null;
            var e2 = stage != null;
            var tree = getTree(this, []);

            parent = null;
            treeStage(tree, null);

            if (e1) evRemoved.emit(this);
            if (e2) treeRemovedFromStage(tree);

            return;
        }

        if (componentID == value.componentID)
            throw new Error("Нельзя добавить элемент в самого себя");

        if (parent == null) {
            // Добавление в родителя:
            var e2 = value.stage!=null;
            var tree = getTree(this, []);

            parent = value;
            treeStage(tree, value.stage);

            evAdded.emit(this);
            if (e2) treeAddedToStage(tree);
        }
        else {
            // Смена родителя:
            var e1 = stage!=null&&value.stage==null;
            var e2 = stage==null&&value.stage!=null;
            var tree = getTree(this, []);

            parent = value;
            treeStage(tree, value.stage);

            evRemoved.emit(this);
            evAdded.emit(this);
            if (e1) treeRemovedFromStage(tree);
            if (e2) treeAddedToStage(tree);
        }
    }

    /**
     * Получить список всех детей узла и его самого.  
     * Собирает в массив все дочерние узлы указанного
     * элемента.
     * @param child Искомый узел.
     * @param to Массив для вывода результата.
     */
    static private function getTree(child:Component, to:Array<Component>):Array<Component> {
        to.push(child);
        if (child.isContainer) {
            var len = untyped child.childrens.length;
            var i = 0;
            while (i < len)
                getTree(untyped child.childrens[i++], to);
        }
        return to;
    }

    /**
     * Установить свойство stage указанному дереву.
     * @param arr Дерево.
     * @param stage Стейдж.
     */
    static private function treeStage(arr:Array<Component>, stage:Stage):Void {
        var i = arr.length;
        while (i-- != 0)
            arr[i].stage = stage;
    }

    /**
     * Вызвать событие добавления на стейдж у всех элементов дерева.
     * @param arr Дерево элементов.
     */
    static private function treeAddedToStage(arr:Array<Component>):Void {
        var l = arr.length;
        var i = 0;
        while (i < l) {
            arr[i].evAddedToStage.emit(arr[i]);
            i ++;
        }
    }

    /**
     * Вызвать событие удаления со стейджа у всех элементов дерева.
     * @param arr Дерево элементов.
     */
    static private function treeRemovedFromStage(arr:Array<Component>):Void {
        var l = arr.length;
        var i = 0;
        while (i < l) {
            arr[i].evRemovedFromStage.emit(arr[i]);
            i ++;
        }
    }
}