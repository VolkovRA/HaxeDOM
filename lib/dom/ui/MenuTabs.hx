package dom.ui;

import dom.enums.Style;
import dom.ui.base.LabelUI;
import js.Browser;
import js.html.DivElement;
import js.html.Element;
import js.html.MouseEvent;
import tools.Dispatcher;

/**
 * Меню с вкладками.  
 * В DOM представлен тегами: `<ul class="menu_tabs">`
 */
class MenuTabs extends LabelUI
{
    /**
     * Создать новый экземпляр.
     * @param items Кнопки меню.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<ul>`
     */
    public function new(?items:Array<MenuTabsItemParams>, ?node:Element) {
        super(node==null?Browser.document.createUListElement():node);
        this.node.classList.add(Style.MENU_TABS);

        this.nodeThumb = Browser.document.createDivElement();
        this.nodeThumb.classList.add(Style.THUMB);
        this.node.appendChild(this.nodeThumb);

        applyParams(items);

        evAddedToStage.on(onAddedToStage);
    }

    /**
     * Список элементов меню.  
     * Не может быть: `null`
     */
    private var items:Array<MenuTabItem> = [];

    /**
     * Выбранный элемент в меню.  
     * - Если передан: `null`, выбор снимается.
     * - Если передан уже выбранный элемент, вызов игнорируется.
     * 
     * По умолчанию: `null` *(Ничего не выбрано)*
     */
    public var value(default, set):MenuTabItem = null;
    function set_value(v:MenuTabItem):MenuTabItem {
        if (value == v)
            return v;
        if (value != null)
            value.node.classList.remove(Style.SELECTED);
        if (v != null) 
            v.node.classList.add(Style.SELECTED);
        value = v;
        updateThumb();
        return v;
    }

    /**
     * Линия подчёркивания, используемая для анимации.  
     * Не может быть: `null`
     */
    public var nodeThumb(default, null):DivElement;

    /**
     * Количество пунтков в меню.  
     * По умолчанию: `0`
     */
    public var length(get, never):Int;
    inline function get_length():Int {
        return items.length;
    }

    /**
     * Событие изменения выбранного пункта меню.  
     * - Посылается при выборе пользователем нового пунтка в меню.
     * - Не посылается при ручном изменении значения: `value`
     * 
     * Не может быть: `null`
     */
    public var evChange(default, never):Dispatcher<Void->Void> = new Dispatcher();

    /**
     * Получить элемент списка.
     * @param index Индекс элемента в списке.
     * @return Элемент списка.
     */
    inline public function at(index:Int):MenuTabItem {
        return items[index];
    }

    /**
     * Добавить новый элемент в список.  
     * - Вызов игнорируется, если передан: `null`
     * - Вызов игнорируется, если переданный элемент уже
     *   содержится в этом или любом другом списке.
     * @param item Новый элемент.
     */
    public function add(item:MenuTabItem):Void {
        if (item == null)
            return;

        // Новый элемент:
        if (item.index == -1) {
            item.index = items.length;
            items.push(item);
            item.callback = function(e) {
                if (value == item)
                    return;
                value = item;
                evChange.emit();
            }
            item.evClick.on(item.callback);
            addChild(item);
            return;
        }

        // Уже есть в каком-то списке:
        return;
    }

    /**
     * Удалить элемент из списка.
     * - Возвращается: `false`, если был передан: `null`
     * - Возвращается: `false`, если переданный элемент не
     *   содержится в этом списке.
     * @param item Удаляемый элемент.
     * @return Элемент удалён.
     */
    public function remove(item:MenuTabItem):Bool {
        if (item == null)
            return false;

        // Поиск:
        var i = items.length;
        while (i-- > 0) {
            if (items[i] == item) {
                item.index = -1;
                item.evClick.off(item.callback);
                item.callback = null;
                item.node.classList.remove(Style.SELECTED);
                items.splice(i, 1);

                // Восстанавливаем индексы справа:
                var l = items.length;
                while (i < l) {
                    items[i].index = i;
                    i++;
                }
                removeChild(item);
                return true;
            }
        }

        // Не найдено:
        return false;
    }

    /**
     * Меню было добавлено на сцену.
     * @param o Объект.
     */
    private function onAddedToStage():Void {
        updateThumb();
    }

    /**
     * Применить параметры конструктора.
     * @param params Параметры.
     */
    private function applyParams(params:Array<MenuTabsItemParams>):Void {
        if (params == null)
            return;

        var i = 0;
        var l = params.length;
        while (i < l) {
            var o = params[i++];
            if (o == null)
                continue;

            var b = new MenuTabItem();
            if (o.label != null)    b.label = o.label;
            if (o.ico != null)      b.ico = o.ico;
            if (o.disabled != null) b.disabled = o.disabled;
            if (o.userData != null) b.userData = o.userData;
            add(b);
            if (o.selected)
                value = b;
        }
    }

    /**
     * Обновить стили нижней полоски.  
     * Этот метод обновляет свойства: `width` и `left`
     * у нижней полоски, чтобы создать эффект перехода
     * по разделам меню.
     * 
     * Метод вызывается автоматически, когда:
     * - Выбирается новый элемент меню: `value=item`
     * - Меню добавляется на сцену.
     * 
     * Публичный доступ предоставлен для возможности
     * ручного вызова, когда вам необходимо обновить
     * нижнюю полоску. *(Например, при изменении `label`
     * элемента/ов меню)*
     */
    public function updateThumb():Void {
        if (value == null) {
            nodeThumb.style.left = "0px";
            nodeThumb.style.width = "0px";
        }
        else {
            var b1 = node.getBoundingClientRect();
            var b2 = value.node.getBoundingClientRect();
            nodeThumb.style.left = (b2.left-b1.left)+"px";
            nodeThumb.style.width = b2.width+"px";
        }
    }
}

/**
 * Закладка меню.  
 * В DOM представлен тегами: `<li>`
 */
class MenuTabItem extends LabelUI
{
    /**
     * Создать новый экземпляр.
     * @param label Текст на кнопке.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<li>`
     */
    public function new(?label:String, ?node:Element) {
        super(node==null?Browser.document.createLIElement():node);
        this.node.addEventListener("click", onClick);

        if (label != null)
            this.label = label;
        else
            updateDOM();
    }

    /**
     * Позиция в меню.  
     * Это индекс позиции элемента в родительском
     * списке меню. Только для чтения.
     * 
     * По умолчанию: `-1` *(Элемент не добавлен в меню)*
     */
    @:allow(dom.ui.MenuTabs)
    public var index(default, null):Int = -1;

    /**
     * Пользовательские данные.  
     * Свойство используется для хранения произвольных
     * данных. Это может быть удобно.  
     * 
     * По умолчанию: `null`
     */
    public var userData:Dynamic = null;

    /**
     * Событие клика на кнопку.  
     * - Диспетчерезируется при нажатии на кнопку пользователем.
     * - Это событие не посылается, если кнопка выключена: `Button.disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evClick(default, never):Dispatcher<MouseEvent->Void> = new Dispatcher();

    /**
     * Обработчик клика по кнопке.  
     * Задаётся родительским элементом: `MenuTabs` для
     * хранения ссылки на актуальный обработчик. Необходим
     * для корректной, внутренней работы подписки и отписки
     * на события нажатия при добавлении и удалений элементов
     * меню.
     * 
     * По умолчанию: `null`
     */
    @:allow(dom.ui.MenuTabs)
    private var callback:MouseEvent->Void = null;

    /**
     * Нативное событие клика.
     * @param e Событие.
     */
    private function onClick(e:MouseEvent):Void {
        evClick.emit(e);
    }
}

/**
 * Параметры элементов меню для контсруктора закладок.
 */
typedef MenuTabsItemParams =
{
    /**
     * Текст на кнопке.
     */
    @:optional var label:String;

    /**
     * Иконка на кнопке.
     */
    @:optional var ico:Element;

    /**
     * Кнопка меню выключена.  
     * Передайте: `true`, чтобы этот пункт меню был
     * по умолчанию выключен.
     */
    @:optional var disabled:Bool;

    /**
     * Произвольные данные для хранения.
     */
    @:optional var userData:Dynamic;

    /**
     * Элемент выбран.  
     * Передайте: `true`, чтобы этот пункт меню был
     * выбран по умолчанию.
     */
    @:optional var selected:Bool;
}