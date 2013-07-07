/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.view;

import wighawag.gpu.GPUContext;
import flash.ui.Multitouch;
import flash.display.Stage;
import wighawag.ui.view.ScreenInput;
import wighawag.view.ViewLayer;
import flash.events.MouseEvent;
import wighawag.view.TexturedQuadProgram;
import wighawag.view.Camera2D;

class UILayer implements ViewLayer<GPUContext>{

    private var uiContainer : UIElementView;

    private var screenInput : ScreenInput;

    private var drawProgram : TexturedQuadProgram;

    public function new(uiContainer : UIElementView, camera : Camera2D) {

        drawProgram = new TexturedQuadProgram(camera);

        this.uiContainer = uiContainer;
        if(Multitouch.supportsTouchEvents){
            screenInput = new TouchInput(flash.Lib.current.stage);
        }else{
            screenInput = new MouseInput(flash.Lib.current.stage);
        }
    }


    public function render(context:GPUContext):Void {

        var drawList : Array<ViewPositioning> = new Array();

        uiContainer.addToDrawList(drawList, 0,0, flash.Lib.current.stage.stageWidth, flash.Lib.current.stage.stageHeight);

        screenInput.preRender();

        var i = drawList.length - 1;
        while (i >= 0){
            var viewPositioning = drawList[i];
            // TODO implement pixel perfect collision and make sure the x,y width and height are correctly taken by the view
            if (screenInput.x > viewPositioning.x && screenInput.x < viewPositioning.x + viewPositioning.width &&
                screenInput.y > viewPositioning.y && screenInput.y < viewPositioning.y + viewPositioning.height){
                screenInput.target = viewPositioning.view;
                break;
            }
            i --;
        }

        context.addProgram(drawProgram);
        drawProgram.reset();


        for (viewPositioning in drawList){
            viewPositioning.view.draw(drawProgram, viewPositioning.x, viewPositioning.y, viewPositioning.width, viewPositioning.height, screenInput);
        }
        drawProgram.upload();

        screenInput.postRender();
    }


    public function dispose() : Void{
        uiContainer = null;

        screenInput.dispose();
        screenInput = null;

        drawProgram.dispose();
        drawProgram = null;
    }

}
