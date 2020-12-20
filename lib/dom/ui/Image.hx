package dom.ui;

import dom.display.Component;
import dom.utils.Dispatcher;
import js.Browser;
import js.lib.Error;
import js.html.ImageElement;

/**
 * Картинка.  
 * В DOM представлена тегом: `<img>`
 */
@:dce
class Image extends Component<Image, ImageElement>
{
    /**
     * Создать обычное, текстовое поле.
     * @param src URL Адрес графического файла.
     */
    public function new(?src:String) {
        super(Browser.document.createImageElement());
        this.node.classList.add("image");

        if (src != null)
            this.src = src;
    }

    /**
     * URL Адрес графического файла.  
     * По умолчанию: `null`
     */
    public var src(default, set):String = null;
    function set_src(value:String):String {
        if (value == src)
            return value;

        src = value;
        node.src = value;
        return value;
    }

    /**
     * Событие завершения загрузки изображения.  
     * Всегда вызывается один раз после завершения загрузки.
     * В случае ошибки передаётся объект: `js.lib.Error`
     * 
     * Не может быть: `null`
     */
    public var onLoad(get, null):Dispatcher<Error->Void>;
    @:noCompletion
    function get_onLoad():Dispatcher<Error->Void> {
        if (onLoad == null) {
            onLoad = new Dispatcher();
            this.node.addEventListener("load", function(e) {
                onLoad.emit(null);
            });
            this.node.addEventListener("error", function() {
                onLoad.emit(new Error("Ошибка загрузки изображения: " + src));
            });
        }
        return onLoad;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Image]";
    }
}