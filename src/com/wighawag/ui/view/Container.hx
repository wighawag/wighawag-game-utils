package com.wighawag.ui.view;

import com.wighawag.ui.view.ScreenInput;
import com.wighawag.asset.renderer.NMEDrawingContext;

typedef BasicStyle = {assetId : String, font : String};

/**
* Container is a special holder element that contain a layout and is able to draw itslef with basic style
**/
class Container<LayoutSpec, LayoutParameterSpec> implements UIElementView{

    private var layout : Layout<LayoutSpec, LayoutParameterSpec>;
    private var style : BasicStyle;
    private var uiAssetProvider : BasicUIAssetProvider;

    public function new(uiAssetProvider : BasicUIAssetProvider, style : BasicStyle, layout : Layout<LayoutSpec, LayoutParameterSpec>) {
        this.layout = layout;
        this.style = style;
        this.uiAssetProvider = uiAssetProvider;
    }

    public function addToDrawList(drawList:Array<ViewPositioning>, x : Int, y : Int, width : Int, height : Int):Void {
        if(style != null && style.assetId != null){
            drawList.push(new ViewPositioning(this, x, y, width, height));
        }
        layout.compute(drawList, x, y, width, height);
    }


    public function processScreenInput(screenInput : ScreenInput, x:Int, y:Int, width:Int, height:Int):Void{
    }

    public function draw(context:NMEDrawingContext, x:Int, y:Int, width:Int, height:Int, screenInput : ScreenInput):Void {

        if(style.assetId != null){
            // TODO use style to draw itself
        }
    }

    public function getMinWidth():Int {
        return layout.getMinWidth();
    }

    public function getMinHeight():Int {
        return layout.getMinHeight();
    }

}
