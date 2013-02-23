package com.wighawag.asset;
import com.wighawag.asset.NinePatch;
import com.fermmtools.utils.ObjectHash;
import com.wighawag.asset.renderer.NMEDrawingContext;
import com.wighawag.asset.spritesheet.TextureAtlas;
import com.wighawag.asset.spritesheet.SubTexture;
import com.wighawag.asset.load.BitmapAsset;
class NinePatchUtils {
    inline static public function draw(ninePatch : NinePatch, context : NMEDrawingContext, x : Int, y : Int, width : Int, height : Int) : Void{

        var currentX = x;
        var currentY = y;

        for (patchRow in ninePatch.leftRightTopDownOrderedPatches){
            var scaleX = 1.0;
            var scaleY = 1.0;

            var pHeight : Int = 0;

            for (patch in patchRow){

                if (patch.scaleHorizontally){
                    scaleX = (width - ninePatch.fixedWidth)/ninePatch.scalableWidth;
                }else{
                    scaleX = 1;
                }


                if (patch.scaleVertically){
                    scaleY = (height - ninePatch.fixedHeight)/ninePatch.scalableHeight;
                }else{
                    scaleY = 1;
                }

                context.drawScaledTexture(ninePatch.bitmapAsset, patch.x, patch.y, patch.width, patch.height, currentX, currentY, scaleX, scaleY);

                currentX += Std.int(scaleX * patch.width);
                pHeight = patch.height;

            }
            currentX = x;
            currentY += Std.int(scaleY * pHeight);
        }
    }

    inline static public function getWidthFromContentWidth(ninePatch : NinePatch, width : Int) : Int{
        return width + ninePatch.nonContentWidth;
    }
    inline static public function getHeightFromContentHeight(ninePatch : NinePatch, height : Int) : Int{
        return height + ninePatch.nonContentHeight;
    }

    inline static public function drawAccordingToContentSize(ninePatch : NinePatch, context : NMEDrawingContext, x : Int, y : Int, width : Int, height : Int) : Void{
        draw(ninePatch, context, x, y, width + ninePatch.nonContentWidth, height + ninePatch.nonContentHeight );
    }

    inline static public function drawAccordingToContentWidth(ninePatch : NinePatch, context : NMEDrawingContext, x : Int, y : Int, width : Int, height : Int) : Void{
        draw(ninePatch, context, x, y, width + ninePatch.nonContentWidth, height);
    }

    inline static public function drawAccordingToContentHeight(ninePatch : NinePatch, context : NMEDrawingContext, x : Int, y : Int, width : Int, height : Int) : Void{
        draw(ninePatch, context, x, y, width, height + ninePatch.nonContentHeight);
    }



    inline static public function getTextureAtlases(ninePatches : Array<NinePatch>) : Array<TextureAtlas>{
        var textureAtlases : Array<TextureAtlas> = new Array();

        var textures : ObjectHash<BitmapAsset, Hash<SubTexture>> = new ObjectHash();

        for (ninePatch in ninePatches){

            var textureHash = textures.get(ninePatch.bitmapAsset);
            if (textureHash == null){
                textureHash = new Hash<SubTexture>();
                textures.set(ninePatch.bitmapAsset, textureHash);
            }
            for (patchRow in ninePatch.leftRightTopDownOrderedPatches){
                for (patch in patchRow){
                    var textureId = "patch" + patch.x + "." + patch.y;
                    textureHash.set(textureId,new SubTexture(textureId, ninePatch.bitmapAsset, patch.x, patch.y, patch.width, patch.height, 0,0, patch.width, patch.height));
                }
            }

        }

        for (bitmapAsset in textures.keys()){
            textureAtlases.push(new TextureAtlas(bitmapAsset.id, bitmapAsset, textures.get(bitmapAsset)));
        }


        return textureAtlases;
    }

    inline static public function getBitmapAssets(ninePatches : Array<NinePatch>) : Array<BitmapAsset>{
        var bitmapAssets : Array<BitmapAsset> = new Array();
        var set : Hash<Bool> = new Hash();

        for (ninePatch in ninePatches){
            var alreadyPresent = set.exists(ninePatch.bitmapAsset.id);
            if (!alreadyPresent){
                set.set(ninePatch.bitmapAsset.id, true);
                bitmapAssets.push(ninePatch.bitmapAsset);
            }
        }

        return bitmapAssets;
    }
}
