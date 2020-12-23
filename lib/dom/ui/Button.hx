package dom.ui;

import dom.display.Component;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import js.Browser;
import js.html.AnchorElement;
import js.html.Element;
import js.html.PointerEvent;
import js.html.SpanElement;
import js.lib.Error;

/**
 * Обычная кнопка.  
 * В DOM представлена тегом: `<a class="button">`
 */
@:dce
class Button extends Component<Button, AnchorElement>
{
    /**
     * Создать новый экземпляр.
     * @param text Текст на кнопке.
     */
    public function new(?text:String) {
        super(Browser.document.createAnchorElement());

        this.node.classList.add("button");
        this.state = ButtonState.NORMAL;

        this.nodeLabel = Browser.document.createSpanElement();
        this.nodeLabel.classList.add("label");

        if (text != null)
            this.text = text;

        addListeners();
    }

    /**
     * Дочерний `<span>` узел для отображения текстовой метки.  
     * Не может быть: `null`
     */
    public var nodeLabel(default, null):SpanElement;

    /**
     * Состояние кнопки.  
     * Обновляется автоматически при взаимодействии
     * пользователя с кнопкой.
     * 
     * По умолчанию: `ButtonState.NORMAL`
     * 
     * @throws Error Передан неизвестный тип состояния кнопки.
     */
    public var state(default, set):ButtonState;
    function set_state(value:ButtonState):ButtonState {
        if (value == state)
            return value;

        if (value == ButtonState.NORMAL || value == ButtonState.OVER || value == ButtonState.DOWN) {
            state = value;
            node.setAttribute("state", value);
        }
        else {
            throw new Error("Передан неизвестный тип состояния кнопки: " + value);
        }

        state = value;
        onState.emit(this);
        return value;
    }

    /**
     * Текст на кнопке.  
     * По умолчанию: `null`
     */
    public var label(default, set):String = null;
    function set_label(value:String):String {
        if (value == label)
            return value;
        label = value;
        if (value == null)
            nodeLabel.textContent = "";
        else
            nodeLabel.textContent = value;
        updateDOM();
        return value;
    }

    /**
     * Иконка на кнопке.  
     * Вы можете указать произвольный элемент, который будет
     * добавлен в DOM дерево кнопки.
     * 
     * По умолчанию: `null`
     */
    public var ico(default, set):Element = null;
    function set_ico(value:Element):Element {
        if (value == ico)
            return value;
        ico = value;
        if (value != null)
            NativeJS.indexNode(value);
        updateDOM();
        return value;
    }

    /**
     * Событие изменения состояния кнопки.  
     * Посылается каждый раз, когда изменяется значение
     * свойства: `Button.state`
     * 
     * Не может быть `null`
     */
    public var onState(default, null):Dispatcher<Button->Void> = new Dispatcher();

    /**
     * Текст на кнопке.  
     * По умолчанию: `""`
     */
    public var text(default, set):String = "";
    function set_text(value:String):String {
        if (value == text)
            return value;

        text = value;
        node.textContent = value;
        return value;
    }

    override function set_disabled(value:Bool):Bool {
        if (disabled == value)
            return value;

        if (value)
            removeListeners();
        else
            addListeners();

        return super.set_disabled(value);
    }

    private function onPointerOver(e:PointerEvent):Void {
        //trace("onPointerOver");
        e.preventDefault();
        state = ButtonState.OVER;
    }

    private function onPointerDown(e:PointerEvent):Void {
        //trace("onPointerDown");
        e.preventDefault();
        state = ButtonState.DOWN;
    }

    private function onPointerUp(e:PointerEvent):Void {
        //trace("onPointerUp");
        e.preventDefault();
        state = ButtonState.OVER;
    }

    private function onPointerCancel(e:PointerEvent):Void {
        //trace("onPointerCancel");
        e.preventDefault();
        state = ButtonState.NORMAL;
    }

    private function onPointerOut(e:PointerEvent):Void {
        //trace("onPointerOut");
        e.preventDefault();
        state = ButtonState.NORMAL;
    }

    private function addListeners():Void {
        //trace("add listeners");
        node.addEventListener("pointerover", onPointerOver);
        node.addEventListener("pointerdown", onPointerDown);
        node.addEventListener("pointerup", onPointerUp);
        node.addEventListener("pointercancel", onPointerCancel);
        node.addEventListener("pointerout", onPointerOut);
    }

    private function removeListeners():Void {
        //trace("remove listeners");
        node.removeEventListener("pointerover", onPointerOver);
        node.removeEventListener("pointerdown", onPointerDown);
        node.removeEventListener("pointerup", onPointerUp);
        node.removeEventListener("pointercancel", onPointerCancel);
        node.removeEventListener("pointerout", onPointerOut);
    }

    /**
     * Обновить DOM для этого компонента.
     */
    private function updateDOM():Void {
        var arr:Array<Element> = [];
        if (ico != null)    arr.push(ico);
        if (label != null)  arr.push(nodeLabel);
        NativeJS.set(node, arr);
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Button]";
    }
}

/**
 * Состояние кнопки.  
 * Енум содержит перечисление всех доступных состояний
 * в которых может находиться кнопка.
 */
enum abstract ButtonState(String) to String from String
{
    /**
     * Обычное состояние. (По умолчанию)
     */
    var NORMAL = "normal";

    /**
     * Наведение указателя на кнопку.
     */
    var OVER = "over";

    /**
     * Нажатие.
     */
    var DOWN = "down";
}