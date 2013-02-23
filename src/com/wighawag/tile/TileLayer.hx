package com.wighawag.tile;

import com.wighawag.tile.MapLayer.LayerType;
import com.wighawag.tile.Tile;
import de.polygonal.ds.IntHashTable;
import msignal.Signal;

class TileLayer implements MapLayer{

    public var type(default,null) : LayerType;

    // TODO investigate other way to quick access to tile (specific hash table, bitmask quick test...)
	public var tiles: IntHashTable<Tile>;
	public var tileset : Tileset; // use for saving an map editor

	// TODO addsupport for parralax on the layer  (need to have transient state not saved when exporting ?
	public var tileWidth(default, null):Int;
	public var tileHeight(default, null):Int;

    public var onUpdated(default,null) : Signal0;

	public function new(tiles : IntHashTable<Tile>,tileset : Tileset, tileWidth : Int, tileHeight : Int) {
        onUpdated = new Signal0();
        type = LayerOfTiles;
		this.tiles = tiles;
		this.tileset = tileset;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
	}

	inline public function getTile(x:Int, y:Int):Tile {
		return tiles.get(key(x,y));
	}

	inline static public function key(x : Int, y : Int) : Int{
		return y | (x << 15);
	}

	inline static public function x(key : Int) : Int{
		return key >> 15;
	}

	inline static public function y(key : Int) : Int{
		return key & 0x00007FFF;
	}

	// public but should not be used by anyone
	inline public function setTile(x : Int, y: Int, tile : Tile) : Void{
		var tileKey : Int = key(x,y);
		var removedTile = tiles.clr(tileKey);
		if (tile != null){
			tiles.set(tileKey, tile);
		}
        onUpdated.dispatch();
	}

	inline public function getTileAt(x:Float, y:Float):Tile {
		var tileX = getTileX(x);
		var tileY = getTileY(y);
		return getTile(tileX, tileY);
	}

	inline public function topOf(y:Float):Float {
		return getTileY(y) * tileHeight;
	}

	inline public function leftOf(x:Float):Float {
		return getTileX(x) * tileWidth;
	}


	inline public function getTileX(x:Float):Int {
		return Math.floor(x / tileWidth);
	}

	inline public function getTileY(y:Float):Int {
		return Math.floor(y / tileHeight);
	}


}
