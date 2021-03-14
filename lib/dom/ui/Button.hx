package dom.ui;

import dom.enums.ButtonType;
import dom.enums.Style;
import dom.ui.base.LabelUI;
import js.Browser;
import js.html.Element;
import js.html.MouseEvent;
import tools.Dispatcher;

/**
 * Обычная кнопка.  
 * В DOM представлена тегом: `<button class="button">`
 */
@:dce
class Button extends LabelUI
{
    /**
     * Создать новый экземпляр.
     * @param label Текст на кнопке.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<button>`
     */
    public function new(?label:String, ?node:Element) {
        super(node==null?Browser.document.createButtonElement():node);
        this.node.classList.add(Style.BUTTON);
        this.node.addEventListener("click", onClick);

        if (label != null)
            this.label = label;
        else
            updateDOM();
    }

    /**
     * Тип кнопки.  
     * По умолчанию: `null` *(Кнопка используется для отправки формы)*
     * @see https://developer.mozilla.org/ru/docs/Web/HTML/Element/button
     */
    public var type(default, set):ButtonType = null;
    function set_type(value:ButtonType):ButtonType {
        if (value == type)
            return value;

        type = value;
        if (value == null)
            node.removeAttribute("type");
        else
            node.setAttribute("type", value);

        return value;
    }

    /**
     * Событие клика на кнопку.  
     * Посылается при клике на кнопку 
     * - Диспетчерезируется при нажатии на кнопку пользователем.
     * - Это событие не посылается, если кнопка выключена: `Button.disabled=true`
     * 
     * Не может быть: `null`
     */
    public var evClick(default, never):Dispatcher<MouseEvent->Void> = new Dispatcher();

    /**
     * Нативное событие клика.
     * @param e Событие.
     */
    private function onClick(e:MouseEvent):Void {
        evClick.emit(e);
    }
}