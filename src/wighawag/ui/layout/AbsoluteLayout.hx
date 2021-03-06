/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.layout;

import wighawag.ui.view.ViewPositioning;
import wighawag.ui.view.LayoutAlgorithm;
import wighawag.ui.view.LayoutChild;
import wighawag.ui.view.Layout;

typedef AbsoluteLayoutSpec = {x : Int, y : Int};
typedef AbsoluteLayoutParams = {};

class AbsoluteLayout implements LayoutAlgorithm<AbsoluteLayoutSpec, AbsoluteLayoutParams>{


    public function new(){
    }

    public function setParameters(parameters : AbsoluteLayoutParams) : Void{

    }

    public function compute(drawList : Array<ViewPositioning>, layoutChildren:Array<LayoutChild<AbsoluteLayoutSpec>>, x : Int, y : Int, width : Int, height : Int) : Void{
        for (layoutChild in layoutChildren){
            layoutChild.compute(drawList, x + layoutChild.layoutSpec.x, y + layoutChild.layoutSpec.y, layoutChild.view.getMinWidth(),layoutChild.view.getMinHeight());
        }
    }


    public function getMinWidth(layoutChildren : Array<LayoutChild<AbsoluteLayoutSpec>>):Int {
        // TODO ?
        var width = 0;
        for (child in layoutChildren){
            width += child.view.getMinWidth();
        }
        return width;
    }

    public function getMinHeight(layoutChildren : Array<LayoutChild<AbsoluteLayoutSpec>>):Int {
        // TODO?
        var height = 0;
        for (child in layoutChildren){
            height += child.view.getMinHeight();
        }
        return height;
    }



}
