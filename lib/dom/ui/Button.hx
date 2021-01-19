package dom.ui;

import dom.enums.CSSClass;
import js.Browser;
import js.html.MouseEvent;
import tools.Dispatcher;

/**
 * Обычная кнопка.  
 * В DOM представлена тегом: `<button class="button">`
 */
@:dce
class Button extends UIComponent
{
    /**
     * Создать новый экземпляр.
     * @param label Текст на кнопке.
     */
    public function new(?label:String) {
        super(Browser.document.createButtonElement());
        this.node.classList.add(CSSClass.BUTTON);
        this.node.addEventListener("click", onClick);

        if (label != null)
            this.label = label;
        else
            updateDOM();
    }

    /**
     * Событие клика на кнопку.  
     * - Диспетчерезируется при нажатии на кнопку пользователем.
     * - Это событие не посылается, если кнопка выключена: `Button.disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evClick(default, never):Dispatcher<Button->Void> = new Dispatcher();

    /**
     * Нативное событие клика.
     * @param e Событие.
     */
    private function onClick(e:MouseEvent):Void {
        if (!disabled)
            evClick.emit(this);
    }
}