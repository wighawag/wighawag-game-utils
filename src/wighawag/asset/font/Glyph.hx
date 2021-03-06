/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.asset.font;

import wighawag.asset.load.BitmapAsset;
import wighawag.asset.spritesheet.SubTexture;

class Glyph {

    public var id(default, null) : Int;
    public var subTexture(default, null) : SubTexture;
    public var xOffset(default, null) : Int;
    public var yOffset(default, null) : Int;
    public var xAdvance(default, null) : Int;

    public function new(id : Int, subTexture : SubTexture, xOffset : Int, yOffset : Int, xAdvance : Int) {
        this.id = id;
        this.subTexture = subTexture;
        this.xOffset = xOffset;
        this.yOffset = yOffset;
        this.xAdvance = xAdvance;
    }
}
