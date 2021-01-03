package dom.ui;

import dom.enums.CSSClass;
import dom.utils.Dispatcher;
import js.Browser;
import js.html.MouseEvent;

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
        this.node.addEventListener("click", onButtonClick);
        this.onClick = new Dispatcher();

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
    public var onClick(default, null):Dispatcher<Button->Void>;

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