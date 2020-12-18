# Haxe DOM API фреймворк

Описание
------------------------------

Это небольшой Haxe [DOM API](https://developer.mozilla.org/ru/docs/DOM/DOM_Reference) фреймворк для добавления дополнительных возможностей при работе с стандартным DOM API.  
Он добавляет:
- События добавления и удаления элемента с html страницы. Это полезно, когда вам нужно знать, отображается элемент или нет. (Добавлен в DOM) Это реализация событий: `onAddedToStage` и `onRemovedFromStage` (Возможно, вам это знакомо)
- События добавления элемента в контейнер: `onAdded` и `onRemoved`
- Событие ресайза: `onResize` Используется реализация без циклов и опросов DOM, на основе [ResizeObserver](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver).
- Возможность управления: `x`, `y`, `width` и `height` свойствами обычных DOM элементов, через чуть более удобный интерфейс. Чтоб не писать каждый раз `px` или `em` и не парсить стили. (Опционально, по желанию.)
- Использовать чуть более высокоуровневое API для создания приложения, но не более. (Сцены, дисплей-листы)
- Простые UI компоненты на основе DOM. Библиотека реализует только функциональность UI компонентов, все CSS стили вы должны добавить самостоятельно. Это позволяет кастомизировать элементы интерфейса совершенно любым образом.

Больше этот фреймворк ничего не делает. Не используемый код выпиливается из JS. (Haxe dce)

Как использовать
------------------------------
```
var stage = new Stage(Browser.document.body);
var child1 = new Container(Browser.document.createDivElement());
var child2 = new Component(Browser.document.createSpanElement());
var child3 = new Component(Browser.document.createButtonElement());

child1.node.innerText = "1";
child2.node.innerText = "2";
child3.node.innerText = "3";

stage.addChild(child1);
stage.addChild(child2);
stage.addChild(child3);
stage.addChildAt(child1, 1);
stage.removeChild(child1);

trace(child1);
trace(child2);
```

Добавление библиотеки
------------------------------

1. Установите haxelib себе на локальную машину, чтобы вы могли использовать библиотеки Haxe.
2. Установите dom себе на локальную машину, глобально, используя cmd:
```
haxelib git dom https://github.com/VolkovRA/HaxeDOM master
```
Синтаксис команды:
```
haxelib git [project-name] [git-clone-path] [branch]
haxelib git minject https://github.com/massiveinteractive/minject.git         # Use HTTP git path.
haxelib git minject git@github.com:massiveinteractive/minject.git             # Use SSH git path.
haxelib git minject git@github.com:massiveinteractive/minject.git v2          # Checkout branch or tag `v2`
```
3. Добавьте библиотеку dom в ваш Haxe проект.

Дополнительная информация:
 * [Документация Haxelib](https://lib.haxe.org/documentation/using-haxelib/ "Using Haxelib")
 * [Документация компилятора Haxe](https://haxe.org/manual/compiler-usage-hxml.html "Configure compile.hxml")