package dom.enums;

/**
 * Класс стилей CSS.  
 * Этот енум содержит перечисление всех используемых классов
 * стилей библиотекой `HaxeDOM`, в одном месте.
 * 
 * Тут их можно посмотреть или изменить, если нужно.
 */
@:dce
enum abstract CSSClass(String) to String from String
{
    ///////////////////////
    //   UI КОМПОНЕНТЫ   //
    ///////////////////////

    /**
     * Кнопка UI.  
     * Используется для обозначения экземпляра: `dom.ui.Button`
     */
    var UI_BUTTON = "ui_button";

    /**
     * Базовый элемент ввода.  
     * Используется для обозначения экземпляра: `dom.ui.Input`
     */
    var UI_INPUT = "ui_input";

    /**
     * Поле ввода однострочного текста.  
     * Используется для обозначения экземпляра: `dom.ui.InputText`
     */
    var UI_INPUT_TEXT = "ui_input_text";

    /**
     * Радио-кнопка.  
     * Используется для обозначения экземпляра: `dom.ui.RadioButton`
     */
    var UI_RADIO = "ui_radio";

    /**
     * Флажок.  
     * Используется для обозначения экземпляра: `dom.ui.CheckBox`
     */
    var UI_CHECKBOX = "ui_checkbox";



    ///////////////////
    //   СОСТОЯНИЯ   //
    ///////////////////

    /**
     * Обязательный элемент.  
     * Используется для обозначения обязательного компонента
     * или поля для заполнения.
     * 
     * *п.с.: Не путать с классом описания требования: `REQUIRE`*
     */
    var REQUIRED = "required";

    /**
     * Элемент выключен.  
     * Используется для обозначения выключенного элемента,
     * например: `dom.ui.Button.disabled=true`
     */
    var DISABLED = "disabled";

    /**
     * Некорректное содержимое.  
     * Используется для обозначения элементов ввода, заполненных
     * с ошибками, например: `dom.ui.InputText`
     */
    var INCORRECT = "incorrect";



    //////////////////////
    //   ПРОСТЫЕ ТИПЫ   //
    //////////////////////

    /**
     * Текстовая метка.  
     * Используется для обозначения текста в кнопках или других
     * ui компонентах, которые могут содержать собственное
     * текстовое поле.
     */
    var LABEL = "label";

    /**
     * Ошибка.  
     * Используется для обозначения ошибки. Например, в полях
     * ввода при неудачной валидации.
     */
    var ERROR = "error";

    /**
     * Предупреждение.  
     * Используется для обозначения важной информации.
     */
    var WARN = "warn";

    /**
     * Описание обязательного заполнения.  
     * Используется для обозначения текста обязательного заполнения.
     * 
     * *п.с.: Не путать с классом состояния: `REQUIRED`*
     */
    var REQUIRE = "require";
}