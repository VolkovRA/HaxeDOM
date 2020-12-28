package dom.ui;

import dom.enums.CSSClass;
import dom.ticker.IAnimated;
import js.Browser;
import js.lib.Error;
import js.html.LIElement;
import js.html.UListElement;

/**
 * Слайдер.  
 * В DOM представлен тегом: `<ul class="slider">`
 */
@:dce
class Slider extends UIComponent<Slider, UListElement> implements IAnimated
{
    /**
     * Создать новый экземпляр.
     * @param itemClass Класс отображаемых элементов.  
     */
    public function new(itemClass:Class<SliderItem<Dynamic,Dynamic>>) {
        super(Browser.document.createUListElement());
        this.node.classList.add(CSSClass.SLIDER);

        if (itemClass == null)
            throw new Error("Класс для отображения элементов слайдера не должен быть null");

        this.itemClass = itemClass;
    }

    /**
     * Класс отображаемых элементов.  
     * Этот класс используется для отображения элементов
     * в слайдере.
     * 
     * Не может быть: `null`
     */
    public var itemClass(default, null):Class<SliderItem<Dynamic,Dynamic>>;

    /**
     * Данные тикера.  
     * Используется внутренней реализацией тикера, вы не должны
     * изменять параметры этого объекта!
     * 
     * По умолчанию: `null`
     */
    private var ticker:Dynamic = null;

    /**
     * Обновление.  
     * Метод вызывается каждый кадр и передаёт прошедшее
     * время для возможности создания эффекта анимации.
     * @param dt Прошедшее время с последнего цикла обновления. (sec)
     * @return Закончить анимацию. Передайте `true`, чтобы
     * удалить этот объект из последующих вызовов.
     */
    public function tick(dt:Float):Bool {
        trace(dt);
        return false;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Slider]";
    }
}

/**
 * Элемент слайдера.  
 * В DOM представлен тегом: `<li class="slider_item">`
 * 
 * Используется для задания шаблона и кастомизации
 * отображаемых элементов в сладйере.  
 * Это абстрактный, базовый класс для вашей конкретной
 * реализации элементов слайдера.
 * 
 * Описание динамических типов:
 * - `T` Итоговый, реализующий класс для передачи типа в события.
 * - `D` Тип данных, ожидаемый элементом списка для удобной типизации.
 */
@:dce
class SliderItem<T:SliderItem<T,D>, D:Dynamic> extends UIComponent<T,LIElement>
{
    /**
     * Создать новый экземпляр.
     */
    public function new() {
        super(Browser.document.createLIElement());
        this.node.classList.add(CSSClass.SLIDER_ITEM);
    }

    /**
     * Отображаемые данные.  
     * Передайте объект с данными для их отображения.
     * Назначается слайдером автоматический.
     * 
     * По умолчанию: `null`
     */
    public var value(default, set):D = null;
    function set_value(value:D):D {
        this.value = value;
        return value;
    }

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[SliderItem]";
    }
}