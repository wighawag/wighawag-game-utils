package com.wighawag.tile;

import com.wighawag.tile.ObjectLayer.ObjectPlacement;
import format.tools.Deflate;
import format.tools.Inflate;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import promhx.Promise;
import com.wighawag.asset.load.AssetManager;
import com.wighawag.asset.load.BytesAsset;
import com.wighawag.asset.load.Asset;
import com.wighawag.asset.load.Batch;
import com.wighawag.core.AssetComponent;
import de.polygonal.ds.IntHashTable;
import de.polygonal.ds.IntIntHashTable;
import com.wighawag.asset.entity.EntityTypeLibrary;
import com.wighawag.system.EntityType;

class TileMapManager {

	private var assetManager:AssetManager;
	private var tilesetLibrary:TilesetLibrary;
    private var entityTypeLibrary : EntityTypeLibrary;

	private var promises:Hash<Promise<TileMap>>;

	public function new(assetManager:AssetManager, tilesetLibrary:TilesetLibrary, entityTypeLibrary : EntityTypeLibrary) {
		promises = new Hash();
		this.assetManager = assetManager;
		this.tilesetLibrary = tilesetLibrary;
        this.entityTypeLibrary = entityTypeLibrary;
	}

	public function save(tileMap:TileMap):Bytes {
		var bytesOutput:BytesOutput = new BytesOutput();

		bytesOutput.writeInt31(5); // version 5

		bytesOutput.writeInt31(tileMap.id.length); //string lenght
		bytesOutput.writeString(tileMap.id); //string

		bytesOutput.writeInt31(Std.int(tileMap.worldBounds.width)); // in world coordinate not in tile coordinate
		bytesOutput.writeInt31(Std.int(tileMap.worldBounds.height));

		var numOfLayers = tileMap.numOfLayers();
		bytesOutput.writeInt31(numOfLayers); // number of layers

		for (layerIndex in 0...numOfLayers) {
			var layer = tileMap.getLayer(layerIndex);
            switch(layer.type){
                case LayerOfTiles:
                    bytesOutput.writeInt8(1);
                    var tileLayer : TileLayer = cast(layer);
                    var tileSetId = tileLayer.tileset.id;

                    bytesOutput.writeInt31(tileSetId.length); // string length
                    bytesOutput.writeString(tileSetId); //string

                    bytesOutput.writeInt31(tileLayer.tileWidth); //tileWidth
                    bytesOutput.writeInt31(tileLayer.tileHeight); //tileHeight

                    bytesOutput.writeInt31(tileLayer.tiles.size());

                    for (key in tileLayer.tiles.keys()){
                        bytesOutput.writeInt31(key);
                        bytesOutput.writeInt31(tileLayer.tiles.get(key).id);
                    }
                case LayerOfObjects:
                    bytesOutput.writeInt8(2);
                    var objectLayer : ObjectLayer = cast(layer);
                    var objectHash = new Hash<Array<Float>>();
                    var numTypes : Int = 0;
                    for (object in objectLayer.objects){
                        var currentTypeName : String = object.entityType.id;
                        var values = objectHash.get(currentTypeName);
                        if(values == null){
                            values = new Array<Float>();
                            objectHash.set(currentTypeName, values);
                            numTypes ++;
                        }
                        values.push(object.x);
                        values.push(object.y);
                        values.push(object.width);
                        values.push(object.height);
                    }

                    bytesOutput.writeInt31(numTypes);

                    for(typeName in objectHash.keys()){
                        bytesOutput.writeInt31(typeName.length);
                        bytesOutput.writeString(typeName);
                        var values = objectHash.get(typeName);
                        bytesOutput.writeInt31(Std.int(values.length / 4));
                        for(value in values){
                            bytesOutput.writeFloat(value);
                        }
                    }
            }

		}

		return Deflate.run(bytesOutput.getBytes());
	}


	public function fetch(id:String):Promise<TileMap> {
		var promise = promises.get(id);
		if (promise == null) {
			promise = new Promise();

			promises.set(id, promise);

			assetManager.load(id).then(function(asset:Asset):Void {
				var byteAssets:BytesAsset = cast(asset);
				load(promise, byteAssets.bytes);

			});
		}

		return promise;
	}

	public function loadFromBytes(bytes : Bytes) : Promise<TileMap>{
		var promise : Promise<TileMap> = new Promise();
		load(promise, bytes);
		return promise;
	}

	private function load(promise : Promise<TileMap>, bytes:Bytes):Void {

		var uncompressedBytes = Inflate.run(bytes);

		var bytesInput = new BytesInput(uncompressedBytes);

		var version = bytesInput.readInt31();
		if(version > 5){
			Report.anError("TileMap", "version " + version + " not supported");
        }else if (version == 5) {
            parseVersion5(bytesInput, promise);
        }else if (version == 4|| version == 3) {
            Report.anError("TileMap", "version " + version + " not supported anymore");
		} else {
			parseVersion1or2(bytesInput, promise, version);

		}
	}


	private function parseVersion5(bytesInput : BytesInput, promise : Promise<TileMap>) : Void{

		var tileMapId = bytesInput.readString(bytesInput.readInt31());

		var worldWidth = bytesInput.readInt31();
		var worldHeight = bytesInput.readInt31();

		var numOfLayers = bytesInput.readInt31();

		var tilesetsToFetch = new Array<String>();
		var tilesetsHash = new Hash<Bool>();

		var partialLayers = new Array<Dynamic>();
		for (layerIndex in 0...numOfLayers) {
            var type = bytesInput.readInt8();
            if(type == 1){
                var tileSetId = bytesInput.readString(bytesInput.readInt31());

                if (!tilesetsHash.exists(tileSetId)){
                    tilesetsHash.set(tileSetId, true);
                    tilesetsToFetch.push(tileSetId);
                }

                var tileWidth = bytesInput.readInt31();
                var tileHeight = bytesInput.readInt31();

                var numKeys = bytesInput.readInt31();

                var tileIds = new IntIntHashTable(4096); // TODO set values according to lenght (numKeys)
                for (i in 0...numKeys){
                    var key = bytesInput.readInt31();
                    var tileId = bytesInput.readInt31();
                    tileIds.set(key, tileId);
                }

                partialLayers.push(new IdTileLayer(tileIds, tileSetId, tileWidth, tileHeight));
            }else if (type == 2){
                var objectPlacements = new Array<ObjectPlacement>();
                var numTypes = bytesInput.readInt31();
                for(i in 0...numTypes){
                    var entityTypeName = bytesInput.readString(bytesInput.readInt31());
                    var numObjectsOfThisType = bytesInput.readInt31();
                    for(i in 0...numObjectsOfThisType){
                        var x = bytesInput.readFloat();
                        var y = bytesInput.readFloat();
                        var width = bytesInput.readFloat();
                        var height = bytesInput.readFloat();

                        objectPlacements.push({x:x,y:y,width:width, height:height,entityType:entityTypeLibrary.get(entityTypeName)});
                    }
                }
                partialLayers.push(new ObjectLayer(objectPlacements));

            }

		}


		//fetch all necessary tileset
		tilesetLibrary.fetchBatch(tilesetsToFetch).then(function(tilesetBatch : Batch<Tileset>) : Void{
			var layersArray : Array<MapLayer> = new Array();
			for (partialLayer in partialLayers){
                if(Std.is(partialLayer, IdTileLayer)){
                    var idLayer : IdTileLayer = cast(partialLayer);
                    var tiles : IntHashTable<Tile> = new IntHashTable(4096); // TODO ste value depending on size of the map
                    var tileset = tilesetBatch.get(idLayer.tilesetId);

                    for (tileIdKey in idLayer.tileIds.keys()){
                        var _tileId : Null<Int> = idLayer.tileIds.get(tileIdKey);
                        var tileId = _tileId == null ? 0 : _tileId;
                        var tile = tileset.get(tileId);
                        tiles.set(tileIdKey, tile);
                    }
                    layersArray.push(new TileLayer(tiles, tileset, idLayer.tileWidth, idLayer.tileHeight));
                }else if(Std.is(partialLayer, ObjectLayer)){
                    layersArray.push(partialLayer);
                }

			}

			promise.resolve(new TileMap(tileMapId, layersArray, worldWidth, worldHeight));
		});

	}

	private function parseVersion1or2(bytesInput : BytesInput, promise : Promise<TileMap>, version : Int) : Void{
		var type : Int = 0;
		if (version == 2){
			type = bytesInput.readInt31();
		}

		if (type != 0){     // TODO type 1
			Report.anError("TileMap", "type " + type + " not supported");
			return;
		}

		var tileIds:Array<Array<Array<Int>>> = new Array();
		var tilesetForLayer = new Array<String>();
		var id:String;

		// TODO get rid of this this should be per layer
		var x:Int = 0;
		var y:Int = 0;
		var width:Int = 0;
		var height:Int = 0;
		var tileWidth:Int = 0;
		var tileHeight:Int = 0;

		id = bytesInput.readString(bytesInput.readInt31());

		var numLayers = bytesInput.readInt31();
		for (i in 0...numLayers) {
			var layer = new Array<Array<Int>>();
			var tilesetId = bytesInput.readString(bytesInput.readInt31()); // tilesetId
			tilesetForLayer.push(tilesetId);


			x = bytesInput.readInt31(); // layer x
			y = bytesInput.readInt31(); // layer y
			width = bytesInput.readInt31(); // layer width
			height = bytesInput.readInt31(); // layer width
			tileWidth = bytesInput.readInt31(); // layer width
			tileHeight = bytesInput.readInt31(); // layer width

			for (y in 0...height) {
				var row = new Array<Int>();
				for (x in 0...width) {
					var tileId = bytesInput.readInt31();
					row.push(tileId);
				}
				layer.push(row);
			}

			tileIds.push(layer);
		}

		// Remove duplicates
		var tilesetsToFetch = new Array<String>();
		var tilesetsHash = new Hash<Bool>();
		for(tilesetId in tilesetForLayer){
			if (!tilesetsHash.exists(tilesetId)){
				tilesetsHash.set(tilesetId, true);
				tilesetsToFetch.push(tilesetId);
			}
		}

		//fetch all necessary tileset
		tilesetLibrary.fetchBatch(tilesetsToFetch).then(function(tilesetBatch : Batch<Tileset>) : Void{
			var layersArray : Array<MapLayer> = new Array();
			var layerIndex : Int = 0;
			for (layerId in tileIds){
				var tiles : IntHashTable<Tile> = new IntHashTable(1024); // TODO ste value depending on size of the map
				var tileset = tilesetBatch.get(tilesetForLayer[layerIndex]);
				var rowIndex = 0;
				for(rowId in layerId){
					var colIndex = 0;
					for(colId in rowId){
						if (colId != 0){
							tiles.set(TileLayer.key(colIndex, rowIndex) ,tileset.get(colId));
						}
						colIndex++;
					}
					rowIndex ++;
				}
				layersArray.push(new TileLayer(tiles, tileset, tileWidth, tileHeight));
				layerIndex ++;
			}

			promise.resolve(new TileMap(id, layersArray, width * tileWidth, height * tileHeight));
		});

	}


    public static function getRequiredSprites(tileMap : TileMap) : Array<AssetId>{
        var spriteIds : Array<String> = new Array();
        var numLayers = tileMap.numOfLayers();
        for (i in 0...numLayers){
            var layer = tileMap.getLayer(i);
            if(Std.is(layer, ObjectLayer)){
                var objectLayer : ObjectLayer = cast(layer);
                for (object in objectLayer.objects){
                    if(object.entityType != null){
                        var assetComponent = object.entityType.get(AssetComponent);
                        if(assetComponent != null){
                            spriteIds.push(assetComponent.assetId);
                        }
                    }else{
                        Report.aWarning("TileMapManager", "an objetc without entityType ?");
                    }

                }
            }else if(Std.is(layer, TileLayer)){
                var tileLayer : TileLayer = cast(layer);
                spriteIds = spriteIds.concat(Tileset.getSpriteIds(tileLayer.tileset));
            }
        }
        return spriteIds;
    }

}


class IdTileLayer {
	public var tileIds : IntIntHashTable;
	public var tilesetId : String;
	public var tileWidth : Int;
	public var tileHeight : Int;

    public function new(tileIds : IntIntHashTable,tilesetId : String, tileWidth : Int,tileHeight : Int){
        this.tileIds = tileIds;
        this.tilesetId = tilesetId;
        this.tileWidth = tileWidth;
        this.tileHeight = tileHeight;

    }
}