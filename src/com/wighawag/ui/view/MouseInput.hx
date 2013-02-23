package com.wighawag.ui.view;
import nme.events.MouseEvent;
import nme.display.Stage;
import com.wighawag.ui.view.ScreenInput;
class MouseInput implements ScreenInput{

    public var x : Int;
    public var y : Int;
    public var state : ScreenInputState;
    public var target : UIElementView;
    private var stage : Stage;

    public function new(stage : Stage) {
        this.x = 0;
        this.y = 0;
        this.state = ScreenInputState.Hover;
        this.target = null;
        this.stage = stage;
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    public function preRender():Void {
        x = Std.int(stage.mouseX);
        y = Std.int(stage.mouseY);
        target = null;
    }

    public function postRender():Void {
        if (state == ScreenInputState.Up){
            state = ScreenInputState.Hover;
        }
    }


    private function onMouseDown(event : MouseEvent) : Void{
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        state = ScreenInputState.Down;
    }

    private function onMouseUp(event : MouseEvent) : Void{
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        state = ScreenInputState.Up;
    }
}
