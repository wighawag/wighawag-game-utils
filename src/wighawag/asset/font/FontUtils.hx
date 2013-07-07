/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.asset.font;
using wighawag.view.TexturedQuadProgram;
class FontUtils {

    // TODO add more parameter
    inline static public function draw(fontFace : FontFace, program : TexturedQuadProgram, text : String, x : Int, y : Int) : Void{
        var currentX = x;
        var currentY = y;

        for (i in 0...text.length){
            var glyphId = text.charCodeAt(i);
            var glyph = fontFace.get(glyphId);
            var subTexture = glyph.subTexture;
            var scaleX = 1.0;
            var scaleY = 1.0;
            var actualX = currentX + glyph.xOffset;
            var actualY = currentY + glyph.yOffset;
            program.draw(subTexture.bitmapAsset.id, subTexture.x, subTexture.y, subTexture.width, subTexture.height, actualX, actualY, actualX + subTexture.width * scaleX, actualY + subTexture.height * scaleY);
            currentX += Std.int(glyph.xAdvance * scaleX);
        }
    }




}
