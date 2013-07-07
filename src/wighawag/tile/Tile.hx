/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.tile;
import wighawag.tile.Tileset;
import wighawag.asset.load.AssetManager;


enum PhysicalType{
    Solid; //"solid"
    Slope; //"slope "
    // TODO SlopeSupport; //"slopeSupport"  : this would allow more speed on going uphill (as these tiles would not block slope)
	Ladder; //"ladder"
    Mortal; //"mortal"
	None;   // this is the default
}

class Tile {
	public var id : Int; // usefull for saving

    public var spriteId(default, null) : AssetId;
	public var physicalType(default, null) : PhysicalType;
    public var slopeBegin : Int;
    public var slopeEnd : Int;

	// TODO support state and elapsedTIme (through a possible dictionnary state that associate (layer, x, y) to a State
	// TODO support other stuff (maybe through a component system, but maybe the cost in performance would be too big ?)
    public function new(id : Int, spriteId : AssetId, physicalType : PhysicalType, ?slopeBegin : Int = 0, ?slopeEnd : Int = 0) {
	    if (id < 1){
		    Report.anError("Tile", "tile should be greater than 0, 0 means no tile");
	    }
	    this.id = id;
        this.spriteId = spriteId;
	    this.physicalType = physicalType;
        this.slopeBegin = slopeBegin; //TODO might not need the actual slope Physical type ?
        this.slopeEnd = slopeEnd;
    }

}
