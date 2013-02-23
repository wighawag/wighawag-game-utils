package com.wighawag.ui.view;
interface LayoutAlgorithm<LayoutSpec,LayoutParameterSpec> {
    public function setParameters(parameters : LayoutParameterSpec) : Void;
    public function compute(drawList : Array<ViewPositioning>, layoutChildren : Array<LayoutChild<LayoutSpec>>, x : Int, y : Int, width : Int, height : Int):Void;
    public function getMinWidth(layoutChildren : Array<LayoutChild<LayoutSpec>>) : Int;
    public function getMinHeight(layoutChildren : Array<LayoutChild<LayoutSpec>>) : Int;

    //TODO add preferedWidth, preferedHeight, maxWidth, maxHeight

}
