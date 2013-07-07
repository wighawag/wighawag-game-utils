/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.view;
class LayoutChild<LayoutSpec> {

    public var view(default, null) : UIElementView;
    public var layoutSpec(default, null) : LayoutSpec;

    public function new(view : UIElementView, layoutSpec : LayoutSpec) {
        this.view = view;
        this.layoutSpec = layoutSpec;
    }

    public function compute(drawList : Array<ViewPositioning>, x : Int, y : Int, width : Int, height : Int) : Void{
        view.addToDrawList(drawList,x,y,width,height);
    }
}
