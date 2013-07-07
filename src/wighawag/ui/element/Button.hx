/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui.element;

import wighawag.ui.view.ViewPositioning;
import wighawag.ui.view.ScreenInput;
import wighawag.ui.BasicUIAssetProvider;
import wighawag.ui.BasicUIAssetProvider;
import wighawag.asset.NinePatch;
using wighawag.asset.NinePatchUtils;
using wighawag.asset.font.FontUtils;
import wighawag.asset.font.FontFace;
import wighawag.ui.UIComponent;
import wighawag.ui.content.UIContent;
import wighawag.ui.view.UIElementView;
import wighawag.ui.view.UIViewProvider;
import wighawag.ui.view.Container;
import wighawag.ui.core.UIActionElement;
import msignal.Signal;

import wighawag.view.TexturedQuadProgram;

typedef ButtonSpec = {textId : String};

typedef ButtonStyle = {enabledAssetId : String, hoverAssetId : String, clickedAssetId : String, disabledAssetId : String, font : String}

enum ButtonState{
    Normal;
    Hover;
    Clicked;
    Disabled;
}

class Button implements UIComponent<BasicUIAssetProvider, ButtonSpec, ButtonStyle> implements UIActionElement{

    public var id : String;

    public var enabled(default, set_enabled) : Bool;

    public var onTriggered(default, null) : Signal1<UIActionElement>;

    public var textId : String;

    public var state : ButtonState;

    public function new() {
        enabled = true;
        onTriggered = new Signal1();
        state = ButtonState.Normal;
    }

    private function set_enabled(value : Bool) : Bool{
        enabled = value;
        if (value == false){
            state = ButtonState.Disabled;
        }
        return enabled;
    }

    public function createView(uiAssetProvider : BasicUIAssetProvider, style:ButtonStyle):UIElementView {
        return new ButtonView(this, uiAssetProvider, style);
    }

    public function setId(id:String):Void {
        this.id = id;
    }

    public function setContent(content:ButtonSpec):Void {
        this.textId = content.textId;
    }


}

class ButtonView implements UIElementView{

    private var button : Button;
    private var uiAssetProvider : BasicUIAssetProvider;
    private var style : ButtonStyle;
    private var font : FontFace;


    public function new(button : Button, uiAssetProvider : BasicUIAssetProvider, style : ButtonStyle){
        this.button = button;
        this.uiAssetProvider = uiAssetProvider;
        this.style = style;
        this.font = uiAssetProvider.fontFaces.get(style.font);
    }

    public function getMinContentWidth() : Int{
        return font.widthOf(getText()); // TODO cache and update when button content is updated
    }

    public function getMinContentHeight() : Int{
        return font.heightOf(getText()); // TODO cache and update when button content is updated
    }

    private function getText() : String{
        // TODO use textId to fetch translation
        return button.textId;
    }

    public function getMinWidth() : Int{
        return getCurrentNinePatch().getWidthFromContentWidth(getMinContentWidth());
    }

    public function getMinHeight() : Int{
        return getCurrentNinePatch().getHeightFromContentHeight(getMinContentHeight());
    }

    public function addToDrawList(drawList:Array<ViewPositioning>,x : Int, y : Int, width : Int, height : Int):Void {
        drawList.push(new ViewPositioning(this,x,y,width,height));
    }


    public function draw(program:TexturedQuadProgram, x:Int, y:Int, width:Int, height:Int, screenInput : ScreenInput):Void {

        if (screenInput.target == this){
            switch(screenInput.state){
                case ScreenInputState.Hover:
                    button.state = ButtonState.Hover;
                case ScreenInputState.None:
                    button.state = ButtonState.Normal;
                case ScreenInputState.Up:
                    button.state = ButtonState.Clicked;
                    button.onTriggered.dispatch(button);
                case ScreenInputState.Down:
                    button.state = ButtonState.Clicked;
            }
        }else{
            // mouse out ?
            button.state = ButtonState.Normal;
        }


        var ninePatch = getCurrentNinePatch();

        var text = getText();

        if(width == 0){
            width = getMinHeight();
        }

        // TODO word wrap ?
        if(height == 0){
            height = getMinHeight();
        }

	    var textWidth = font.widthOf(text);
	    var textHeight = font.heightOf(text);
	    var textX = Std.int(x + ninePatch.contentXOffset + (width - ninePatch.nonContentWidth) / 2 - textWidth /2);
	    var textY = Std.int(y + ninePatch.contentYOffset + (height - ninePatch.nonContentHeight) / 2 - textHeight / 2);


        ninePatch.draw(program, x, y, width, height);

        font.draw(program, text,textX, textY);
    }


    inline private function getCurrentNinePatch() : NinePatch{
        var assetId : String;
        switch(button.state){
            case ButtonState.Disabled: assetId = style.disabledAssetId;
            case ButtonState.Hover: assetId = style.hoverAssetId;
            case ButtonState.Clicked: assetId = style.clickedAssetId;
            case ButtonState.Normal: assetId = style.enabledAssetId;
        }

        return uiAssetProvider.ninePatches.get(assetId);
    }

}
