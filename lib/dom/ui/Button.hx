package dom.ui;

import dom.display.Container;
import dom.utils.Dispatcher;
import js.Browser;
import js.html.AnchorElement;
import js.html.PointerEvent;
import js.lib.Error;

/**
 * Кнопка.  
 * В DOM представлена тегом: `<a>`
 */
@:dce
class Button extends Container<Button, AnchorElement>
{
    /**
     * Создать новый экземпляр.
     * @param text Текст на кнопке.
     */
    public function new(?text:String) {
        super(Browser.document.createAnchorElement());

        this.node.classList.add("button");
        this.state = ButtonState.NORMAL;

        if (text != null)
            this.text = text;

        addListeners();
    }

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
        node.innerText = value;
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