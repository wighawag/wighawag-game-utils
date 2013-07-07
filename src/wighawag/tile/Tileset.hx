/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.tile;

import wighawag.tile.Tile;
import haxe.xml.Fast;
import wighawag.asset.load.AssetManager;
import wighawag.asset.load.Asset;
import de.polygonal.ds.IntHashTable;

class Tileset implements Asset{

	public var id : AssetId;
	private var tiles : IntHashTable<Tile>;  // TODO think whether we can instead use an array and do some validation on xml so that index follow each other?

    public function new(data : String) {
	    tiles = new IntHashTable(512); // TODO set correct value

        var xml = new Fast(Xml.parse(data).firstElement());

	    id = xml.att.id;

	    for (tileXml in xml.nodes.tile){
		    var tileId : Int = Std.parseInt(tileXml.att.id);
		    // TODO do some validation
		    var spriteId : String = tileXml.att.spriteId;
		    var physicalType : PhysicalType = switch(tileXml.att.physicalType){
			                                    case "solid" :
			                                        PhysicalType.Solid;
                                                case "slope" :
                                                    PhysicalType.Slope;
                                                case "mortal" :
                                                    PhysicalType.Mortal;
			                                    case "ladder":
				                                    PhysicalType.Ladder;
			                                    default :
			                                        PhysicalType.None;
		                                    };

            var slopeBegin = 0;
            if(tileXml.has.slopeBegin){
                slopeBegin = Std.parseInt(tileXml.att.slopeBegin);
            }
            var slopeEnd = 0;
            if(tileXml.has.slopeEnd){
                slopeEnd = Std.parseInt(tileXml.att.slopeEnd);
            }

		    var firstTime =tiles.setIfAbsent(tileId, new Tile(tileId, spriteId, physicalType, slopeBegin, slopeEnd));
		    if (!firstTime){
			    Report.anError("Tileset", "Tile with id  " + tileId + " already exist");
		    }

	    }
    }

	public function get(tileId : Int) : Tile{
		return tiles.get(tileId);
	}

	inline static public function getSpriteIds(tileset  : Tileset) : Array<AssetId>{
		var spriteIds : Array<AssetId> = new Array();
		var hash : Hash<Bool> = new Hash();
		for (tile in tileset.tiles){
			if(!hash.get(tile.spriteId)){
				hash.set(tile.spriteId, true);
				spriteIds.push(tile.spriteId);
			}
		}
		return spriteIds;
	}
}
