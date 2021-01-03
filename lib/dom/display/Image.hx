package dom.display;

import dom.utils.Dispatcher;
import js.Browser;
import js.lib.Error;

/**
 * Простая картинка.  
 * В DOM представлена тегом: `<img>`
 */
@:dce
class Image extends Component
{
    /**
     * Создать новый экземпляр.
     * @param src URL Адрес графического файла.
     */
    public function new(?src:String) {
        super(Browser.document.createImageElement());

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
        untyped node.src = value;
        return value;
    }

    /**
     * Событие завершения загрузки изображения.  
     * Всегда вызывается один раз после завершения загрузки.
     * В случае ошибки передаётся объект: `js.lib.Error`
     * 
     * Не может быть: `null`
     */
    public var onLoad(get, null):Dispatcher<Image->Error->Void>;
    function get_onLoad():Dispatcher<Image->Error->Void> {
        if (onLoad == null) {
            onLoad = new Dispatcher();
            this.node.addEventListener("load", function(e) {
                onLoad.emit(this, null);
            });
            this.node.addEventListener("error", function() {
                onLoad.emit(this, new Error("Ошибка загрузки изображения: " + src));
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