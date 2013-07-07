/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.view;
class ViewPositioning {

    public var view : UIElementView;
    public var x : Int;
    public var y : Int;
    public var width : Int;
    public var height : Int;

    public function new(view : UIElementView, x : Int, y : Int, width : Int, height : Int) {
        this.view = view;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}
