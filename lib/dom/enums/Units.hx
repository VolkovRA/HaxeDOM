package dom.enums;

/**
 * Тип ресурса.  
 * Содержит константы для каждого класса подключаемого ресурса.
 * Удобно для быстрого определения **типа** ресурса. (Класса)
 */
enum abstract ResourceType(String) to String from String
{
    /**
     * Шрифт.
     */
    var PX = "px";

}