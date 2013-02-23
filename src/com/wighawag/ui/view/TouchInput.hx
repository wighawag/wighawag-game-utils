package com.wighawag.ui.view;
import nme.events.TouchEvent;
import nme.display.Stage;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;
import com.wighawag.ui.view.ScreenInput;
class TouchInput implements ScreenInput {

    public var x : Int;
    public var y : Int;
    public var state : ScreenInputState;
    public var target : UIElementView;
    private var stage : Stage;

    public function new(stage : Stage) {
        this.x = 0;
        this.y = 0;
        this.state = ScreenInputState.None;
        this.target = null;
        this.stage = stage;
        Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
        stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
    }


    public function preRender():Void {
        this.target = null;
    }

    public function postRender():Void {
        if (state == ScreenInputState.Up){
            state = ScreenInputState.None;
        }
    }

    private function onTouchBegin(event : TouchEvent) : Void{
        stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
        stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
        state = ScreenInputState.Down;
        x = Std.int(event.stageX);
        y = Std.int(event.stageY);
    }

    private function onTouchEnd(event : TouchEvent) : Void{
        stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
        stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
        state = ScreenInputState.Up;
        x = Std.int(event.stageX);
        y = Std.int(event.stageY);
    }

}
