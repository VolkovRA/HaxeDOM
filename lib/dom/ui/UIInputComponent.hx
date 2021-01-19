package dom.ui;

import dom.enums.CSSClass;
import dom.utils.DOM;
import js.Browser;
import js.html.Element;
import js.html.SpanElement;

/**
 * Компонент пользовательского интерфейса для ввода.  
 * Этот класс абстрагирует свойства и методы гуи
 * элементов, которые могут получать ввод данных от
 * пользователя. Он добавляет некоторые общие,
 * специфичные свойства и методы.
 * 
 * *п.с.: Скорее всего, вам будет интересен не этот
 * класс, а один из его потомков.*
 */
@:dce
class UIInputComponent extends UIComponent
{
    /**
     * Создать новый экземпляр.
     * @param node Используемый DOM узел для этого экземпляра.
     */
    public function new(node:Element) {
        super(node);
    }

    /**
     * Текст ошибки.  
     * Используется для отображения сообщения об ошибке,
     * например, при неверном заполнении формы.
     * 
     * Чтобы текст с ошибкой был показан, необходимо:
     * - Указать текст ошибки.
     * - Задать свойство: `incorrect=true`
     * 
     * По умолчанию: `null` *(Без текста ошибки)*
     */
    public var labelError(get, set):String;
    function get_labelError():String {
        return nodeError==null?null:nodeError.textContent;
    }
    function set_labelError(value:String):String {
        if (value == null) {
            if (nodeError != null)
                nodeError = null;
        }
        else {
            if (nodeError == null) {
                nodeError = Browser.document.createSpanElement();
                nodeError.classList.add(CSSClass.ERROR);
            }
            nodeError.textContent = value;
        }
        updateDOM();
        return value;
    }

    /**
     * Текст обязательного требования.  
     * Используется для показа пользователю текста с сообщением
     * об обязательном требовании для этого компонента.
     * 
     * Чтобы текст с требованием был показан, необходимо:
     * - Указать текст требования.
     * - Задать свойство: `required=true`
     * 
     * По умолчанию: `null` *(Без текста требования)*
     */
    public var labelRequire(get, set):String;
    function get_labelRequire():String {
        return nodeRequire==null?null:nodeRequire.textContent;
    }
    function set_labelRequire(value:String):String {
        if (value == null) {
            if (nodeRequire != null)
                nodeRequire = null;
        }
        else {
            if (nodeRequire == null) {
                nodeRequire = Browser.document.createSpanElement();
                nodeRequire.classList.add(CSSClass.REQUIRE);
            }
            nodeRequire.textContent = value;
        }
        updateDOM();
        return value;
    }

    /**
     * Обязательный компонент.  
     * Свойство используется для пометки обязательного требования
     * для этого компонента. Например, для полей ввода текста.
     * 
     * По умолчанию: `false` *(Не обязательно)*
     */
    public var required(default, set):Bool = false;
    function set_required(value:Bool):Bool {
        if (value == required)
            return value;
        required = value;
        if (value)
            node.classList.add(CSSClass.REQUIRED);
        else
            node.classList.remove(CSSClass.REQUIRED);
        updateDOM();
        return value;
    }

    /**
     * Некорректное заполнение.  
     * Свойство используется для отображения ошибок.
     * - Если `true`, корневой DOM элемент помечается классом:
     *   `incorrect`. Так же показывается сообщение об ошибке,
     *   если задано свойство: `labelError`
     * - Если `false`, класс с ошибкой удаляется вместе с
     *   сообщением об ошибки.
     * - Это значение каждый раз автоматически изменяется при
     *   вызове метода: `validate()`
     * 
     * По умолчанию: `false` *(Всё хорошо)*
     */
    public var incorrect(default, set):Bool = false;
    function set_incorrect(value:Bool):Bool {
        if (value == incorrect)
            return value;
        incorrect = value;
        if (value)
            node.classList.add(CSSClass.INCORRECT);
        else
            node.classList.remove(CSSClass.INCORRECT);
        updateDOM();
        return value;
    }

    /**
     * Дочерний узел для отображения текстовой метки с текстом
     * обязательного условия: `<span>`  
     * Создаётся и удаляется автоматически, в зависимости от
     * наличия указанного значения в свойстве: `labelRequire`
     * 
     * По умолчанию: `null`
     */
    public var nodeRequire(default, null):SpanElement = null;

    /**
     * Дочерний узел для отображения текстовой метки с текстом
     * ошибки: `<span>`  
     * Создаётся или удаляется автоматически, в зависимости от
     * наличия указанного значения в свойстве: `labelError`
     * 
     * По умолчанию: `null`
     */
    public var nodeError(default, null):SpanElement = null;

    /**
     * Провести валидацию компонента.  
     * - Возвращает: `true`, если с компонентом всё хорошо. *(Заполнен верно)*
     * - Возвращает: `false`, если есть какие либо ошибки.
     * - Вызов этого метода автоматически переключает свойство: `incorrect`
     *   Задаёт: `incorrect=true`, если есть ошибки, иначе: `incorrect=false`
     * @return Поле заполнено корректно.
     */
    public function validate():Bool {
        incorrect = false;
        return true;
    }

    /**
     * Обновить DOM этого компонента.
     */
    override private function updateDOM():Void {
        var arr:Array<Element> = [];
        if (ico != null)                        arr.push(ico);
        if (nodeLabel != null)                  arr.push(nodeLabel);
        if (required && nodeRequire != null)    arr.push(nodeRequire);
        if (incorrect && nodeError != null)     arr.push(nodeError);
        DOM.set(node, arr);
    }
}