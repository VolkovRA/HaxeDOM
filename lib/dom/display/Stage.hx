package dom.display;

import dom.utils.Dispatcher;
import dom.utils.ResizeObserver;
import js.html.Element;

/**
 * Корневой узел.  
 * Этот объект должен использоваться как самый верхний элемент в
 * иерархии отображения всех компонентов. Он нужен для правильной
 * работы событий: `onAddedToStage`, `onRemovedFromStage` и `onResize`
 */
@:dce
class Stage extends Container
{
    /**
     * Создать новый экземпляр.
     * @param node DOM Элемент, представляющий корень сцены.
     */
    public function new(node:Element) {
        super(node);

        this.onResize = new Dispatcher();
        this.stage = this;

        // Событие ресайзинга:
        ResizeObserver.on(node, function(element) {
            onResize.emit(this);
        });
    }

    /**
     * Это корневой узел.  
     * Используется для быстрой проверки типа в рантайме.
     */
    @:keep
    @:noCompletion
    public var isStage(default, null):Bool = true;

    /**
     * Событие ресайза сцены.  
     * Посылается при изменений размеров элемента в node, к которому прикреплён этот Stage.
     * 
     * Не может быть: `null`
     */
    public var onResize(default, null):Dispatcher<Stage->Void>;

    /**
     * Получить текстовое описание объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    override public function toString():String {
        return "[Stage]";
    }
}