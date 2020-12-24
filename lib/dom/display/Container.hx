package dom.display;

import dom.utils.NativeJS;
import js.lib.Error;
import js.html.Element;

/**
 * Контейнер для компонентов.  
 * Используется для реализации "дерева отображения", позволяющее
 * использовать дополнительные возможности библиотеки, такие как:
 * - События добавления/удаления в родительский контейнер.
 * - События добавления/удаления в корневой DOM. (Stage)
 */
@:dce
class Container<T:Container<T,E>, E:Element> extends Component<T,E>
{
    /**
     * Создать контейнер для компонентов.  
     * @param node Используемый DOM узел для этого экземпляра.
     */
    public function new(node:E) {
        super(node);
    }

    /**
     * Список дочерних узлов.  
     * Не может быть `null`
     */
    @:noCompletion
    private var childrens:Array<Component<Dynamic, Dynamic>> = new Array();

    /**
     * Количество дочерних узлов.  
     * По умолчанию: `0`
     */
    public var numChildren(default, null):Int = 0;

    /**
     * Это контейнер.  
     * Используется для быстрой проверки типа в рантайме.
     */
    @:keep
    @:noCompletion
    public var isContainer(default, null):Bool = true;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Возвращает экземпляр дочернего экранного объекта, существующий в заданной позиции индекса.
     * @param index Позиция индекса дочернего объекта.
     * @return Дочерний экранный объект в заданной позиции индекса.
     */
    inline public function getChildAt(index:Int):Component<Dynamic, Dynamic> {
        return childrens[index];
    }

    /**
     * Добавить дочерний узел в список отображения.   
     * - Вызов игнорируется, если передан `null`
     * - Если узел уже содержится в списке, он перемещается в конец по иерархии DOM.
     * - Новый элемент добавляется в конец списка DOM.
     * @param child Экземпляр для добавления.
     */
    inline public function addChild(child:Component<Dynamic, Dynamic>):Void {
        addChildAt(child, numChildren);
    }

    /**
     * Добавить дочерний узел в список отображения в указанный индекс.
     * - Вызов игнорируется, если передан `null`
     * - Дочерний узел вставляется в указанную позицию в DOM.
     * @param child Экземпляр для добавления.
     * @param index Позиция индекса.
     */
    public function addChildAt(child:Component<Dynamic, Dynamic>, index:Int):Void {
        if (child == null)
            return;
        if (child.componentID == componentID)
            throw new Error("Нельзя добавить элемент в самого себя");
        if (untyped child.isContainer && untyped child.contains(this))
            throw new Error("Нельзя добавить родительский элемент первого или более порядка в качестве дочернего");
        if (untyped child.isStage)
            throw new Error("Нельзя добавить корневой узел Stage в качестве дочернего");

        if (child.parent == this) {
            // Элемент уже есть в списке - перестановка:
            if (index == child.parentIndex)
                return;

            if (index >= numChildren) {
                // Перестановка в конец списка:
                moveChild(childrens, child.parentIndex, numChildren-1);
                node.appendChild(child.node);
            }
            else {
                // Перестановка в произвольное место:
                moveChild(childrens, child.parentIndex, index);
                node.insertBefore(child.node, childrens[index+1].node);
            }
        }
        else {
            // Новый элемент:
            if (index < numChildren) {
                // Вставка в произвольное место:
                NativeJS.arrInsert(childrens, index, child);
                var i = ++numChildren;
                while (i-- > index) childrens[i].parentIndex = i; // Обновление индексов для актуализации.
                node.insertBefore(child.node, childrens[index+1].node);
                child.setParent(this);
            }
            else {
                // Вставка в конец:
                child.parentIndex = numChildren++;
                childrens[child.parentIndex] = child;
                node.appendChild(child.node);
                child.setParent(this);
            }
        }
    }

    /**
     * Удалить дочерний узел.  
     * - Вызов игнорируется, если передан `null`
     * - Вызов игнорируется, если переданный элемент не содержится в этом контейнере.
     * - Элемент удаляется из DOM дерева.
     * @param child 
     */
    public function removeChild(child:Component<Dynamic, Dynamic>):Component<Dynamic, Dynamic> {
        if (child == null || child.parent != this)
            return null;

        return removeChildAt(child.parentIndex);
    }

    /**
     * Удалить дочерний элемент в заданной позиции.  
     * Удаляет элемент с указанным индексом и возвращает его.
     * @param index Позиция удаления.
     * @return Удалённый элемент.
     */
    public function removeChildAt(index:Int):Component<Dynamic, Dynamic> {
        if (index > numChildren-1)
            return null;

        var child = childrens[index];
        NativeJS.arrRemove(childrens, index);
        var i = --numChildren;
        while (i-- > index) childrens[i].parentIndex = i; // Обновление индексов для актуализации.
        if (child.node.parentNode == node)
            node.removeChild(child.node);
        child.setParent(null);
        return child;
    }

    /**
     * Удалить все дочерние элементы.  
     * @param full Если `true`, полностью очищает ноду: `innerHTML=""`
     *             Иначе удаляет только дочерние экземпляры `dom.display.Component`
     */
    public function removeChildren(full:Bool = false):Void {
        var old = childrens;
        var i = 0;
        var len = old.length;
        childrens = new Array();
        numChildren = 0;

        // Очистка DOM:
        if (full) {
            node.innerHTML = "";
        }
        else {
            while (i < len) {
                var child = old[i++];
                if (node == child.node.parentNode)
                    node.removeChild(child.node);
            }
        }

        // События в конце:
        i = 0;
        while (i < len) old[i++].setParent(null);
    }

    /**
     * Проверить объект на наличие в этом контейнере.  
     * Определяет, является ли указанный объект дочерним объектом экземпляра
     * Container или самим экземпляром. Область поиска охватывает весь список
     * отображения, включая данный экземпляр Container. Нижестоящие элементы
     * второго, третьего и последующих уровней возвращают значение `true`
     * @param child Проверяемый элемент.
     * @return Возвращает `true`, если указанный элемент находится в списке или является им.
     */
    @:keep
    public function contains(child:Component<Dynamic, Dynamic>):Bool {
        if (child == null)
            return false;
        if (child.componentID == componentID)
            return true;
        
        var item = child.parent;
        while (true) {
            if (item == null)
                return false;
            if (untyped item.isStage)
                return false;
            if (item.componentID == componentID)
                return true;

            item = item.parent;
        }
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Container]";
    }



    ////////////////
    //   ПРИВАТ   //
    ////////////////
    
    /**
     * Установка нового родителя.
     * @param value Новый родитель.
     */
    @:noCompletion
    override private function setParent(value:Container<Dynamic, Dynamic>):Void {
        var no = stage==null;
        super.setParent(value);

        // Рассылка события: "onAddedToStage"
        if (no && stage != null) {
            var arr = getAllComponents();
            var i = arr.length;
            while (i-- != 0)
                arr[i].onAddedToStage.emit(arr[i]);
        }

        // Рассылка события: "onRemovedFromStage"
        if (!no && stage == null) {
            var arr = getAllComponents();
            var i = arr.length;
            while (i-- != 0)
                arr[i].onRemovedFromStage.emit(arr[i]);
        }
    }

    /**
     * Получить все дочерние компоненты.
     * @return Список с дочерними компонентами.
     */
    @:noCompletion
    private function getAllComponents():Array<Component<Dynamic, Dynamic>> {
        var arr = [];
        var i = childrens.length;
        while (i-- != 0) {
            if (untyped childrens[i].isContainer)
                arr = arr.concat(untyped childrens[i].getAllComponents());
            else
                arr.push(childrens[i]);
        }
        return arr;
    }

    /**
     * Передвинуть дочерний элемент.
     * @param arr Исходный массив.
     * @param index Позиция сдвигаемого элемента.
     * @param to Позиция назначения.
     */
    static private function moveChild(arr:Array<Component<Dynamic, Dynamic>>, index:Int, to:Int):Void {
        if (to > index) {
            // Вперёд
            var tmp = arr[index];
            while (index < to) {
                arr[index] = arr[index+1];
                arr[index].parentIndex = index;
                index ++;
            }
            tmp.parentIndex = to;
            arr[to] = tmp;
        }
        if (to < index) {
            // Назад
            var tmp = arr[index];
            while (index > to) {
                arr[index] = arr[index-1];
                arr[index].parentIndex = index;
                index --;
            }
            tmp.parentIndex = to;
            arr[to] = tmp;
        }
    }
}