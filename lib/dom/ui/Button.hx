package dom.ui;

import dom.enums.CSSClass;
import dom.utils.Dispatcher;
import js.Browser;
import js.html.ButtonElement;
import js.html.MouseEvent;

/**
 * Обычная кнопка.  
 * В DOM представлена тегом: `<button class="ui_button">`
 */
@:dce
class Button extends UIComponent<Button, ButtonElement>
{
    /**
     * Создать новый экземпляр.
     * @param label Текст на кнопке.
     */
    public function new(?label:String) {
        super(Browser.document.createButtonElement());
        this.node.classList.add(CSSClass.UI_BUTTON);
        this.node.addEventListener("click", onButtonClick);

        if (label != null)
            this.label = label;
        else
            updateDOM();
    }

    override function set_disabled(value:Bool):Bool {
        node.disabled = value;
        return super.set_disabled(value);
    }

    /**
     * Событие клика на кнопку.  
     * - Диспетчерезируется при нажатии на кнопку пользователем.
     * - Это событие не посылается, если кнопка выключена: `Button.disabled=true`
     * 
     * Не может быть: `null`
     */
    public var onClick(default, null):Dispatcher<Button->Void> = new Dispatcher();

    /**
     * Нативное событие клика.
     * @param e Событие.
     */
    private function onButtonClick(e:MouseEvent):Void {
        if (!disabled)
            onClick.emit(this);
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