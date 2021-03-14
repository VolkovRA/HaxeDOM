package dom.display;

import dom.utils.ResizeObserver;
import js.html.Element;
import tools.Dispatcher;

/**
 * Корневой узел.  
 * Этот объект должен использоваться как самый верхний
 * элемент в иерархии отображения всех компонентов. Он
 * нужен для правильной работы событий: `evAddedToStage`
 * и `evRemovedFromStage`.
 * 
 * Вы можете привязать корень сцены к уже существующему
 * DOM элементу, (Например: `<body>`) или создать новый.
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

        this.stage = this;
        this.isStage = true;

        // Подключение прослушки ресайза:
        ResizeObserver.on(node, function(element) {
            evResize.emit();
        });
    }

    /**
     * Событие ресайза сцены.  
     * Посылается при изменений размеров элемента в свойстве: `node`,
     * к которому прикреплён этот Stage.
     * 
     * Не может быть: `null`
     */
    public var evResize(default, never):Dispatcher<Void->Void> = new Dispatcher();
}