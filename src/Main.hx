package;

import dom.display.Stage;
import dom.display.Component;
import dom.display.Container;
import js.Browser;

class Main
{   
    static public function main() {
        testAddChildAt();
    }

    static public function testAddChildAt():Void {
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
        
        stage.onResize.on(function(stage){
            
        });
    }
}