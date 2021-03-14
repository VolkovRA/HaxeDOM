package dom.display;

import js.html.Element;

/**
 * Статический HTML контент.  
 * Полезен для вывода произвольного содержимого на
 * экран пользователя.
 * 
 * В DOM представлен тегом: `<div>`. *(По умолчанию)*
 */
@:dce
class Static extends Component
{
    /**
     * Создать новый экземпляр.
     * @param content HTML Контент.
     * @param node DOM Элемент, представляющий этот компонент.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?content:String, ?node:Element) {
        super(node);

        if (content != null)
            this.content = content;
    }

    /**
     * HTML Содержимое.  
     * Свойство позволяет работать с содержимым элемента:
     * `node.innerHTML` используя **кеширование**.
     * 
     * При передаче нового значения, оно сохраняется в этом
     * элементе и обновляет DOM, только если было передано
     * **новое** значение, отличное от ранее заданного. Это
     * позволяет не манипулировать DOM, если фактические
     * изменения отсустствуют. Некоторые браузеры (IE, Edge)
     * выполняют обновление DOM, даже если элементу
     * передаётся содержимое без изменений.
     * 
     * Особенности:
     * - Работает с нативным свойством: `innerHTML`
     * - Кеширует указанные данные в памяти этого компонента,
     *   как строку.
     * - Обновляет DOM, только если передано новое значение.
     * - Не следит за изменениями в: `node.innerHTML` извне.
     * - Значение не может быть: `null` (Приводится к пустой строке)
     * 
     * По умолчанию: `""`
     */
    public var content(default, set):String = "";
    function set_content(value:String):String {
        if (content == value)
            return value;

        if (value == null) {
            if (content == "")
                return value;

            content = "";
            node.innerHTML = "";
        }
        else {
            content = value;
            node.innerHTML = value;
        }

        return value;
    }
}