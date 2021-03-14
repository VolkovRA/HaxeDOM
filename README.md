# Haxe DOM API фреймворк

Зачем это надо
------------------------------

Этот репозиторий содержит небольшой фреймворк для разработки клиентской части динамических web приложений. Он расширяет стандартный DOM API, добавляя новые инструменты, такие как:
- Собственное дерево отображения (не виртуальное), для реализации событий добавления объекта на сцену (В DOM). Это очень похоже на события: `onAddedToStage` и `onRemovedFromStage` из других сред. (Возможно, вы о них слышали)
- Готовые UI компоненты.
- Большое количество вспомогательных утилит: для перетаскивания, определения точек соприкосновения, определения изменения размеров элемента и т.п. (Эти утилиты используются собственными классами фреймворка)
- Кроссплатформенный код, который заботится за вас об всех нюансах поддержки в различных средах.
- Простой и лёгкий фреймворк без багов и лишнего геммороя.

При создании этой библиотеки я старался сделать её как можно более простой и стилизуемой. Поэтому, CSS свойства назначаются DOM элементам по минимуму (только управляемые скриптом свойства элементов, такие как: позиция, скалирование и т.д.). Всю кастомизацию вы должны производить с помощью CSS стилей самостоятельно.  
Неиспользуемый код удаляется из проекта с помощью Haxe DCE.

Больше этот фреймворк ничего не делает!

Как использовать
------------------------------
```
var stage = new Stage(Browser.document.body);
var child1 = new Container();
var child2 = new Component(Browser.document.createSpanElement());
var child3 = new Component(Browser.document.createDivElement());

child1.node.textContent = "1";
child2.node.textContent = "2";
child3.node.textContent = "3";

stage.addChild(child1);
stage.addChild(child2);
stage.addChild(child3);
stage.addChildAt(child1, 1);
stage.removeChild(child1);

trace(child1);
trace(child2);
```

Добавление фреймворка
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