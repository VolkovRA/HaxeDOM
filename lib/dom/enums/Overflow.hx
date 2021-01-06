package dom.enums;

/**
 * Режим отображения скроллбаров.
 */
@:dce
enum abstract Overflow(String) to String from String
{
    /**
     * Полосы прокрутки добавляются только при необходимости.  
     * Используется по умолчанию.
     */
    var AUTO = "auto";

    /**
     * Полосы прокрутки никогда не отображаются.
     */
    var HIDDEN = "hidden";

    /**
     * Полосы прокрутки отображаются всегда.
     */
    var SCROLL = "scroll";
}