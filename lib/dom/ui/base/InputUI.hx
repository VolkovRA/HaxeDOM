package dom.ui.base;

import dom.enums.Style;
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
 * Используется для инкапсулирования общего поведения всех
 * компонентов в одном месте.
 * 
 * *п.с.: Скорее всего, вам будет интересен не этот
 * класс, а один из его потомков.*
 */
@:dce
class InputUI extends LabelUI
{
    /**
     * Создать новый экземпляр.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        super(node);
    }

    /**
     * Текст ошибки ввода.  
     * Используется для отображения сообщения об ошибке,
     * например, при неверном заполнении формы.
     * 
     * Чтобы текст с ошибкой был показан, необходимо:
     * - Указать текст ошибки.
     * - Задать свойство: `wrong=true`
     * 
     * По умолчанию: `null` *(Без текста ошибки)*
     */
    public var labelError(default, set):String = null;
    function set_labelError(value:String):String {
        if (value == labelError)
            return value;

        if (value == null) {
            labelError = null;
            if (nodeError != null)
                nodeError = null;
        }
        else {
            labelError = value;
            if (nodeError == null) {
                nodeError = Browser.document.createSpanElement();
                nodeError.classList.add(Style.ERROR);
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
    public var labelRequire(default, set):String = null;
    function set_labelRequire(value:String):String {
        if (value == labelRequire)
            return value;

        if (value == null) {
            labelRequire = null;
            if (nodeRequire != null)
                nodeRequire = null;
        }
        else {
            labelRequire = value;
            if (nodeRequire == null) {
                nodeRequire = Browser.document.createSpanElement();
                nodeRequire.classList.add(Style.REQUIRE);
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

        if (value) {
            required = true;
            node.setAttribute("required", "");
        }
        else {
            required = false;
            node.removeAttribute("required");
        }
        updateDOM();
        return value;
    }

    /**
     * Некорректное содержимое.  
     * Свойство используется для отображения ошибок ввода.
     * - Если `true`, компонент помечается CSS классом: `wrong`,
     *   указываеющего на ошибки ввода. Так же показывается
     *   сообщение об ошибке: `labelError`. (Если указано)
     * - Если `false`, у компонента удаляется CSS класс: `wrong`,
     *   сообщение об ошибке ввода скрывается.
     * - Это значение каждый раз автоматически изменяется при
     *   вызове метода: `validate()`
     * 
     * По умолчанию: `false` *(Ошибок нет)*
     */
    public var wrong(default, set):Bool = false;
    function set_wrong(value:Bool):Bool {
        if (value == wrong)
            return value;

        if (value) {
            wrong = true;
            node.classList.add(Style.WRONG);
        }
        else {
            wrong = false;
            node.classList.remove(Style.WRONG);
        }
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
     * - Возвращает: `true`, если компонент заполнен верно.
     * - Возвращает: `false`, если есть какие либо ошибки ввода.
     * - Вызов этого метода автоматически переключает свойство: `wrong`
     *   Задаёт: `wrong=true`, если есть ошибки, иначе: `wrong=false`
     * @return Поле заполнено корректно.
     */
    public function validate():Bool {
        wrong = false;
        return true;
    }

    /**
     * Обновить DOM компонента.  
     * Выполняет перестроение дерева DOM этого элемента
     * интерфейса. Каждый компонент определяет собственное
     * поведение.
     */
    override public function updateDOM():Void {
        DOM.setChilds(node, [
            ico==null?                        null:ico,
            nodeLabel==null?                  null:nodeLabel,
            (nodeRequire==null || !required)? null:nodeRequire,
            (nodeError==null || !wrong)?      null:nodeError,
        ]);
    }
}