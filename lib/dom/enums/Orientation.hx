package dom.enums;

/**
 * Ориентация.  
 * Перечисление содержит типы ориентаций, используемых в
 * некоторых UI компонентах, например: `dom.ui.Scrollbar`
 */
@:dce
enum abstract Orientation(String) to String from String
{
    /**
     * Горизонтальная ориентация.
     */
    var HORIZONTAL = "h";

    /**
     * Вертикальная ориентация.
     */
    var VERTICAL = "v";
}