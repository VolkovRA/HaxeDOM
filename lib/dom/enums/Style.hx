package dom.enums;

/**
 * Класс стилей CSS.  
 * Этот енум содержит перечисление всех используемых классов
 * стилей библиотекой `HaxeDOM`, в одном месте.
 * 
 * Тут их можно посмотреть или изменить, если нужно.
 */
@:dce
enum abstract Style(String) to String from String
{
    ///////////////////////
    //   UI КОМПОНЕНТЫ   //
    ///////////////////////

    /**
     * Кнопка UI.  
     * Используется для обозначения экземпляра: `dom.ui.Button`
     */
    var BUTTON = "button";

    /**
     * Базовый элемент ввода.  
     * Используется для обозначения экземпляра: `dom.ui.Input`
     */
    var INPUT = "input";

    /**
     * Поле ввода однострочного текста.  
     * Используется для обозначения экземпляра: `dom.ui.InputText`
     */
    var INPUT_TEXT = "input_text";

    /**
     * Поле ввода многострочного текста.  
     * Используется для обозначения экземпляра: `dom.ui.Textarea`
     */
    var TEXTAREA = "textarea";

    /**
     * Радио-кнопка.  
     * Используется для обозначения экземпляра: `dom.ui.RadioButton`
     */
    var RADIO = "radio";

    /**
     * Флажок.  
     * Используется для обозначения экземпляра: `dom.ui.CheckBox`
     */
    var CHECKBOX = "checkbox";

    /**
     * Степпер.  
     * Используется для обозначения экземпляра: `dom.ui.Stepper`
     */
    var STEPPER = "stepper";

    /**
     * Прогрессбар.
     * Используется в: `dom.ui.Progressbar`
     */
    var PROGRESSBAR = "progressbar";

    /**
     * Скроллбар.  
     * Используется в: `dom.ui.List.Scrollbar`
     */
    var SCROLLBAR = "scrollbar";

    /**
     * Скроллер.  
     * Используется в: `dom.ui.List.Scroller`
     */
    var SCROLLER = "scroller";

    /**
     * Меню с закладками.  
     * Используется в: `dom.ui.MenuTabs`
     */
    var MENU_TABS = "menu_tabs";



    ///////////////////
    //   СОСТОЯНИЯ   //
    ///////////////////

    /**
     * Активный элемент.  
     * Используется для обозначения активного элемента.
     */
    var ACTIVE = "active";

    /**
     * Выбранный элемент.  
     * Используется для обозначения выбранного элемента.
     */
    var SELECTED = "selected";

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

    /**
     * Горизонтальный.  
     * Используется для обозначения направления. Например, ползунка.
     */
    var HORIZONTAL = "hor";

    /**
     * Вертикальный.  
     * Используется для обозначения направления. Например, ползунка.
     */
    var VERTICAL = "vert";



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

    /**
     * Заполнение.  
     * Используется для полоски прогрессбара.
     */
    var FILL = "fill";

    /**
     * Кнопка инкремента.  
     * Используется в скроллбарах и степперах.
     */
    var INCREMENT = "incr";

    /**
     * Кнопка декремента.  
     * Используется в скроллбарах и степперах.
     */
    var DECREMENT = "decr";

    /**
     * Кнопка ползунка.  
     * Используется в скроллбарах и меню.
     */
    var THUMB = "thumb";

    /**
     * Содержимое.  
     * Используется в скроллере.
     */
    var CONTENT = "content";
}