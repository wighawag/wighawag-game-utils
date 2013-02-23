package com.wighawag.asset.font;
import com.wighawag.asset.renderer.NMEDrawingContext;
class FontUtils {

    // TODO add more parameter
    inline static public function draw(fontFace : FontFace, context : NMEDrawingContext, text : String, x : Int, y : Int) : Void{
        var currentX = x;
        var currentY = y;

        for (i in 0...text.length){
            var glyphId = text.charCodeAt(i);
            var glyph = fontFace.get(glyphId);
            var subTexture = glyph.subTexture;
            var scaleX = 1.0;
            var scaleY = 1.0;
            context.drawScaledTexture(subTexture.bitmapAsset, subTexture.x, subTexture.y, subTexture.width, subTexture.height, currentX + glyph.xOffset, currentY + glyph.yOffset, scaleX, scaleY);
            currentX += Std.int(glyph.xAdvance * scaleX);
        }
    }




}
