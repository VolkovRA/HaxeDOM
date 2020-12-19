package dom.enums;

/**
 * Единицы измерения CSS.  
 * Перечисление содержит доступные единицы измерения в CSS для
 * управления стилями.
 */
@:dce
enum abstract Units(String) to String from String
{
    /**
     * Пиксели.  
     * Базовая, абсолютная и окончательная единица измерения.
     */
    var PX = "px";

    /**
     * Процент от шрифта.  
     * Значение относительно **текущего** шрифта, где: `1em` равен
     * 100% размера шрифта в данном блоке.
     */
    var EM = "em";

    /**
     * Проценты.  
     * От размера родителя или текущего контекста.
     */
    var PC = "%";

    /**
     * Относительно шрифта в корне.  
     * Значение расчитывается от размера шрифта в корневом теге: `<html>`
     */
    var REM = "rem";
}