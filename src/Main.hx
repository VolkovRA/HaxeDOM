package;

import dom.control.DragAndDrop;
import dom.enums.Orientation;
import dom.display.Component;
import dom.display.Container;
import dom.display.Static;
import dom.display.Stage;
import dom.theme.Theme;
import dom.ui.Button;
import dom.ui.CheckBox;
import dom.ui.InputText;
import dom.ui.Progressbar;
import dom.ui.RadioButton;
import dom.ui.Scrollbar;
import dom.ui.Scroller;
import dom.ui.Stepper;
import js.Browser;

class Main
{
    static public function main() {
        Theme.current = new MyTheme();

        var stage = new Stage(Browser.document.body);

        // Статика:
        var st = new Static("Привет <b>guys</b>", Browser.document.createParagraphElement());
        stage.addChild(st);

        // Кнопка:
        var bt = new Button("Привет");
        stage.addChild(bt);

        // Ввод текста:
        var inputText = new InputText();
        inputText.name = "Ly2";
        inputText.label = "Wat?";
        inputText.labelError = "Error msg";
        inputText.labelRequire = "Ну надо";
        inputText.placeholder = "Wy not?";
        inputText.incorrect = true;
        inputText.required = true;
        stage.addChild(inputText);

        // Радиокнопки:
        var radio1 = new RadioButton("");
        var radio2 = new RadioButton("Радио-кнопка 2");
        radio1.group = "1";
        radio2.group = "1";
        stage.addChild(radio1);
        stage.addChild(radio2);

        // Чекбоксы:
        var chkbox1 = new CheckBox("Флажок 1");
        var chkbox2 = new CheckBox("Флажок 2");
        var chkbox3 = new CheckBox("Флажок 3");
        chkbox3.value = true;
        chkbox2.disabled = true;
        stage.addChild(chkbox1);
        stage.addChild(chkbox2);
        stage.addChild(chkbox3);

        // Степпер:
        var stp = new Stepper();
        stp.value = 5;
        stp.step = 2.3;
        stp.max = 100;
        stp.min = -1;
        stage.addChild(stp);

        // Прогрессбар:
        var pr = new Progressbar();
        pr.value = Math.random() * 100;
        stage.addChild(pr);

        // Скроллбар - горизонтальный:
        var sch = new Scrollbar();
        sch.orient = Orientation.HORIZONTAL;
        sch.part = 1;
        sch.min = -1;
        sch.max = 3;
        sch.value = Math.random();
        //sch.onChange.on(function(sc){ trace(sc.value); });
        stage.addChild(sch);

        // Скроллбар - вертикальный:
        var scv = new Scrollbar();
        scv.orient = Orientation.VERTICAL;
        scv.part = Math.random() + 1;
        scv.min = -2;
        scv.max = 5;
        scv.value = Math.random();
        //scv.disabled = true;
        //scv.onChange.on(function(sc){ trace(sc.value); });
        stage.addChild(scv);

        // Скроллер:
        var sc = new Scroller();
        sc.velocity.x = -20;
        sc.anchorsX.add(90);
        sc.anchorsX.add(90*2);
        sc.overflowY = "scroll";
        stage.addChild(sc);
        addBoxex(sc.content, 30);

        // Тесты:
        // TestAnchorRuler.start();

        // Тест драгалки:
        var drg = new DragAndDrop(pr.node);
        drg.minY = 300;
        drg.maxX = 300;
        drg.outTop = 100;
        drg.outRight = 100;
    }

    static private function addBoxex(container:Container, num:Int):Void {
        while (num-- > 0) {
            var child = new Component(Browser.document.createDivElement());
            child.node.style.display = "inline-block";
            child.node.style.width = 290 + "px";
            child.node.style.height = 290 + "px";
            child.node.style.backgroundColor = getRndColor();
            container.addChild(child);
        }
    }

    static private function addContent(container:Container, num:Int):Void {
        while (num-- > 0) {
            var child = new Component(Browser.document.createDivElement());
            child.node.style.position = "absolute";
            child.node.style.left = (Math.random() * 2000) + "px";
            child.node.style.top = (Math.random() * 300) + "px";
            child.node.style.width = (Math.random() * 50 + 10) + "px";
            child.node.style.height = child.node.style.width;
            child.node.style.backgroundColor = getRndColor();
            child.node.style.touchAction = "none";
            container.addChild(child);
        }
    }

    static private function getRndColor():String {
        var r:Dynamic = Math.round(Math.random() * 0xFF);
        var g:Dynamic = Math.round(Math.random() * 0xFF);
        var b:Dynamic = Math.round(Math.random() * 0xFF);
        var c:Dynamic = "#";
        if (r < 0x10) c = c + "0" + r.toString(16) else c = c + r.toString(16);
        if (g < 0x10) c = c + "0" + g.toString(16) else c = c + g.toString(16);
        if (b < 0x10) c = c + "0" + b.toString(16) else c = c + b.toString(16);
        return c;
    }
}