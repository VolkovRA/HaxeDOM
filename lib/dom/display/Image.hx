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

        node.addEventListener("load", onLoad);
        node.addEventListener("error", onError);
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
    public var evLoad(default, never):Dispatcher<Image->Error->Void> = new Dispatcher();

    /**
     * Картинка загружена.
     */
    private function onLoad():Void {
        evLoad.emit(this, null);
    }

    /**
     * Ошибка загрузки изображения.
     */
    private function onError():Void {
        evLoad.emit(this, new Error("Ошибка загрузки изображения: " + src));
    }
}