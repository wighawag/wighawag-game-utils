package com.wighawag.ui.view;

import com.wighawag.gpu.GPUContext;
import nme.ui.Multitouch;
import nme.display.Stage;
import com.wighawag.ui.view.ScreenInput;
import com.wighawag.view.ViewLayer;
import nme.events.MouseEvent;
import com.wighawag.view.TexturedQuadProgram;
import com.wighawag.view.Camera2D;

class UILayer implements ViewLayer<GPUContext>{

    private var uiContainer : UIElementView;

    private var screenInput : ScreenInput;

    private var drawProgram : TexturedQuadProgram;

    public function new(uiContainer : UIElementView, camera : Camera2D) {

        drawProgram = new TexturedQuadProgram(camera);

        this.uiContainer = uiContainer;
        if(Multitouch.supportsTouchEvents){
            screenInput = new TouchInput(nme.Lib.current.stage);
        }else{
            screenInput = new MouseInput(nme.Lib.current.stage);
        }
    }


    public function render(context:GPUContext):Void {

        var drawList : Array<ViewPositioning> = new Array();

        uiContainer.addToDrawList(drawList, 0,0, nme.Lib.current.stage.stageWidth, nme.Lib.current.stage.stageHeight);

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

        screenInput.postRender();
    }


}
