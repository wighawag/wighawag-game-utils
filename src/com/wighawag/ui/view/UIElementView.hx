package com.wighawag.ui.view;

import com.wighawag.asset.renderer.NMEDrawingContext;

interface UIElementView {
    function addToDrawList(drawList : Array<ViewPositioning>, x : Int, y : Int, width : Int, height : Int) : Void;
    function draw(context : NMEDrawingContext, x : Int, y : Int, width : Int, height : Int, screenInput : ScreenInput) : Void;
    public function getMinWidth() : Int;
    public function getMinHeight() : Int;

    //TODO add preferedWidth, preferedHeight, maxWidth, maxHeight
}
