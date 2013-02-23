package com.wighawag.ui.view;
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
