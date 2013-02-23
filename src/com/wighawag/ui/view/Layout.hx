package com.wighawag.ui.view;

import com.wighawag.asset.renderer.NMEDrawingContext;

class Layout<LayoutSpec, LayoutParameterSpec> {
    private var layoutChildren : Array<LayoutChild<LayoutSpec>>;
    private var layoutAlgorithm : LayoutAlgorithm<LayoutSpec, LayoutParameterSpec>;

    public function new(layoutChildren : Array<LayoutChild<LayoutSpec>>, layoutAlgorithm : LayoutAlgorithm<LayoutSpec, LayoutParameterSpec>) {
        this.layoutChildren = layoutChildren;
        this.layoutAlgorithm = layoutAlgorithm;
    }

    public function compute(drawList : Array<ViewPositioning>, x : Int, y : Int, width : Int, height : Int) : Void{
        layoutAlgorithm.compute(drawList,layoutChildren, x,y,width,height);
    }

    public function getMinWidth():Int {
        return layoutAlgorithm.getMinWidth(layoutChildren);
    }

    public function getMinHeight():Int {
        return layoutAlgorithm.getMinHeight(layoutChildren);
    }

    //TODO add preferedWidth, preferedHeight, maxWidth, maxHeight


}
