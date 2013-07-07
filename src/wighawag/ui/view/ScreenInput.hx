/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.view;

enum ScreenInputState{
    None;
    Hover;
    Up;
    Down;
}

interface ScreenInput {
    public var x : Int;
    public var y : Int;
    public var state : ScreenInputState;
    public var target : UIElementView;

    function preRender() : Void;
    function postRender() : Void;

    function dispose() : Void;
}
