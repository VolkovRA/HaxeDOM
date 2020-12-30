package;

import dom.ui.Progressbar;
import dom.ui.Slider;
import dom.display.Static;
import dom.ui.Stepper;
import dom.ui.CheckBox;
import dom.ui.RadioButton;
import dom.display.Stage;
import dom.display.Label;
import dom.theme.Theme;
import dom.ui.Button;
import dom.ui.InputText;
import dom.utils.NativeJS;
import js.Browser;

class Main
{   
    static public function main() {
        Theme.current = new MyTheme();

        var stage = new Stage(Browser.document.body);
        var img = Browser.document.createImageElement();
        img.src = "http://www.flasher.ru/forum/images/russian/flasher_logo_2013.gif";

        var lb = new Label("Label");
        var bt = new Button("Привет");
        var inputText = new InputText();
        var radio1 = new RadioButton("");
        var radio2 = new RadioButton("Радио-кнопка 2");
        var chkbox1 = new CheckBox("Флажок 1");
        var chkbox2 = new CheckBox("Флажок 2");
        var chkbox3 = new CheckBox("Флажок 3");
        var stp = new Stepper();
        var st = new Static("Привет <b>guys</b>", Browser.document.createParagraphElement());
        var pr = new Progressbar();
        stage.addChild(st);
        stage.addChild(lb);
        stage.addChild(bt);
        stage.addChild(inputText);
        stage.addChild(radio1);
        stage.addChild(radio2);
        stage.addChild(chkbox1);
        stage.addChild(chkbox2);
        stage.addChild(chkbox3);
        stage.addChild(stp);
        stage.addChild(pr);
        inputText.name = "Ly2";
        inputText.label = "Wat?";
        inputText.labelError = "Error msg";
        inputText.labelRequire = "Ну надо";
        inputText.placeholder = "Wy not?";
        inputText.incorrect = true;
        inputText.required = true;
        radio1.group = "1";
        radio2.group = "1";
        bt.ico = img;
        chkbox3.value = true;
        chkbox2.disabled = true;
        stp.value = 5;
        stp.step = 2.3;
        stp.max = 100;
        stp.min = -1;
        //stp.disabled = true;

        var slider = new Slider(SliderItem);
        stage.addChild(slider);

        bt.onClick.on(function(bt) {
            trace(stp.min, stp.max, stp.step);
            trace(stp.value);
        });
    }
}