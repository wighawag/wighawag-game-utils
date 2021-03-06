/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.asset.font;

import wighawag.asset.load.AssetManager;
import wighawag.asset.load.Batch;
import wighawag.asset.load.Asset;
import wighawag.asset.load.TextAsset;
import wighawag.asset.load.BitmapAsset;
import wighawag.report.Report;
import promhx.Promise;

import haxe.ds.StringMap;

// TODO support font as a set of fontface
class FontFaceLibrary {

    private var assetManager : AssetManager;
    public var promises : StringMap<Promise<FontFace>>;
    private var batchPromises : StringMap<Promise<Batch<FontFace>>>;

    public function new (assetManager : AssetManager) {
        this.assetManager = assetManager;
        promises = new StringMap();
        batchPromises = new StringMap();
    }


    public function fetch(id : String) : Promise<FontFace>{
        var promise = promises.get(id);
        if (promise == null){
            promise = new Promise();

            promises.set(id, promise);

            assetManager.loadBatch([id+".bitmap", id+".font"]).then(function(assets : Batch<Asset>): Void{
                var bitmapAsset : BitmapAsset = cast(assets.get(id+".bitmap"));
                var textAsset : TextAsset = cast(assets.get(id+".font"));
                var glyphs = new StringMap<Glyph>();
                var parser = new XMLAngelCodeFontParser(id, bitmapAsset, textAsset.text);
                var fontFace = parser.parse();
                promise.resolve(fontFace);

            });
        }

        return promise;
    }


    // TODO investigate a way to not duplicate the batch mechanism present in libraries/asssetManager (macro ?)
    public function fetchBatch(ids : Array<String>) : Promise<Batch<FontFace>>{
        // TODO sort alphabetically
        // TODO ensure the join block the possibility of having 1 combination of asset name equal to another combination
        var batchId = ids.join(":");

        var batchPromise = batchPromises.get(batchId);
        if (batchPromise != null){
            return batchPromise;
        }

        batchPromise = new Promise();
        batchPromises.set(batchId, batchPromise);

        var fontFacePromises = new Array<Promise<FontFace>>();
        for (id in ids){
            var p = fetch(id);
            fontFacePromises.push(p);
        }

        Promise.when(fontFacePromises).then(function(fontFaces : Array<FontFace>): Void{
            batchPromise.resolve(new Batch<FontFace>(fontFaces));
        });


        return batchPromise;
    }

}
