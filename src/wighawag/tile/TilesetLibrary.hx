/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.tile;
import wighawag.asset.load.Batch;
import wighawag.asset.load.Asset;
import wighawag.asset.load.AssetManager;
import wighawag.asset.load.TextAsset;
import promhx.Promise;

class TilesetLibrary {

	private var assetManager : AssetManager;
	private var promises : Hash<Promise<Tileset>>;
	private var batchPromises : Hash<Promise<Batch<Tileset>>>;

    public function new(assetManager : AssetManager) {
		this.assetManager = assetManager;
	    promises = new Hash();
	    batchPromises = new Hash();
    }


	public function fetch(id : String) : Promise<Tileset>{
		var promise = promises.get(id);
		if (promise == null){
			promise = new Promise();
			promises.set(id, promise);
			assetManager.load(id).then(function(asset : Asset): Void{
				var textAsset : TextAsset = cast(asset);
				promise.resolve(new Tileset(textAsset.text));
			});
		}
		return promise;
	}


	// TODO investigate a way to not duplicate the batch mechanism present in libraries/asssetManager (macro ?)
	public function fetchBatch(ids : Array<String>) : Promise<Batch<Tileset>>{
		// TODO sort alphabetically
		// TODO ensure the join block the possibility of having 1 combination of asset name equal to another combination
		var batchId = ids.join(":");

		var batchPromise = batchPromises.get(batchId);
		if (batchPromise != null){
			return batchPromise;
		}

		batchPromise = new Promise();
		batchPromises.set(batchId, batchPromise);

		var tilesetPromises = new Array<Promise<Tileset>>();
		for (id in ids){
			var p = fetch(id);
			tilesetPromises.push(p);
		}

		Promise.when(tilesetPromises).then(function(tilesets : Array<Tileset>): Void{
			batchPromise.resolve(new Batch<Tileset>(tilesets));
		});

		return batchPromise;
	}
}
