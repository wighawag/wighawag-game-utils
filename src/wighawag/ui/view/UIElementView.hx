/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.view;

import wighawag.view.TexturedQuadProgram;

interface UIElementView {
    function addToDrawList(drawList : Array<ViewPositioning>, x : Int, y : Int, width : Int, height : Int) : Void;
    function draw(context : TexturedQuadProgram, x : Int, y : Int, width : Int, height : Int, screenInput : ScreenInput) : Void;
    public function getMinWidth() : Int;
    public function getMinHeight() : Int;

    //TODO add preferedWidth, preferedHeight, maxWidth, maxHeight
}
