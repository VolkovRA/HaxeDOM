package dom.display;

import js.html.Element;
import dom.utils.Dispatcher;
import dom.utils.NativeJS;
import dom.utils.ResizeObserver;

/**
 * Корневой узел.  
 * Этот объект должен использоваться как самый верхний элемент в
 * иерархии отображения всех компонентов. Он нужен для правильной
 * работы событий: `onAddedToStage`, `onRemovedFromStage` и `onResize`.
 */
class Stage<E:Element> extends Container<Stage<E>, E>
{
    /**
     * Создать корневой узел отображения.
     * @param node HTML Элемент, представляющий корень сцены.
     */
    public function new(node:E) {
        super(node);

        stage = this;

        // Событие ресайзинга:
        if (NativeJS.isResizeObserverSupported()) {
            var observer = new ResizeObserver(function(entries, observer){
                onResize.emit(this);
            });
            observer.observe(node);
        }
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
     * Не может быть `null`
     */
    public var onResize(default, null):Dispatcher<Stage<Dynamic>->Void> = new Dispatcher();

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