/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.core;

import wighawag.tile.ObjectLayer.ObjectPlacement;
import wighawag.system.EntityComponent;

class OriginalPlacement  implements EntityComponent{

    public var objectPlacement : ObjectPlacement;

    public function new(objectPlacement : ObjectPlacement) {
        this.objectPlacement = objectPlacement;
    }


    public function initialise():Void{

    }

}
