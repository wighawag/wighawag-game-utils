/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.asset;
import haxe.ds.StringMap;
import wighawag.asset.NinePatch;
import com.fermmtools.utils.ObjectHash;
using wighawag.view.TexturedQuadProgram;
import wighawag.asset.spritesheet.TextureAtlas;
import wighawag.asset.spritesheet.SubTexture;
import wighawag.asset.load.BitmapAsset;
class NinePatchUtils {
    inline static public function draw(ninePatch : NinePatch, program : TexturedQuadProgram, x : Int, y : Int, width : Int, height : Int) : Void{

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

                program.draw(ninePatch.bitmapAsset.id, patch.x, patch.y, patch.width, patch.height, currentX, currentY, currentX + patch.width * scaleX, currentY + patch.height * scaleY);

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

    inline static public function drawAccordingToContentSize(ninePatch : NinePatch, program : TexturedQuadProgram, x : Int, y : Int, width : Int, height : Int) : Void{
        draw(ninePatch, program, x, y, width + ninePatch.nonContentWidth, height + ninePatch.nonContentHeight );
    }

    inline static public function drawAccordingToContentWidth(ninePatch : NinePatch, program : TexturedQuadProgram, x : Int, y : Int, width : Int, height : Int) : Void{
        draw(ninePatch, program, x, y, width + ninePatch.nonContentWidth, height);
    }

    inline static public function drawAccordingToContentHeight(ninePatch : NinePatch, program : TexturedQuadProgram, x : Int, y : Int, width : Int, height : Int) : Void{
        draw(ninePatch, program, x, y, width, height + ninePatch.nonContentHeight);
    }



    inline static public function getTextureAtlases(ninePatches : Array<NinePatch>) : Array<TextureAtlas>{
        var textureAtlases : Array<TextureAtlas> = new Array();

        var textures : ObjectHash<BitmapAsset, StringMap<SubTexture>> = new ObjectHash();

        for (ninePatch in ninePatches){

            var textureHash = textures.get(ninePatch.bitmapAsset);
            if (textureHash == null){
                textureHash = new StringMap<SubTexture>();
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
        var set : StringMap<Bool> = new StringMap();

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
