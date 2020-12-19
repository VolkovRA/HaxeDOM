package dom.theme;

import dom.display.Component;
import haxe.DynamicAccess;

/**
 * Тема оформления.  
 * Используется для добавления дополнительной, произвольной
 * кастомизации любым компонентам библиотеки. С помощью этого
 * класса вы можете расширить DOM содержимое любого компонента
 * или добавить им произвольную функциональность.
 * 
 * С собственной темы оформления вы можете автоматически
 * кастамизировать все новые, создаваемые компоненты, ui
 * элементы и т.д., чтобы не настраивать их каждый раз в месте
 * использования.
 * 
 * Этот класс используется как абстрактный, базовый класс для
 * расширения его вашей, конкретной темой. 
 * 
 * Как это работает:
 * 1. Вы создаёте свой экземпляр темы и описываете в нём, как
 *    именно должен быть кастомизирован тот или иной компонент.
 *    Кастомизация может включать любые дополнительные изменения:
 *    функциональность, дополнительные DOM, CSS стили и т.п.
 * 2. Каждый новый компонент при создании будет автоматически
 *    кастамизирован, как только ему будет указано свойство:
 *    `Component.type`
 */
@:dce
class Theme
{
    /**
     * Создать новый экземпляр темы.
     */
    public function new() {
    }

    /**
     * Текущая тема оформления.  
     * Используется компонентами по умолчанию.
     * 
     * По умолчанию: `null` *(Дополнительное оформление не используется)*
     */
    static public var current:Theme = null;

    /**
     * Список зарегистрированных декораторов.  
     * Не может быть: `null`
     */
    private var map:DynamicAccess<Decorate> = {};

    /**
     * Применить оформление к компоненту.  
     * - Этот метод автоматически вызывается для всех новых компонентов,
     *   если задана тема оформления по умолчанию в: `Theme.current`
     * - Вызов игнорируется, если передан: `null`
     * - Оформление не применяется, если для переданного типа компонента
     *   не зарегистрирована кастомизация методом: `Theme.add`
     * @param component Оформляемый компонент.
     */
    public function apply(component:Component<Dynamic,Dynamic>):Void {
        if (component == null)      return;
        if (component.type == null) return;

        var d = map[component.type];
        if (d == null)
            return;

        d.decorator(component);
    }

    /**
     * Удалить оформление компонента.  
     * Полезно для очистки дополнительного оформления, добавленного с
     * помощью метода: `apply()`. Например, для переключения оформления
     * компонента на другое.
     * @param component 
     */
    public function clean(component:Component<Dynamic,Dynamic>):Void {
        if (component == null)      return;
        if (component.type == null) return;

        var d = map[component.type];
        if (d == null)
            return;

        d.clean(component);
    }

    /**
     * Добавить новый декоратор для указанного типа объекта.  
     * @param type Тип объекта. *(См.: `Component.type`)*
     * @param decorator Функция - декоратор для добавления дополнительного
     *                  оформления или функционала.
     * @param clean Функция очистки добавленного функционала или оформления.
     */
    public function add(type:String, decorator:Dynamic->Void, ?clean:Dynamic->Void):Void {
        if (type == null)       return;
        if (decorator == null)  return;

        map[type] = { decorator:decorator, clean:clean==null?null:clean } ;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String {
        return "[Theme]";
    }
}

/**
 * Параметры декорации.
 */
@:noCompletion
typedef Decorate =
{
    /**
     * Функция декоратора.  
     * Не может быть: `null`
     */
    var decorator:Dynamic->Void;

    /**
     * Функция очистки.  
     * Может быть: `null`
     */
    var clean:Dynamic->Void;
}