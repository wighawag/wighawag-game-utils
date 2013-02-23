package com.wighawag.tile;

import nme.geom.Rectangle;
import com.wighawag.tile.Tile;

import de.polygonal.ds.IntHashTable;

import msignal.Signal;

class TileMap {

	public var id(default, null) : String;
    public var worldBounds :Rectangle; // specify the bounds in world coordinate (not in tile coordinate)
	private var mapLayers : Array<MapLayer>;
	private var computeRectangle : Rectangle;
    public var onUpdated : Signal0;


	public function new(id : String, layers : Array<MapLayer>, width : Int, height : Int) {
        onUpdated = new Signal0();
		computeRectangle = new Rectangle();
		this.id = id;
		this.mapLayers = layers;
        for(layer in layers){
            layer.onUpdated.add(function():Void{
               onUpdated.dispatch();
            });
        }
		setSize(width, height);
	}

	public function setSize(width : Int, height : Int):Void{
		if(worldBounds == null){
			worldBounds = new Rectangle();
		}
		worldBounds.width = width;
		worldBounds.height = height;
	}

	private function isInTheBoundary(rectangle : Rectangle) : Bool{
		return worldBounds.containsRect(rectangle);
	}

	public function getLayer(layerIndex : Int) : MapLayer{
		return mapLayers[layerIndex];
	}

	public function numOfLayers() : Int{
		return mapLayers.length;
	}


	public function setTileAt(tile:Tile, x:Float, y:Float, layer : TileLayer):Void {
		var tileX = layer.getTileX(x);
		var tileY = layer.getTileY(y);
		computeRectangle.x = tileX;
		computeRectangle.y = tileY;
		computeRectangle.width = layer.tileWidth;
		computeRectangle.height = layer.tileHeight;
		if (isInTheBoundary(computeRectangle)) {
			layer.setTile(tileX,tileY, tile);
		}else if(tile != null){

			var diffX : Int = 0;
			var diffY : Int = 0;
			var newWidth = worldBounds.width;
			var newHeight = worldBounds.height;
			var tileRight = (tileX + 1) * layer.tileWidth;
			if(tileRight > worldBounds.width){
				newWidth = tileRight;
			}
			var tileBottom = (tileY +1) * layer.tileHeight;
			if(tileBottom >= worldBounds.height){
				newHeight = tileBottom;
			}
			if (tileX < 0 || tileY < 0){

				if (tileX < 0){
					diffX = -tileX;
					newWidth = worldBounds.width + layer.tileWidth * diffX;
				}
				if (tileY < 0){
					diffY = -tileY;
					newHeight = worldBounds.height + layer.tileHeight * diffY;
				}
				var newPositions = new Array<NewTilePosition>();
				for (key in layer.tiles.keys()){
					var tileToMove = layer.tiles.get(key);
					layer.tiles.clr(key);
					var x = TileLayer.x(key);
					var y = TileLayer.y(key);
					newPositions.push({tile:tileToMove, x : x + diffX, y : y + diffY});
				}
				for(position in newPositions){
					layer.setTile(position.x, position.y, position.tile);
				}
			}
			layer.setTile(tileX + diffX, tileY + diffY, tile);
			setSize(Std.int(newWidth), Std.int(newHeight));
		}
	}

	// TODO improve ? or remove ?
	public function clear(width : Int, height : Int) : Void{
        var tileLayer : TileLayer = cast(mapLayers[0]);
		var tileset = tileLayer.tileset;
		var tileWidth = tileLayer.tileWidth;
		var tileHeight = tileLayer.tileHeight;
		this.mapLayers = [new TileLayer(new IntHashTable<Tile>(1024),tileset, tileWidth, tileHeight), mapLayers[1]]; // mapLayer[1] being object layer
		setSize(width, height);

        onUpdated.dispatch();
	}



}


typedef NewTilePosition = {
	tile : Tile,
	x : Int,
	y : Int
};