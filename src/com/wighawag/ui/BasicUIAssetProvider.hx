package com.wighawag.ui;
import com.wighawag.asset.font.FontFace;
import com.wighawag.asset.NinePatch;
import com.wighawag.asset.NinePatchUtils;
import com.wighawag.asset.load.Batch;
import com.wighawag.asset.load.BitmapAsset;

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
