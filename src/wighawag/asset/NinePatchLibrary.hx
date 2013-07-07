/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.asset;

import wighawag.asset.load.Batch;
import wighawag.asset.spritesheet.TextureAtlas;
import wighawag.asset.spritesheet.TextureAtlasLibrary;
import promhx.Promise;

//TODO separate ti from TextureAtlas ?
class NinePatchLibrary {

    private var textureAtlasLibrary : TextureAtlasLibrary;
    private var promises : Hash<Promise<Batch<NinePatch>>>;


    public function new(textureAtlasLibrary : TextureAtlasLibrary) {
        this.promises = new Hash();
        this.textureAtlasLibrary = textureAtlasLibrary;
    }

    public function fetchSkin(id : String) : Promise<Batch<NinePatch>>{
        var promise = promises.get(id);
        if (promise == null){
            promise = new Promise();
            promises.set(id, promise);
            textureAtlasLibrary.fetch(id).then(function(textureAtlas : TextureAtlas):Void{
                var ninePatchSet : Array<NinePatch> = new Array();
                for (subTexture in textureAtlas.textures){
                    ninePatchSet.push(new NinePatch(subTexture.id, subTexture));
                }
                promise.resolve(new Batch<NinePatch>(ninePatchSet));
            });
        }
        return promise;
    }

}
