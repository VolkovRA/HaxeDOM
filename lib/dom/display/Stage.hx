package dom.display;

import dom.utils.ResizeObserver;
import js.html.Element;
import tools.Dispatcher;

/**
 * Корневой узел.  
 * Этот объект должен использоваться как самый верхний
 * элемент в иерархии отображения всех компонентов. Он
 * нужен для правильной работы событий: `evAddedToStage`
 * и `evRemovedFromStage`
 * 
 * Вы можете привязать корень сцены к уже существующему
 * DOM элементу (Например `<body>`), или создать новый.
 * 
 * В DOM по умолчанию представлен тегом: `<div>`
 */
@:dce
class Stage extends Container
{
    /**
     * Создать новый экземпляр.
     * @param node DOM Элемент, представляющий корень сцены.
     *             Если не указан, будет создан новый: `<div>`
     */
    public function new(?node:Element) {
        super(node);

        this.evResize = new Dispatcher();
        this.stage = this;

        // Событие ресайзинга:
        ResizeObserver.on(node, function(element) {
            evResize.emit(this);
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
     * Посылается при изменений размеров элемента в свойстве: `node`,
     * к которому прикреплён этот Stage.
     * 
     * Не может быть: `null`
     */
    public var evResize(default, null):Dispatcher<Stage->Void>;
}