package com.wighawag.ui.layout;

import com.wighawag.ui.view.ViewPositioning;
import com.wighawag.ui.view.LayoutAlgorithm;
import com.wighawag.ui.view.LayoutChild;
import com.wighawag.ui.view.Layout;

typedef VerticalLayoutSpec = {};
typedef VerticalLayoutParams = {padding : Int};

class VerticalLayout  implements LayoutAlgorithm<VerticalLayoutSpec, VerticalLayoutParams>{

    private var padding : Int;

    public function new(){

    }

    public function setParameters(parameters : VerticalLayoutParams) : Void{
        padding =  parameters.padding;
    }

    public function compute(drawList : Array<ViewPositioning>, layoutChildren:Array<LayoutChild<VerticalLayoutSpec>>, x : Int, y : Int, width : Int, height : Int) : Void{
        var currentY : Int = Std.int(padding / 2);
        for (layoutChild in layoutChildren){
            var computedHeight = layoutChild.view.getMinHeight();
            layoutChild.compute(drawList,x,y+currentY,layoutChild.view.getMinWidth(), computedHeight);
            currentY += computedHeight + padding;
        }
    }

    public function getMinWidth(layoutChildren : Array<LayoutChild<VerticalLayoutSpec>>):Int {
        var width = 0;
        for (child in layoutChildren){
            var childMinWidth = child.view.getMinWidth();
            if (width < childMinWidth){
                width = childMinWidth;
            }
        }
        return width;
    }

    public function getMinHeight(layoutChildren : Array<LayoutChild<VerticalLayoutSpec>>):Int {
        var height = Std.int(padding / 2);
        for (child in layoutChildren){
            height += child.view.getMinHeight() + padding;
        }
        return height;
    }


}
