/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.ui;
import wighawag.asset.font.FontFace;
import wighawag.asset.NinePatch;
import wighawag.asset.NinePatchUtils;
import wighawag.asset.load.Batch;
import wighawag.asset.load.BitmapAsset;

class BasicUIAssetProvider{

    public var ninePatches : Batch<NinePatch>;
    public var fontFaces : Batch<FontFace>;

    public function new(ninePatchBatch : Batch<NinePatch>, fontFaces : Batch<FontFace>) { // , fontBatch : Batch<Font>
        this.ninePatches = ninePatchBatch;
        this.fontFaces = fontFaces;
    }


    public function getRequiredBitmapAssets() : Array<BitmapAsset>{
        var bitmapAssets = NinePatchUtils.getBitmapAssets(ninePatches.all());

        // TODO make sure the font is not already part of a already added BitmapAsset
        for (fontFace in fontFaces.all()){
            bitmapAssets.push(fontFace.textureAtlas.bitmapAsset);
        }


        return bitmapAssets;
    }
}
